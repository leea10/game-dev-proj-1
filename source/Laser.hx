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

class Laser extends FlxSprite 
{
	
	public function new(x:Float, y:Float, length:Float, rotation:Float) 
	{
		super(x, y);
		
		loadGraphic("assets/images/temp laser.png");
		
		angle = rotation;
		scale.set(length / width, 1);
		
		origin.set(0, height / 2);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		var origin:Vec2 = new Vec2(x, y);
		var direction_vector:Vec2 = new Vec2(_cosAngle, _sinAngle);
		
		var ray:Ray = new Ray(origin, direction_vector);
		var rayResultList:RayResultList = FlxNapeSpace.space.rayMultiCast(ray);
		
		for (rayResult in rayResultList)
		{
			
			
		}
	}
}