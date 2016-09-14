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
	
	public var canvas:FlxSprite = new FlxSprite(0, 0);
	
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
	}

}
