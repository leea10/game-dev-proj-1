package;

import flixel.FlxState;
import flixel.FlxG;
import haxe.io.Path;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;

class TiledLevel extends TiledMap
{	
	
	public var is_dark_world:Bool;
	
	public function new(level_file:Dynamic, state:PlayState, dark_world:Bool)
	{
		super(level_file);
		
		is_dark_world = dark_world;
		
		// load tilemaps
		for (layer in layers) // layers is an array in the TiledMap superclass
        {	
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;
			
			// layer data is stored as an array of ints
            //var layerData:Array<Int> = tileLayer.tileArray;

			// important: either all tiles need to be on one sheet (preferable) or we need to specify which layers have which tilemaps. each layer can use only one spritesheet.
			var tilesheetName:String = "temp tilemap.png";
            var tilesheetPath:String = "assets/images/" + tilesheetName;
            var level:FlxTilemap = new FlxTilemap();

			// tell the tilemap how big the level is
            //level.widthInTiles = width;
            //level.heightInTiles = height;

            var tileGID:Int = getStartGid(tilesheetName);
			
            // add the map to the state
			level.loadMapFromArray(tileLayer.tileArray, width, height, tilesheetPath, tileWidth, tileWidth, OFF, tileGID, 1, 1);
            state.add(level);
			if (is_dark_world){
				// dark world levels are placed 10,000 pixels to the right (hopefully that's far enough)
				level.x += 10000;
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
				loadObject(state, o, objectLayer);
			}
		}
	}
	
	function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		if (is_dark_world){
			// dark world levels are placed 10,000 pixels to the right (hopefully that's far enough)
			x += 10000;
		}
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
		switch (o.type.toLowerCase())
		{
			case "player start":
				var player:Player = new Player(x, y);
				state.player = player;
				state.add(player);
				
			case "mirror start":
				var mirror:Mirror = new Mirror(x, y);
				state.mirror = mirror;
				state.add(mirror);
		}
	}
	
	function getStartGid (tilesheetName:String):Int
    {
        // This function gets the starting GID of a tilesheet

        // Note: "0" is empty tile, so default to a non-empty "1" value.
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