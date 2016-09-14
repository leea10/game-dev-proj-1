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

// TODO(Ariel): Turn this into LevelState and use as a base class for all levels.
// TODO(Ariel): Figure out what differentiates this from a normal PlayState and possibly consolidate.
class TestLevelState extends PlayState
{
	override public function create():Void
	{
		super.create();
		
		// Parse level data from file.
		level = new TiledLevel("assets/levels/templevel.tmx");
		
		// Retrieve object groups based on what world(s) they're in.
		_darkWorld = level.getWorldEntities("dark");
		_lightWorld = level.getWorldEntities("light");
		_bothWorlds = level.getWorldEntities("both");
		
		// Initialize the level's starting world.
		_setWorld(_isDark);
		
		_darkWorld.addLaser(1100, 900, this);
		//_bothWorlds.addLight(1200, 650, this);
		
		add(_darkWorld);
		add(_lightWorld);
		add(_bothWorlds);
		
		// Retrieve player and mirror.
		// TODO(Ariel): retrieve their positions and create them here.
		player = level._player;
		mirror = level._mirror;
		add(player);
		add(mirror);
		
		FlxG.worldBounds.width = level.width * level.tileWidth;
		FlxG.worldBounds.height = level.height * level.tileHeight;

		nape_player = new FlxNapeSprite(1000,1000);
		nape_player.createCircularBody(10);
		nape_player.visible = false;
		nape_player.solid = false;
		add(nape_player);
		
		canvas.makeGraphic(Math.round(FlxG.worldBounds.width), Math.round(FlxG.worldBounds.height), FlxColor.TRANSPARENT);
		add(canvas);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_handleInput();
		_handleCollisions();

		nape_player.reset(player.x + 16, player.y + 16); //player sprite is 32x32 and we need this nape collider to be in the center
	}
	
	private function _handleInput():Void
	{
		// If the spacebar was hit, switch worlds
		// TODO(Ariel): Add another check to make sure the player is in front of the mirror.
		if (FlxG.keys.justPressed.SPACE) {
			_switchWorld();
		}		
	}
	
	private function _handleCollisions():Void
	{
		FlxG.collide(player, _bothWorlds.walls);
		FlxG.collide(player, _getActiveWorld().walls);		
	}
	
	private function _getActiveWorld():WorldGroup 
	{
		return _isDark ? _darkWorld : _lightWorld;
	}
	
	private function _setWorld(isDark):Void 
	{
		_isDark = isDark;
		_darkWorld.visible = _isDark;
		_lightWorld.visible = !_isDark;
	}
	
	private function _switchWorld():Void
	{
		_setWorld(!_isDark);
	}
}