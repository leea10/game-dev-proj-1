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
import haxe.Timer;

class PlayState extends FlxState
{
	public var _isDark:Bool = false; // Are we in the dark world?
	
	public var level:TiledLevel;
	public var player:Player;
	public var mirror:Mirror;
		
	// groups for the actual tiles (not entities) -- this is for layering reasons
	public var _darkTiles:FlxGroup = new FlxGroup();
	public var _lightTiles:FlxGroup = new FlxGroup();
	
	// groups for floor entities - this is also for layering reasons
	public var _darkFloorEntities:FlxGroup;
	public var _lightFloorEntities:FlxGroup;
	public var _bothFloorEntities:FlxGroup;
	
	// Entity groups for each world - to be extracted from .tmx by parser in TiledLevel
	public var _darkWorld:WorldGroup;
	public var _lightWorld:WorldGroup;
	public var _bothWorlds:WorldGroup;
	
	public var ui_man:UIManager;
	
	override public function create():Void
	{
		super.create();
		FlxNapeSpace.init();
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
		_darkFloorEntities = level.getFloorEntities("dark");
		_lightFloorEntities = level.getFloorEntities("light");
		_bothFloorEntities = level.getFloorEntities("both");			
	
		_darkWorld = level.getWorldEntities("dark");
		_lightWorld = level.getWorldEntities("light");
		_bothWorlds = level.getWorldEntities("both");
		
		add(_darkTiles);
		add(_lightTiles);

		add(_bothFloorEntities);
		add(_darkFloorEntities);
		add(_lightFloorEntities);		
		
		add(_bothWorlds);
		add(_darkWorld);
		add(_lightWorld);
		
		// Retrieve player and mirror.
		player = level._player;
		mirror = level._mirror;
		add(player);
		add(player.hit_area);
		
		_bothWorlds.mirrors.add(mirror);

		player.state = this;
		mirror.set_filter(CollisionFilter.BOTH);
		add(mirror.swivel_top);
		
		// Initialize the level's starting world.
		_setWorld(_isDark);
		
		FlxG.worldBounds.width = level.width * level.tileWidth;
		FlxG.worldBounds.height = level.height * level.tileHeight;
		
		ui_man = new UIManager();
		add(ui_man);
	}
	
	private function _handleInput():Void
	{
		// If the spacebar was hit, switch worlds
		// TODO(Ariel): Add another check to make sure the player is in front of the mirror.
		if (FlxG.keys.justPressed.SPACE)
		{
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
		
		_darkFloorEntities.visible = _isDark;
		_lightFloorEntities.visible = !_isDark;
		
		if (_isDark) {
			player.body.shapes.at(0).filter = CollisionFilter.DARK;
		}
		else {
			player.body.shapes.at(0).filter = CollisionFilter.LIGHT;
		}
	}
	
	private function _switchWorld():Void
	{
		var can_switch:Bool = true;
		if (_isDark) {
			if (FlxG.overlap(player.hit_area, _lightWorld.walls)){
				can_switch = false;
				// can't teleport into a wall
			}
			if (FlxG.overlap(player.hit_area, _lightWorld.boxes)){
				can_switch = false;
				// can't teleport into a box
			}
			if (FlxG.overlap(player.hit_area, _lightWorld.switches)){
				can_switch = false;
				// can't teleport into a switch
			}
			if (FlxG.overlap(player.hit_area, _lightWorld.mirrors)){
				can_switch = false;
				// can't teleport into a mirror
			}
			if (FlxG.overlap(player.hit_area, _lightWorld.lasers)){
				can_switch = false;
				// can't teleport into a laser emitter
			}
		}
		else {
			if (FlxG.overlap(player.hit_area, _darkWorld.walls)){
				can_switch = false;
				// can't teleport into a wall
			}
			if (FlxG.overlap(player.hit_area, _darkWorld.boxes)){
				can_switch = false;
				// can't teleport into a box
			}
			if (FlxG.overlap(player.hit_area, _darkWorld.switches)){
				can_switch = false;
				// can't teleport into a switch
			}
			if (FlxG.overlap(player.hit_area, _darkWorld.mirrors)){
				can_switch = false;
				// can't teleport into a mirror
			}
			if (FlxG.overlap(player.hit_area, _darkWorld.lasers)){
				can_switch = false;
				// can't teleport into a laser emitter
			}
		}
		
		if (can_switch) _setWorld(!_isDark);
	}

	public function waitAndRestart(delay:Int)
	{
		Timer.delay(restartLevel, delay);
	}
	
	function restartLevel()
	{
		var x = Type.createInstance(Type.getClass(this), []);
		FlxG.switchState(x);
	}
}
