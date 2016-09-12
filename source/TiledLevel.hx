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
	// TODO: write public getter functions and make these private.
	public var _darkWorld:FlxGroup; // Entities that are only in the dark world
	public var _lightWorld:FlxGroup; // Entities that are only in the light world
	public var _bothWorlds:FlxGroup; // Entites that are in both worlds
	
	// THESE ARE TEMPORARY FOR INTERMEDIATE REFACTORING PURPOSES
	public var _mirror:Mirror;
	public var _player:Player;
		
	public function new(level_file:Dynamic)
	{
		super(level_file);
		
		_darkWorld = new FlxGroup();
		_lightWorld = new FlxGroup();
		_bothWorlds = new FlxGroup();
				
		// load tilemaps
		for (layer in layers) // layers is an array in the TiledMap superclass
        {	
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;

			// important: either all tiles need to be on one sheet (preferable) or we need to specify which layers have which tilemaps. each layer can use only one spritesheet.
			var tilesheetName:String = "temp tilemap.png";
            var tilesheetPath:String = "assets/images/" + tilesheetName;
            var level:FlxTilemap = new FlxTilemap();

            var tileGID:Int = getStartGid(tilesheetName);
			
            // add the map to the state
			level.loadMapFromArray(tileLayer.tileArray, width, height, tilesheetPath, tileWidth, tileWidth, OFF, tileGID, 1, 1);
			
			switch(tileLayer.properties.get("world")) {
				case "dark": _darkWorld.add(level);
				case "light": _lightWorld.add(level);
				case "both": _bothWorlds.add(level);
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
				loadObject(o, objectLayer);
			}
		}
	}
	
	function loadObject(o:TiledObject, layer:TiledObjectLayer)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		var w:Int = o.width;
		var h:Int = o.height;
		
		// objects in tiled are aligned bottom-left (top-left in flixel).
		if (o.gid != -1)
			y -= layer.map.getGidOwner(o.gid).tileHeight;
			
		// Find the correct object group to add this object to.
		var worldGroup:FlxGroup = null;
		switch(layer.properties.get('world'))
		{
			case "light": worldGroup = _lightWorld;
			case "dark": worldGroup = _darkWorld;
			case "both": worldGroup = _bothWorlds;
		}
		
		// Handle each type of object differently.
		switch (o.type.toLowerCase())
		{
			case "mirror start": _mirror = new Mirror(x, y);
			case "player start": _player = new Player(x, y);
			case "wall": worldGroup.add(new Wall(x, y, w, h));
		}
	}
	
	function getStartGid (tilesheetName:String):Int
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