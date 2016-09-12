package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;

class TestLevelState extends PlayState
{
	var _darkWorld:FlxGroup;
	var _lightWorld:FlxGroup;
	var _bothWorlds:FlxGroup;
	
	override public function create():Void
	{
		super.create();
		
		// Parse level data from file.
		level = new TiledLevel("assets/levels/templevel.tmx");
		
		// Retrieve object groups based on what world(s) they're in.
		_darkWorld = level._darkWorld;
		_lightWorld = level._lightWorld;
		_bothWorlds = level._bothWorlds;
		
		add(_darkWorld);
		add(_lightWorld);
		add(_bothWorlds);
		
		// Retrieve player and mirror 
		// TODO: retrieve their positions and create them here.
		player = level._player;
		mirror = level._mirror;
		add(player);
		add(mirror);
		
		// TODO(Ariel): get rid of duplicating the world / sprite hacks.
		FlxG.worldBounds.width = (level.width*level.tileWidth)*2+10000;
		FlxG.worldBounds.height = level.height * level.tileHeight;
		
		add(new DualSprite(1000, 900, this));
		add(new LaserEmitter(1100, 900, this));
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
}