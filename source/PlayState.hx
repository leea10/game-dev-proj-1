package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;

class PlayState extends FlxState
{
	public var _isDark:Bool = false; // Are we in the dark world?
	
	public var level:TiledLevel;
	public var player:Player;
	public var nape_player:FlxNapeSprite;
	public var mirror:Mirror;
	
	public var wall:Wall;
	
	// Entity groups for each world - to be extracted from .tmx by parser in TiledLevel
	public var _darkWorld:WorldGroup;
	public var _lightWorld:WorldGroup;
	public var _bothWorlds:WorldGroup;
	
	override public function create():Void
	{
		super.create();
		FlxNapeSpace.init();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	/*
	public function create_nape_walls()
	{
		for (wallobj in wall_tiles_light)
		{
			var wall:Wall = cast wallobj;
			
			var _test = new FlxNapeSprite(wall.x + (wall.w/2), wall.y + (wall.h/2));
			_test.makeGraphic(wall.w, wall.h, FlxColor.CYAN);
			_test.createRectangularBody();
			_test.visible = false;
			add(_test);
		}
	}
	*/
}
