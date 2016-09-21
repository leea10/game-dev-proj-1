package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.group.FlxSpriteGroup;
import haxe.io.Path;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;

/**
 * Parses data for entities in either / both universe and splits them into separate FlxSpriteGroups for the main level to use.
 * DOES NOT INTERACT WITH THE PLAYSTATE - The playstate pulls the created groups of entities from this parser.
 * @author Ariel Lee
 */
class TiledLevel extends TiledMap
{	
	// Holds the object groups for the different world groups (light, dark, both)
	public var _worlds:Map<String, WorldGroup>;
	public var _floorEntities:Map<String, FloorEntitiesGroup>;
	
	// THESE ARE TEMPORARY FOR INTERMEDIATE REFACTORING PURPOSES
	public var _mirror:Mirror;
	public var _player:Player;
	
	public var state:PlayState;
	
	public var triggers:Map<FlxSprite, String> = new Map<FlxSprite, String>();
	public var receivers:Map<FlxSprite, String> = new Map<FlxSprite, String>();
	
	public function new(level_file:Dynamic, playstate:PlayState)
	{
		super(level_file);
		state = playstate;
		
		_worlds = [
			"dark" => new WorldGroup(CollisionFilter.DARK, "dark"), // Entities that are only in the dark world
			"light" => new WorldGroup(CollisionFilter.LIGHT, "light"), // Entities that are only in the light world
			"both" => new WorldGroup(CollisionFilter.BOTH, "both"), // Entities that are in both worlds
		];
		
		// Entities that must be under the rest of the entities but on top of the floor
		// These are also not nape sprites.
		_floorEntities = [
			"dark" => new FloorEntitiesGroup(CollisionFilter.DARK, "dark"),
			"light" => new FloorEntitiesGroup(CollisionFilter.LIGHT, "light"),
			"both" => new FloorEntitiesGroup(CollisionFilter.BOTH, "both")
		];
				
		// load tilemaps
		for (layer in layers) // layers is an array in the TiledMap superclass
        {	
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;

			var tilesheetName:String = tileLayer.properties.get("tilesheet");
            var tilesheetPath:String = "assets/images/" + tilesheetName;
            var level:FlxTilemap = new FlxTilemap();

            var tileGID:Int = _getStartGid(tilesheetName);
			
            // add the tile map to the appropriate set of world entities
			level.loadMapFromArray(tileLayer.tileArray, width, height, tilesheetPath, tileWidth, tileWidth, OFF, tileGID, 1, 1);
			
			if (tileLayer.properties.get("world") == "light"){
				state._lightTiles.add(level);
			}
			else if (tileLayer.properties.get("world") == "dark"){
				state._darkTiles.add(level);
			}
			
        }
		
		// load objects
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT) continue;
			var objectLayer:TiledObjectLayer = cast layer;

