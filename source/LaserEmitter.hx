package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import nape.geom.Vec2;
import flixel.addons.nape.FlxNapeSprite;

class LaserEmitter extends FlxSprite implements Receiver
{
	var length:Int = 600;
	var state:PlayState;
	var worldgroup:WorldGroup;
	
	// group for laser beams
	var lasergroup:FlxTypedGroup<Laser>;
	// group for spark effects that get displayed 
	var sparksgroup:FlxGroup;
		
	// how many times can the beam bounce before stopping?
	var bounce_limit:Int = 5;
	
	var is_active:Bool = false;
	
	public var in_dark_world:Bool = false;
	public var in_light_world:Bool = false;
	
	public function new(?x:Float=0, ?y:Float=0, playstate:PlayState, group:WorldGroup) 
	{
		super(x, y);
		state = playstate;
		worldgroup = group;
		
		lasergroup = new FlxTypedGroup<Laser>();
		sparksgroup = new FlxGroup();
		
		makeGraphic(16, 16, FlxColor.ORANGE);
		origin.set(width / 2, height / 2);
		
		angle = 270;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		update_lasers();
	}
	
	function update_lasers():Void
	{		
		//angle += .3;
		
		var i:Int = 0;
		var prev:Laser = lasergroup.members[0];
		for (l in lasergroup){
			if (i==0){
				// don't move the first laser, but do rotate it
				l.angle = angle;
			}
			else {
				l.x = prev.hit_point.x + prev.hit_normal.x; // move the laser start points off of the surface just a little (to avoid weird clipping errors)
				l.y = prev.hit_point.y + prev.hit_normal.y;
				
				// figure out the bounce angle
				var old_angle:Vec2 = Vec2.get(prev._cosAngle, prev._sinAngle);
				var new_angle:Vec2 = vecsub(old_angle, vecmult(prev.hit_normal, 2*dotprod(old_angle, prev.hit_normal)));
				
				l.angle = (180 / 3.1416) * Math.atan2(new_angle.y, new_angle.x);
			}
			
			l.calculate();
			prev = l;
			
			i++;
		}
		
		var desired_num_lasers;
		if (is_active){
			desired_num_lasers = 1;
			// we definitely want at least one beam
			for (l in lasergroup.members){
				if (l.bounced){
					desired_num_lasers += 1;
				}
			}
		}
		else {
			// unless the laser is off
			desired_num_lasers = 0;
		}
		
		// desired_num_lasers can be at maximum 1 more than the number of laser already in the group -- only one laser is ever added in a single frame
		if ((desired_num_lasers > lasergroup.length) && desired_num_lasers <= (bounce_limit+1)){
			create_new_laser();
		}
		// too many lasers
		else if (desired_num_lasers < lasergroup.length){
			
			var temp_array:Array<Laser> = new Array<Laser>();
			
			var i:Int = 0;
			for (l in lasergroup.members){
				if (i < desired_num_lasers){
					temp_array.insert(i, l);
				}
				i++;
			}
			
			lasergroup.clear();
			for (l in temp_array){
				lasergroup.add(l);
			}
		}
	}
	
	// simple 2d dot product
	public function dotprod(a:Vec2, b:Vec2):Float
	{
		return a.x*b.x + a.y*b.y;
	}
	
	// 2d vector multiplied by a scalar
	public function vecmult(a:Vec2, b:Float):Vec2
	{
		return Vec2.get(a.x*b, a.y*b);
	}

	// subtract one 2d vector from another
	public function vecsub(a:Vec2, b:Vec2):Vec2
	{
		return Vec2.get(a.x-b.x, a.y-b.y);
	}

	public function initialize():Void
	{
		get_worlds();
		worldgroup.add(lasergroup);
		worldgroup.add(sparksgroup);
		
		// make one laser to begin with
		create_new_laser();
	}
	
	public function create_new_laser():Void
	{
		lasergroup.add(new Laser(x + (width / 2), y + (height / 2) - 4, length, angle, state, in_dark_world, in_light_world));
	}
	
	// what world(s) is this laser in?
	function get_worlds():Void
	{
		if (worldgroup.worldname == "light"){
			in_light_world = true;
		}
		else if (worldgroup.worldname == "dark"){
			in_dark_world = true;
		}
		else{
			in_light_world = true;
			in_dark_world = true;
		}
	}
	
	public function activate()
	{
		is_active = true;
	}
	
	public function deactivate()
	{
		is_active = false;
	}
}