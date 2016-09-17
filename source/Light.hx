package;

import flash.display.Graphics;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flash.display.BlendMode;

import nape.geom.Ray;
import nape.geom.Vec2;
import nape.geom.RayResultList;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
using flixel.util.FlxSpriteUtil;

class Light extends FlxSprite 
{
	var max_distance:Float = 600;
	var state:PlayState;
	var worldgroup:WorldGroup;
	
	var origin_point:FlxPoint;
	
	public var in_dark_world:Bool = false;
	public var in_light_world:Bool = false;
	
	public function new(?x:Float=0, ?y:Float=0, playstate:PlayState, group:WorldGroup) 
	{
		super(x, y);
		state = playstate;
		worldgroup = group;
		makeGraphic(1, 1, FlxColor.BLUE);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		y += 1;
		origin_point = new FlxPoint(x + width / 2, y + height / 2);
		
		var vertices = new Array<FlxPoint>();
		var corners = new Array<FlxPoint>();
		
		// first we need to make an array of the corners to raycast towards. for now we'll just look at the walls, but we also need to cast towards all other objects
		
		for (wall in state._bothWorlds.walls){
			corners[corners.length] = new FlxPoint(wall.x, wall.y);
			corners[corners.length] = new FlxPoint(wall.x+wall.width, wall.y);
			corners[corners.length] = new FlxPoint(wall.x, wall.y+wall.height);
			corners[corners.length] = new FlxPoint(wall.x+wall.width, wall.y+wall.height);
		}
		if (in_dark_world){
			for (wall in state._darkWorld.walls){
				corners[corners.length] = new FlxPoint(wall.x, wall.y);
				corners[corners.length] = new FlxPoint(wall.x+wall.width, wall.y);
				corners[corners.length] = new FlxPoint(wall.x, wall.y+wall.height);
				corners[corners.length] = new FlxPoint(wall.x+wall.width, wall.y+wall.height);
			}
		}
		if (in_light_world){
			for (wall in state._lightWorld.walls){
				corners[corners.length] = new FlxPoint(wall.x, wall.y);
				corners[corners.length] = new FlxPoint(wall.x+wall.width, wall.y);
				corners[corners.length] = new FlxPoint(wall.x, wall.y+wall.height);
				corners[corners.length] = new FlxPoint(wall.x+wall.width, wall.y+wall.height);
			}
		}
		
		for (point in corners){			
			var origin_vector = Vec2.get(origin_point.x, origin_point.y);
			var direction_vector = Vec2.get(point.x - origin_point.x, point.y - origin_point.y);
			direction_vector = direction_vector.normalise();
			
			var dist_to_point = Vec2.distance(origin_vector, Vec2.get(point.x, point.y));
			
			
			// aim a ray at the center
			var light_ray:Ray = new Ray(origin_vector, direction_vector);
			light_ray.maxDistance = max_distance;
			
			// aim a ray juuust to the right
			light_ray.direction = rotate_vec2(light_ray.direction, 0.0001);
			var rayResultList:RayResultList = FlxNapeSpace.space.rayMultiCast(light_ray);
			vertices[vertices.length] = interpret_ray_result(rayResultList, light_ray);
			
			// aim a ray juuust to the left
			light_ray.direction = rotate_vec2(light_ray.direction, -0.0002);
			var rayResultList:RayResultList = FlxNapeSpace.space.rayMultiCast(light_ray);
			vertices[vertices.length] = interpret_ray_result(rayResultList, light_ray);

		}
		
		
		// sort vertices by angle from this sprite
		vertices.sort( function(a:FlxPoint, b:FlxPoint):Int
		{
			var angleA:Float = FlxAngle.angleBetweenPoint(this, a);
			var angleB:Float = FlxAngle.angleBetweenPoint(this, b);
			
			if (angleA < angleB) return -1;
			if (angleA > angleB) return 1;
			
			var distA:Float = Vec2.distance(Vec2.get(origin_point.x, origin_point.y), Vec2.get(a.x, a.y));
			var distB:Float = Vec2.distance(Vec2.get(origin_point.x, origin_point.y), Vec2.get(b.x, b.y));
			
			if (distA < distB) return -1;
			if (distA > distB) return 1;
			
			return 0;
		} );
		
		/*
		state.canvas.makeGraphic(0, 0, FlxColor.TRANSPARENT);
		state.canvas.makeGraphic(Math.round(FlxG.worldBounds.width), Math.round(FlxG.worldBounds.height), FlxColor.TRANSPARENT);
		state.canvas.drawPolygon(vertices, FlxColor.fromRGB(30,30,30));
		state.canvas.set_blend(BlendMode.ADD);
		*/
		
		for (vert in vertices){
			//state.canvas.drawLine(origin_point.x, origin_point.y, vert.x, vert.y, {thickness: 1, color: FlxColor.RED});
			//state.canvas.drawCircle(vert.x, vert.y, 3, FlxColor.CYAN);
		}
		
	}
	
	public function initialize():Void
	{
		get_worlds();
	}
	
	public function rotate_vec2(vec:Vec2, degrees:Float):Vec2
	{
		var result:Vec2 = new Vec2();
		
		result.x = vec.x * Math.cos(degrees) - vec.y * Math.sin(degrees);
		result.y = vec.x * Math.sin(degrees) + vec.y * Math.cos(degrees);
		
		return result;
	}
	
	public function interpret_ray_result(rayResultList:RayResultList, light_ray:Ray):FlxPoint
	{
		var min = max_distance;
		var min_x:Float = 0;
		var min_y:Float = 0;
		
		for (rayResult in rayResultList)
		{
			// determine if this wall is in a world this light should interact with
			var should_collide:Bool = true;
			
			if (!in_dark_world){
				for (wall in state._darkWorld.walls){
					if (wall.body == rayResult.shape.body){
						should_collide = false;
					}
				}
				
				/*
				if (state._isDark){
					if (state.nape_player.body == rayResult.shape.body){
						should_collide = false;
					}
				}
				*/
			}
			if (!in_light_world){
				for (wall in state._lightWorld.walls){
					if (wall.body == rayResult.shape.body){
						should_collide = false;
					}
				}
				
				/*
				if (!state._isDark){
					if (state.nape_player.body == rayResult.shape.body){
						should_collide = false;
					}
				}
				*/
			}
			if (state.nape_player.body == rayResult.shape.body){
				should_collide = false;
			}
			
			
			if (should_collide){
				if (min > rayResult.distance) {
					min = rayResult.distance;
					
					min_x = light_ray.at(min).x;
					min_y = light_ray.at(min).y;
					
					//state.canvas.drawLine(origin_point.x, origin_point.y, min_x, min_y, {thickness: 1, color: FlxColor.GREEN});
				}
			}
		}
		
		
		return new FlxPoint(min_x, min_y);
	}
	
	function get_worlds():Void
	{
		for (light in state._lightWorld.lights){
			if (light == this){
				in_light_world = true;
			}
		}
		for (light in state._darkWorld.lights){
			if (light == this){
				in_dark_world = true;
			}
		}
		for (light in state._bothWorlds.lights){
			if (light == this){
				in_light_world = true;
				in_dark_world = true;
			}
		}
	}
}