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
import nape.phys.FluidProperties;
import nape.shape.Shape;
import nape.dynamics.InteractionFilter;

class PlayState extends FlxState
{
	public var _isDark:Bool = false; // Are we in the dark world?
	
	public var level:TiledLevel;
	public var player:Player;
	public var nape_player:FlxNapeSprite;
	public var mirror:Mirror;
		
	// groups for the actual tiles (not entities) -- this is for layering reasons
	public var _darkTiles:FlxGroup = new FlxGroup();
	public var _lightTiles:FlxGroup = new FlxGroup();
	
	// Entity groups for each world - to be extracted from .tmx by parser in TiledLevel
	public var _darkWorld:WorldGroup;
	public var _lightWorld:WorldGroup;
	public var _bothWorlds:WorldGroup;
	
	public var light_filter:InteractionFilter;
	public var dark_filter:InteractionFilter;
	public var both_filter:InteractionFilter;
	
	override public function create():Void
	{
		super.create();
		FlxNapeSpace.init();
		
		var light_collision_group:Int = 1; /// .....0001
		var dark_collision_group:Int = 2;  /// .....0010
		var both_collision_group:Int = 4;  /// .....0100
		
		var light_collision_mask:Int = 5;  /// .....0101 -- collide with stuff in the light world and in both worlds
		var dark_collision_mask:Int = 6;   /// .....0110 -- collide with stuff in the dark world and in both worlds
		var both_collision_mask:Int = 7;   /// .....0111 -- collide with everything
		
		light_filter = new InteractionFilter(light_collision_group, light_collision_mask);
		dark_filter = new InteractionFilter(dark_collision_group, dark_collision_mask);
		both_filter = new InteractionFilter(both_collision_group, both_collision_mask);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_handleInput();
	}
	
	public function init (levelpath:String){
		// Parse level data from file.
		level = new TiledLevel(levelpath, this);
		
		// Retrieve object groups based on what world(s) they're in.
		_darkWorld = level.getWorldEntities("dark");
		_lightWorld = level.getWorldEntities("light");
		_bothWorlds = level.getWorldEntities("both");
		
		add(_darkTiles);
		add(_lightTiles);
		
		add(_bothWorlds);
		add(_darkWorld);
		add(_lightWorld);
		
		// Retrieve player and mirror.
		// TODO(Ariel): retrieve their positions and create them here.
		player = level._player;
		mirror = level._mirror;
		add(player);
		
		_bothWorlds.mirrors.add(mirror);

		player.state = this;
		mirror.set_filter(both_filter);
		add(mirror.swivel_top);
		
		// Initialize the level's starting world.
		_setWorld(_isDark);
		
		FlxG.worldBounds.width = level.width * level.tileWidth;
		FlxG.worldBounds.height = level.height * level.tileHeight;
	}
	
	private function _handleInput():Void
	{
		// If the spacebar was hit, switch worlds
		// TODO(Ariel): Add another check to make sure the player is in front of the mirror.
		if (FlxG.keys.justPressed.SPACE) {
			_switchWorld();
		}		
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
		
		_darkTiles.visible = _isDark;
		_lightTiles.visible = !_isDark;
		
		
		if (_isDark) {
			player.body.shapes.at(0).filter = dark_filter;
		}
		else {
			player.body.shapes.at(0).filter = light_filter;
		}
	}
	
	private function _switchWorld():Void
	{
		_setWorld(!_isDark);
	}

	public function restartLevel()
	{
		var x = Type.createInstance(Type.getClass(this), []);
		FlxG.switchState(x);
	}
}
