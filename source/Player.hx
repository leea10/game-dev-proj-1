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
	
	public var is_dead:Bool = false;
	
	var box_offset:Vec2 = Vec2.get(0,0);
	
	public var box_target:FlxSprite = new FlxSprite();
	public var has_drag_target:Bool = false;
	public var is_dragging:Bool = false;
	public var has_been_dragging:Bool = false;
	public var drag_axis:String = "";
	
	public var switch_target:Switch;
	public var has_switch_target:Bool = false;
	
	public var state:PlayState;
	
	public var hit_area:FlxSprite;
	
	public function new(tilesheetPath:String, frame:Int, x:Int, y:Int, width:Int, height:Int)
	{
		super(x, y);
		var framerate:Int = 5;
		loadGraphic("assets/images/player_sprite_sheet_single_line.png", true, 64, 64);
		animation.add("walk", [4, 5], framerate, true);
		animation.add("push walk", [0, 1], framerate, true);
		animation.add("idle", [3], framerate, false);
		animation.add("push idle", [2], framerate, false);
		
		animation.play("idle");
		
		//animation.frameIndex = frame;
		
		createRectangularBody();
		body.type = BodyType.DYNAMIC;
		
		setBodyMaterial(0, 0, 0, 1);
		setDrag(0.5, 0.5);
		
		body.allowMovement = true;
		body.allowRotation = false;
		body.inertia = 1000;
		
		body.scaleShapes(0.65, 0.65);
		
		hit_area = new FlxSprite(x, y);
		hit_area.makeGraphic(41, 41, FlxColor.TRANSPARENT);
		
		FlxG.camera.follow(this);
		
		solid = true;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (!is_dead){
			check_for_switches();
			handle_key_presses();
			handle_movement();
			
			has_drag_target = false;
			raycast_for_boxes();
			get_drag_axis();
			
			if (is_dragging){
				var box:FlxNapeSprite = cast box_target;
				reset(box_offset.x+box.x+32,box_offset.y+box.y+32);
				
				box.body.velocity = this.body.velocity;
				if (drag_axis == "horizontal" && (left_pressed || right_pressed)){
					has_been_dragging = true;
				}
				else if (drag_axis == "vertical" && (up_pressed || down_pressed)){
					has_been_dragging = true;
				}
			}
			else {
				has_been_dragging = false;
			}
			
			
			if (body.velocity.length > 0.1){
				if (is_dragging){
					animation.play("push walk");
				}
				else {
					animation.play("walk");
				}
			} else {
				animation.stop();
				
				if (is_dragging){
					animation.play("push idle");
				}
				else {
					animation.play("idle");
				}
			}
		}
		
		if (has_drag_target){
			state.ui_man.drag_prompt.visible = true;
		}
		else {
			state.ui_man.drag_prompt.visible = false;
		}
		
		if (has_switch_target){
			state.ui_man.switch_prompt.visible = true;
		}
		else {
			state.ui_man.switch_prompt.visible = false;
		}
		
		hit_area.x = x+11;
		hit_area.y = y+11;
	}
	
	public function handle_key_presses():Void
	{
		up_pressed = FlxG.keys.anyPressed([UP, W]);
		down_pressed = FlxG.keys.anyPressed([DOWN, S]);
		left_pressed = FlxG.keys.anyPressed([LEFT, A]);
		right_pressed = FlxG.keys.anyPressed([RIGHT, D]);

		var tempdrag:Bool = is_dragging;
		is_dragging = FlxG.keys.pressed.SHIFT && has_drag_target;
		
		if (!tempdrag && is_dragging){ // we JUST started dragging something
			box_offset = Vec2.get(x - box_target.x, y - box_target.y);
		}
		
		if (has_switch_target && FlxG.keys.justPressed.E){
			switch_target.trigger();
		}
		
	}
	
	public function check_for_switches():Void
	{
		has_switch_target = false;
		var maxdist:Float = 70;
		
		if (state._isDark){
			for (s in state._darkWorld.switches){				
				if (Vec2.get((s.x+s.width/2)-(x+width/2),(s.y+s.height/2)-(y+height/2)).length < maxdist){
					switch_target = s;
					has_switch_target = true;
				}
			}
		}
		else {
			for (s in state._lightWorld.switches){
				if (Vec2.get((s.x+s.width/2)-(x+width/2),(s.y+s.height/2)-(y+height/2)).length < maxdist){
					switch_target = s;
					has_switch_target = true;
				}
			}
		}
		
		for (s in state._bothWorlds.switches){
			if (Vec2.get((s.x+s.width/2)-(x+width/2),(s.y+s.height/2)-(y+height/2)).length < maxdist){
				switch_target = s;
				has_switch_target = true;
			}
		}
		
	}
	
	public function get_drag_axis():Void
	{
		if ((angle >= 179.9 && angle <= 180.1) || (angle >= 359.9 || angle <= 0.1))
		{
			drag_axis = "horizontal";
		}
		else if ((angle >= 89.9 && angle <= 90.1) || (angle >= 269.9 && angle <= 270.1))
		{
			drag_axis = "vertical";
		}
		else
		{
			// if we're not facing in a cardinal direction, dragging is disabled
			has_drag_target = false;
		}
		
	}
	
	public function handle_movement():Void
	{	
		// cancel opposing directions
		if (up_pressed && down_pressed)
			up_pressed = down_pressed = false;
		if (left_pressed && right_pressed)
			left_pressed = right_pressed = false;
			
		if (is_dragging){
			if (drag_axis == "horizontal"){
				up_pressed = down_pressed = false;
			}
			if (drag_axis == "vertical"){
				left_pressed = right_pressed = false;
			}
		}

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
				body.velocity = new Vec2(vx * _speed / 2, vy * _speed / 2);
			}
			else {				
				var shortest_angle:Float = ((((_rotation - angle) % 360) + 540) % 360) - 180;
				angle += shortest_angle * 0.5;
				angle = (angle+360)%360.0;
				
				body.velocity = new Vec2(vx * _speed, vy * _speed);
			}
		}
	}
	
	public function raycast_for_boxes():Void
	{
		var origin_point = Vec2.get(x + width/2, y + height/2);
		var direction_vector = Vec2.get(_cosAngle, _sinAngle);
		
		var box_ray:Ray = new Ray(origin_point, direction_vector);
		box_ray.maxDistance = 25;
		
		var rayResultList:RayResultList = FlxNapeSpace.space.rayMultiCast(box_ray);
		
		var should_collide:Bool = false;
		var min:Float = 100;
		
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
			
			if (state.mirror.body == rayResult.shape.body){
				should_collide = true;
				temp_target = state.mirror;
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
	
	public function die():Void
	{
		is_dead = true;
		body.type = BodyType.STATIC;
		set_physicsEnabled(false);
		
		state.waitAndRestart(1500);
	}
}
