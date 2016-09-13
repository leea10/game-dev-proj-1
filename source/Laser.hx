package;

import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

import nape.geom.Ray;
import nape.geom.Vec2;
import nape.geom.RayResultList;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;

class Laser extends FlxSprite 
{
	var max_distance:Float = 600;
	var hit_circle:FlxSprite;
	var state:PlayState;
	
	var circle_width:Int = 16;
	
	public var in_dark_world:Bool = false;
	public var in_light_world:Bool = false;
	
	public function new(x_pos:Float, y_pos:Float, length:Float, rotation:Float, playstate:PlayState, dark_world:Bool, light_world:Bool) 
	{
		super(x_pos, y_pos);
		state = playstate;
		
		loadGraphic("assets/images/temp laser.png");
		
		angle = rotation;
		scale.set(length / width, 1);
		
		origin.set(0, height / 2);
		x = x_pos;
		y = y_pos;
		in_dark_world = dark_world;
		in_light_world = light_world;
		
		hit_circle = new FlxSprite();
		hit_circle.makeGraphic(circle_width, circle_width, FlxColor.RED);
		state.add(hit_circle);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		var origin_point = Vec2.get(x, y);
		var direction_vector = Vec2.get(_cosAngle, _sinAngle);
		
		var laser_ray:Ray = new Ray(origin_point, direction_vector);
		laser_ray.maxDistance = max_distance;
		
		
		var rayResultList:RayResultList = FlxNapeSpace.space.rayMultiCast(laser_ray);
		var min = max_distance;
		var min_x:Float = 0;
		var min_y:Float = 0;
		
		for (rayResult in rayResultList)
		{
			// determine if this wall is in a world this laser should interact with
			var should_collide:Bool = true;
			if (!in_dark_world){
				for (wall in state._darkWorld.walls){
					if (wall.body == rayResult.shape.body){
						should_collide = false;
					}
				}
				
				if (state._isDark){
					if (state.nape_player.body == rayResult.shape.body){
						should_collide = false;
					}
				}
			}
			if (!in_light_world){
				for (wall in state._lightWorld.walls){
					if (wall.body == rayResult.shape.body){
						should_collide = false;
					}
				}
				
				if (!state._isDark){
					if (state.nape_player.body == rayResult.shape.body){
						should_collide = false;
					}
				}
			}
			
			
			if (should_collide){
				if (min > rayResult.distance) {
					min = rayResult.distance;
					
					min_x = x + (direction_vector.x * min);
					min_y = y + (direction_vector.y * min);
					
					scale.set(min / width, 1);
				}
			}
		}
		
		hit_circle.x = min_x - (circle_width/2);
		hit_circle.y = min_y - (circle_width/2);
	}
}