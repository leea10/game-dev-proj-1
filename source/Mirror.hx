package;

import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import nape.geom.Vec2;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

class Mirror extends FlxNapeSprite
{
	public var origin_x:Float;
	public var origin_y:Float;
	
	public var swivel_top:FlxNapeSprite;
	public var group:WorldGroup;
	public var state:PlayState;
	
	public function new(x_in:Int, y_in:Int, worldgroup:WorldGroup, playstate:PlayState)
	{
		super(x_in, y_in);
		group = worldgroup;
		state = playstate;
		
		makeGraphic(64, 64, FlxColor.WHITE);
		createRectangularBody();
		body.type = BodyType.DYNAMIC;
		
		setBodyMaterial(0, 0, 0, 10);
		setDrag(0.5, 0.5);
		
		body.allowMovement = true;
		body.allowRotation = false;
		
		// add the actual swiveling mirror part
		swivel_top = new FlxNapeSprite(x+width/2, y+height/2);
		swivel_top.makeGraphic(55, 10, FlxColor.BLACK);
		swivel_top.createRectangularBody();
		swivel_top.body.type = BodyType.DYNAMIC;
		swivel_top.body.allowMovement = false;
		swivel_top.body.allowRotation = true;
		
		// we don't want this to collide with anything
		/// ...1000, ...0000
		var no_filter:InteractionFilter = new InteractionFilter(8, 0);
		swivel_top.body.shapes.at(0).filter = no_filter;		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		origin_x = x+width/2;
		origin_y = y+height/2;
		
		swivel_top.reset(origin_x,origin_y);
		
		alpha = 1;
		if (state._isDark) {
			if (group.worldname == "light") {
				alpha = 0.00001;
			}
		}
		else if (!state._isDark) {
			if (group.worldname == "dark") {
				alpha = 0.00001;
			}
		}
	}
	
	public function set_filter (filter:InteractionFilter)
	{
		body.shapes.at(0).filter = filter;
	}
	
	public function normal_compare (in_norm:Vec2):Bool
	{
		var norm = rotate_vec2(Vec2.get(swivel_top._cosAngle, swivel_top._sinAngle), 90);
		return (float_compare(norm.x, in_norm.x)&&float_compare(norm.y, in_norm.y));
	}
	
	public function float_compare (a:Float, b:Float):Bool
	{
		var threshold:Float = 0.01;
		return ((a+threshold>b)&&(a-threshold<b));
	}
	
	public function facing_point (x_pos:Float,y_pos:Float):Bool
	{
		var norm = rotate_vec2(Vec2.get(swivel_top._cosAngle, swivel_top._sinAngle), 90);
		var vec = Vec2.get(x_pos - origin_x, y_pos - origin_y);
		
		var angle:Float = (angle_between_vectors(norm, vec));
		return (angle < 76);
	}
	
	public function angle_between_vectors(a:Vec2,b:Vec2):Float
	{
		var c:Float = (a.x * b.x + a.y * b.y) / (Math.sqrt( Math.pow(a.x, 2) + Math.pow(a.y, 2) ) * (Math.sqrt( Math.pow(b.x, 2) + Math.pow(b.y, 2) )));
		return Math.acos(c) * (180 / 3.1416);
		
		return Math.atan2(a.x * b.y -a.y * b.x, a.x * b.x + a.y * b.y);
	}
	
	public function rotate_vec2(vec:Vec2, degrees:Float):Vec2
	{
		degrees *= (3.146/180);
		var result:Vec2 = new Vec2();
		
		result.x = vec.x * Math.cos(degrees) - vec.y * Math.sin(degrees);
		result.y = vec.x * Math.sin(degrees) + vec.y * Math.cos(degrees);
		
		return result;
	}
	
	public function turn(amount:Float):Void
	{
		swivel_top.body.rotation += amount;
	}
	
	public function deactivate ():Void
	{
		set_physicsEnabled(false);
	}
}