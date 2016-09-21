package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import nape.phys.FluidProperties;
import nape.shape.Shape;
import flixel.tweens.FlxTween;
import haxe.Timer;

class PlayState extends FlxState
{
	public var _isDark:Bool = false; // Are we in the dark world?
	public var should_be_dark:Bool = false;
	
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
	
	public var darklasers:FlxTypedGroup<Laser> = new FlxTypedGroup<Laser>();
	public var lightlasers:FlxTypedGroup<Laser> = new FlxTypedGroup<Laser>();
	public var bothlasers:FlxTypedGroup<Laser> = new FlxTypedGroup<Laser>();
	
	public var darkmirrors:FlxTypedGroup<FlxNapeSprite> = new FlxTypedGroup<FlxNapeSprite>();
	public var lightmirrors:FlxTypedGroup<FlxNapeSprite> = new FlxTypedGroup<FlxNapeSprite>();
	public var bothmirrors:FlxTypedGroup<FlxNapeSprite> = new FlxTypedGroup<FlxNapeSprite>();
	
	public var ui_man:UIManager;
	public var black_screen:FlxSprite;
	public var white_screen:FlxSprite;
	
	public var sound_man:SoundManager;
	
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
		
		add(bothlasers);
		add(darklasers);
		add(lightlasers);
		
		// Retrieve player and mirror.
		player = level._player;
		mirror = level._mirror;
		add(player);
		add(player.hit_area);
		
		//_bothWorlds.mirrors.add(mirror);
		
		player.state = this;
		//mirror.set_filter(CollisionFilter.BOTH);
		//add(mirror.swivel_top);
		
		add(bothmirrors);
		add(darkmirrors);
		add(lightmirrors);
		
		// Initialize the level's starting world.
		_setWorld();
		
		FlxG.worldBounds.width = level.width * level.tileWidth;
		FlxG.worldBounds.height = level.height * level.tileHeight;
		
		ui_man = new UIManager();
		add(ui_man);
		
		sound_man = new SoundManager();
		add(sound_man);
		
		white_screen = new FlxSprite(0,0);
		white_screen.makeGraphic(1280, 720, FlxColor.WHITE);
		white_screen.scrollFactor.set(0, 0);
		add(white_screen);
		white_screen.alpha = 0;
		
		black_screen = new FlxSprite(0,0);
		black_screen.makeGraphic(1280, 720, FlxColor.BLACK);
		black_screen.scrollFactor.set(0, 0);
		add(black_screen);
		
		// wait 100ms after the level has loaded to fade in (just to be safe)
		Timer.delay(fade_in, 100);
	}

	public function angularDifference(angle1:Float, angle2:Float)
	{
		return Math.abs(FlxAngle.wrapAngle(angle2 - angle1));
	}	
	
	private function _handleInput():Void
	{
		// If the spacebar was hit (and we're facing the mirror), switch worlds
		var facing_front_mirror:Bool = false;
		if (player.facing_mirror)
		{
			var mirrorToPlayerAngle:Float = FlxAngle.angleBetween(mirror, player, true) - 90;
			var mirrorFacingAngle:Float = FlxAngle.asDegrees(mirror.swivel_top.body.rotation);
			
			if(angularDifference(mirrorToPlayerAngle, mirrorFacingAngle) < 90){
				facing_front_mirror = true;
			}
		}
		
		ui_man.jump_prompt.visible = facing_front_mirror;
		
		if (FlxG.keys.justPressed.SPACE && facing_front_mirror)
		{	
			_switchWorld();
		}		
	}
	
	private function _getActiveWorld():WorldGroup 
	{
		return _isDark ? _darkWorld : _lightWorld;
	}
	
	private function _setWorldAndFlash(isDark):Void 
	{
		should_be_dark = isDark;
		FlxTween.tween(white_screen, { alpha: 1 }, 0.05);
		Timer.delay(_setWorld, 50);
		Timer.delay(flash_back, 50);
	}
	
	private function _setWorld():Void
	{
		_isDark = should_be_dark;
		
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
			if (FlxG.overlap(player.hit_area, _lightWorld.laseremitters)){
				can_switch = false;
				// can't teleport into a laser emitter
			}
			if (FlxG.overlap(player.hit_area, _lightWorld.slidingwalls)){
				can_switch = false;
				// can't teleport into a sliding wall
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
			if (FlxG.overlap(player.hit_area, _darkWorld.laseremitters)){
				can_switch = false;
				// can't teleport into a laser emitter
			}
			if (FlxG.overlap(player.hit_area, _darkWorld.slidingwalls)){
				can_switch = false;
				// can't teleport into a sliding wall
			}
		}
		
		if (can_switch) _setWorldAndFlash(!_isDark);
	}

	public function waitAndRestart(delay:Int)
	{
		Timer.delay(restartLevel, delay);
		Timer.delay(fade_out, Math.round(delay/2));
	}
	
	function restartLevel()
	{
		var x = Type.createInstance(Type.getClass(this), []);
		FlxG.switchState(x);
	}
	
	public function waitAndNextLevel(delay:Int)
	{
		Timer.delay(nextLevel, delay);
		Timer.delay(fade_out, Math.round(delay/2));
	}
	
	function nextLevel()
	{
		// shell function to be replaced in the child
	}
	
	public function fade_in()
	{
		FlxTween.tween(black_screen, { alpha: 0 }, 1);
	}
	
	public function fade_out()
	{
		FlxTween.tween(black_screen, { alpha: 1 }, 0.4);
	}
	
	public function flash_back()
	{
		FlxTween.tween(white_screen, { alpha: 0 }, 0.05);
	}
}
