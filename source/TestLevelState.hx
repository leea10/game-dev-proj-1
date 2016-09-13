package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.addons.nape.FlxNapeSprite;

// TODO(Ariel): Turn this into LevelState and use as a base class for all levels
class TestLevelState extends PlayState
{
	// TODO(Ariel): Make private once the dual sprite transition is done
	public var _isDark:Bool = false; // Are we in the dark world?
	
	// Entity groups for each world - to be extracted from .tmx by parser in TiledLevel
	private var _darkWorld:TaggedGroup;
	private var _lightWorld:TaggedGroup;
	private var _bothWorlds:TaggedGroup;
	
	var nape_player:FlxNapeSprite;

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
		
		FlxG.worldBounds.width = level.width * level.tileWidth;
		FlxG.worldBounds.height = level.height * level.tileHeight;

		// TODO(Ariel): get rid of duplicating the world / sprite hacks.
		add(new LaserEmitter(1100, 900, this));

		nape_player = new FlxNapeSprite(1000,1000);
		//nape_player.makeGraphic(32, 32, FlxColor.CYAN);
		nape_player.createCircularBody(10);
		nape_player.visible = false;
		add(nape_player);
		
		//create_nape_walls();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// If the spacebar was hit, switch worlds
		// TODO(Ariel): Add another check to make sure the player is in front of the mirror.
		if (FlxG.keys.justPressed.SPACE) {
			switchWorld();
		}
		nape_player.reset(player.x + 16, player.y + 16); //player sprite is 32x32 and we need this nape collider to be in the center
	}
	
	function switchWorld():Void
	{
		_isDark = !_isDark;
		_darkWorld.visible = _isDark;
		_lightWorld.visible = !_isDark;
	}
}