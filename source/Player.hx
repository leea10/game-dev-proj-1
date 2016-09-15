package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.math.FlxMath;
import nape.phys.BodyType;
import nape.geom.Vec2;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import nape.geom.Ray;
import nape.geom.RayResultList;

class Player extends FlxNapeSprite
{	
	// key presses	
	var up_pressed:Bool = false;
	var down_pressed:Bool = false;
	var left_pressed:Bool = false;
	var right_pressed:Bool = false;

	var _speed:Float = 200;
	var _rotation:Float = 0;
	
	public var vx:Float = 0;
	public var vy:Float = 0;
	
	public var box_target:FlxSprite = new FlxSprite();
	public var has_drag_target:Bool = false;
	public var is_dragging:Bool = false;
	
	public var state:PlayState;
	
	public function new(tilesheetPath:String, frame:Int, x:Int, y:Int, width:Int, height:Int)
	{
		super(x, y);
		loadGraphic(tilesheetPath, true, width, height);
		animation.frameIndex = frame;
		
		createRectangularBody();
		body.type = BodyType.DYNAMIC;
		
		setBodyMaterial(0, 0, 0, 1);
		setDrag(0.5, 0.5);
		
		body.allowMovement = true;
		body.allowRotation = false;
		body.inertia = 1000;
		
		FlxG.camera.follow(this);
		
		solid = true;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		handle_key_presses();
		handle_movement();
		raycast_for_boxes();
		
		if (is_dragging){
			var box:Box = cast box_target;
			
			box.body.velocity = this.body.velocity;
		}
		
		// magic
		// (lerps player in the direction of their velocity)
		//var shortest_angle:Float = ((((rotation - angle) % 360) + 540) % 360) - 180;
		//angle += shortest_angle * 0.3;
	}
	
	public function handle_key_presses():Void
	{
		up_pressed = FlxG.keys.anyPressed([UP, W]);
		down_pressed = FlxG.keys.anyPressed([DOWN, S]);
		left_pressed = FlxG.keys.anyPressed([LEFT, A]);
		right_pressed = FlxG.keys.anyPressed([RIGHT, D]);
		
		is_dragging = FlxG.keys.pressed.SHIFT && has_drag_target;
	}
	
	public function handle_movement():Void
	{	
		// cancel opposing directions
		if (up_pressed && down_pressed)
			up_pressed = down_pressed = false;
		if (left_pressed && right_pressed)
			left_pressed = right_pressed = false;

		if (left_pressed) {
			_rotation = 180;
			if (up_pressed) _rotation += 45;
			else if (down_pressed) _rotation -= 45;
		} else if (right_pressed) {
			_rotation = 0;
			if (up_pressed) _rotation -= 45;
			else if (down_pressed) _rotation += 45;
		} else if (down_pressed) {
			_rotation = 90;
		} else if (up_pressed) {
			_rotation = 270;
		} else {
			return;
		}
		
		if (left_pressed || right_pressed || up_pressed || down_pressed) {
			var rad_rotation:Float = _rotation*(3.1416 / 180); // convert degrees to radians
			var vx:Float = Math.cos(rad_rotation);
			var vy:Float = Math.sin(rad_rotation);
			
			if (is_dragging){
				// player moves slower when dragging stuff
				body.velocity = new Vec2(vx * _speed/2, vy * _speed/2);
			}
			else {
				angle = _rotation;
				body.velocity = new Vec2(vx * _speed, vy * _speed);
			}
		}
	}
	
	public function raycast_for_boxes():Void
	{
		var origin_point = Vec2.get(x + width/2, y + height/2);
		var direction_vector = Vec2.get(_cosAngle, _sinAngle);
		
		var box_ray:Ray = new Ray(origin_point, direction_vector);
		box_ray.maxDistance = 33;
		
		var rayResultList:RayResultList = FlxNapeSpace.space.rayMultiCast(box_ray);
		
		var should_collide:Bool = false;
		var min:Float = 100;
		has_drag_target = false;
		
		for (rayResult in rayResultList)
		{
			var temp_target:FlxSprite = new FlxSprite();
			
			if (state._isDark){
				for (box in state._darkWorld.boxes){
					if (box.body == rayResult.shape.body){
						should_collide = true;
						temp_target = box;
					}
				}
			}
			else {
				
				for (box in state._lightWorld.boxes){
					if (box.body == rayResult.shape.body){
						should_collide = true;
						temp_target = box;
					}
				}
			}
			
			for (box in state._bothWorlds.boxes){
				if (box.body == rayResult.shape.body){
					should_collide = true;
					temp_target = box;
				}
			}
		
			if (should_collide){
				has_drag_target = true;
				if (min > rayResult.distance) {
					min = rayResult.distance;
					box_target = temp_target;
				}
			}
		}
	}
}
