package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;

// TODO(Ariel): Turn this into LevelState and use as a base class for all levels
class TestLevelState extends PlayState
{
	// TODO(Ariel): Make private once the dual sprite transition is done
	public var _isDark:Bool = false; // Are we in the dark world?
	
	// Entity groups for each world - to be extracted from .tmx by parser in TiledLevel
	private var _darkWorld:FlxGroup;
	private var _lightWorld:FlxGroup;
	private var _bothWorlds:FlxGroup;
	
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
		
		// Initialize the level's starting world.
		_darkWorld.visible = _isDark;
		_lightWorld.visible = !_isDark;
		
		// Retrieve player and mirror.
		// TODO(Ariel): retrieve their positions and create them here.
		player = level._player;
		mirror = level._mirror;
		add(player);
		add(mirror);
		
		// TODO(Ariel): get rid of duplicating the world / sprite hacks.
		FlxG.worldBounds.width = level.width * level.tileWidth;
		FlxG.worldBounds.height = level.height * level.tileHeight;
		
		add(new DualSprite(1000, 900, this));
		add(new LaserEmitter(1100, 900, this));
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// If the spacebar was hit, switch worlds
		// TODO(Ariel): Add another check to make sure the player is in front of the mirror.
		if (FlxG.keys.justPressed.SPACE) {
			switchWorld();
		}
	}
	
	function switchWorld():Void
	{
		_isDark = !_isDark;
		_darkWorld.visible = _isDark;
		_lightWorld.visible = !_isDark;
	}
}