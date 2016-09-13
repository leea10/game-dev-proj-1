package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.addons.nape.FlxNapeSprite;

class LaserEmitter extends FlxSprite
{
	var length:Int = 600;
	var state:PlayState;
	var worldgroup:WorldGroup;
	
	var laser:Laser;
	
	public var in_dark_world:Bool = false;
	public var in_light_world:Bool = false;
	
	public function new(?x:Float=0, ?y:Float=0, playstate:PlayState, group:WorldGroup) 
	{
		super(x, y);
		state = playstate;
		worldgroup = group;
		
		//get_worlds();
		
		makeGraphic(16, 16, FlxColor.ORANGE);
		origin.set(width / 2, height / 2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		update_laser();
	}
	
	function update_laser():Void
	{	
		angle += 1;
		laser.angle = angle;
	}

	public function initialize():Void
	{
		get_worlds();
	
		laser = new Laser(x+(width/2), y+(height/2)-4, length, angle, state, in_dark_world, in_light_world);
		worldgroup.add(laser);
	}
	
	// what world(s) is this laser in?
	function get_worlds():Void
	{
		for (laser in state._lightWorld.lasers){
			if (laser == this){
				in_light_world = true;
			}
		}
		for (laser in state._darkWorld.lasers){
			if (laser == this){
				in_dark_world = true;
			}
		}
		for (laser in state._bothWorlds.lasers){
			trace ("found a laser");
			if (laser == this){
				trace ("found this laser");
				in_light_world = true;
				in_dark_world = true;
			}
		}
	}
}