			// load all of the objects in the layer
			for (o in objectLayer.objects)
			{
				_loadObject(o, objectLayer);
			}
		}
		
		// load images
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.IMAGE) continue;
			var imageLayer:TiledImageLayer = cast layer;
			var underlay:FlxSprite = new FlxSprite(imageLayer.x + imageLayer.offsetX, imageLayer.y + imageLayer.offsetY);
			var path:String = "assets/images/" + imageLayer.properties.get("path");
			trace(imageLayer.x + imageLayer.offsetX + ' ' + imageLayer.y + imageLayer.offsetY + ' ' + path);
			underlay.loadGraphic(path);
			state.add(underlay);
		}
		
		for (t in triggers.keys()){
			for (r in receivers.keys()){
				if (triggers.get(t) == receivers.get(r)){
					// we have a match!
					var tri:Trigger = cast t;
					var rec:Receiver = cast r;
					
					tri._receiver = rec;
				}
			}
		}
	}
	
	public function getWorldEntities(world:String):WorldGroup 
	{
		return _worlds.get(world);
	}
	
	public function getFloorEntities(world:String):FlxGroup 
	{
		return _floorEntities.get(world);
	}
	
	private function _loadObject(o:TiledObject, layer:TiledObjectLayer)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		var w:Int = o.width;
		var h:Int = o.height;
		var rot:Float = o.angle;
		
		var id:String = o.properties.get("id");
		
		// objects in tiled are aligned bottom-left (top-left in flixel).
		if (o.gid != -1) {
			y -= layer.map.getGidOwner(o.gid).tileHeight;
		}
		
		// Find the correct object group to add this object to.
		var thisWorld = layer.properties.get("world");
		var worldGroup:WorldGroup = _worlds.get(thisWorld);
		var flipGroup:WorldGroup;
		
		if (thisWorld == "dark"){
			flipGroup = _worlds.get("light");
		}
		else if (thisWorld == "light"){
			flipGroup = _worlds.get("dark");
		}
		else {
			flipGroup = worldGroup;
		}
		
		var floorEntitiesGroup:FloorEntitiesGroup = _floorEntities.get(thisWorld);
		
		var tilesheetName = layer.properties.get("tilesheet");
		if (tilesheetName == null) {
			tilesheetName = '';
		}
		var tilesheetPath = "assets/images/" + tilesheetName;
		var frame = o.gid - _getStartGid(tilesheetName);
		
		// Handle each type of object differently.
		switch (o.type.toLowerCase())
		{
			// The player won't be bound to any world since it can bounce between worlds.
			case "player start": _player = new Player(tilesheetPath, frame, x, y, w, h);
			
			// TODO(Ariel): Figure out the exact mechanics of the mirror's existence
			// If it exists in both, place in "both". If it flips back and forth
			// like the player does, then leave it as its own entity, like the player.
			case "mirror start": _mirror = _worlds.get("both").addMirror(x, y, state);
			case "wall": worldGroup.addWall(x, y, w, h);
			case "box": worldGroup.addBox(x, y, w, h);
			case "sliding wall": var s:SlidingWall = worldGroup.addSlidingWall(tilesheetPath, frame, x, y, w, h, Std.parseInt(o.properties.get("dest x")), Std.parseInt(o.properties.get("dest y")));
				receivers.set(s,id);
			case "switch": var s:Switch = worldGroup.addSwitch(x, y, w, h, rot);
				triggers.set(s, id);
			case "laser rec": var s:LaserReceiver = worldGroup.addLaserRec(x, y, rot);
				triggers.set(s,id);
			case "laser": var l:LaserEmitter = worldGroup.addLaser(x, y, width, height, rot, state, flipGroup);
				if (o.properties.get("on") != null) {
					l.activate();
				}
				receivers.set(l, id);
			case "door": var d:Door = worldGroup.addDoor(x, y, w, h);
				if (o.properties.get("open") != null) {
					d.activate();
				}
				receivers.set(d, id);
			case "pressure plate": var p:PressurePlate = floorEntitiesGroup.addPlate(x, y, w, h, state);
				triggers.set(p,id);
			case "pit": floorEntitiesGroup.addPit(x, y, w, h, state);
			case "mirror": worldGroup.addMirror(x, y, state);
			case "level end": floorEntitiesGroup.addEnd(x, y, w, h, state);
		}
	}
	
	private function _getStartGid (tilesheetName:String):Int
    {
        // This function gets the starting GID of a tilesheet
        var tileGID:Int = 1;

        for (tileset in tilesets)
        {
            // We need to search the tileset's firstGID -- to do that,
            // we compare the tilesheet paths. If it matches, we
            // extract the firstGID value.
            var tilesheetPath:Path = new Path(tileset.imageSource);
            var thisTilesheetName = tilesheetPath.file + "." + tilesheetPath.ext;
            if (thisTilesheetName == tilesheetName)
            {
                tileGID = tileset.firstGID;
            }
        }

        return tileGID;
    }
}