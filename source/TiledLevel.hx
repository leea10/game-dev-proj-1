package;

import flixel.FlxState;
import flixel.FlxG;
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
	
	// THESE ARE TEMPORARY FOR INTERMEDIATE REFACTORING PURPOSES
	public var _mirror:Mirror;
	public var _player:Player;
		
	public function new(level_file:Dynamic)
	{
		super(level_file);
		
		_worlds = [
			"dark" => new WorldGroup(), // Entities that are only in the dark world
			"light" => new WorldGroup(), // Entities that are only in the light world
			"both" => new WorldGroup(), // Entities that are in both worlds
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
			_worlds[tileLayer.properties.get("world")].add(level);
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
	}
	
	public function getWorldEntities(world:String):WorldGroup 
	{
		return _worlds.get(world);
	}
	
	private function _loadObject(o:TiledObject, layer:TiledObjectLayer)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		var w:Int = o.width;
		var h:Int = o.height;
		
		// objects in tiled are aligned bottom-left (top-left in flixel).
		if (o.gid != -1) {
			y -= layer.map.getGidOwner(o.gid).tileHeight;
		}
		
		// Find the correct object group to add this object to.
		var worldGroup:WorldGroup = _worlds.get(layer.properties.get("world"));
		
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
			case "player start": _player = new Player(x, y);
			
			// TODO(Ariel): Figure out the exact mechanics of the mirror's existence
			// If it exists in both, place in "both". If it flips back and forth
			// like the player does, then leave it as its own entity, like the player.
			case "mirror start": _mirror = new Mirror(x, y);
			case "wall": worldGroup.addWall(x, y, w, h);
			case "box": worldGroup.addBox(tilesheetPath, frame, x, y, w, h);
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