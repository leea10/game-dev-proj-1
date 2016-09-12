package;

import flixel.FlxSprite;
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
	
	public function new(x:Float, y:Float, length:Float, rotation:Float) 
	{
		super(x, y);
		FlxNapeSpace.init();
		
		loadGraphic("assets/images/temp laser.png");
		
		angle = rotation;
		scale.set(length / width, 1);
		
		origin.set(0, height / 2);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		var origin = Vec2.get(x, y);
		var direction_vector = Vec2.get(_cosAngle, _sinAngle);
		
		var laser_ray:Ray = new Ray(origin, direction_vector);
		laser_ray.maxDistance = 600;
		
		//var laser_ray = Ray.fromSegment(origin, direction_vector);
		
		var rayResultList:RayResultList = FlxNapeSpace.space.rayMultiCast(laser_ray);
		for (rayResult in rayResultList)
		{
			scale.set(rayResult.distance / width, 1);
		}
	}
}