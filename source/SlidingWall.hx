package;

import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

class SlidingWall extends FlxNapeSprite implements Receiver
{
	public var origin_x:Float;
	public var origin_y:Float;
	
	public var dest_x:Float;
	public var dest_y:Float;
	
	public function new(tilesheetPath:String, frame:Int, x_in:Int, y_in:Int, width:Int, height:Int, destxpos:Int, destypos:Int) 
	{
		origin_x = x_in + (width / 2);
		origin_y = y_in + (height / 2) + (64 - height);
		
		dest_x = destxpos+width/2;
		dest_y = destypos-height/2;
		
		super(origin_x, origin_y);
		
		loadGraphic(tilesheetPath, true, width, height);
		createRectangularBody();
		animation.frameIndex = frame;
		body.type = BodyType.KINEMATIC;
		
		setBodyMaterial(0, 0, 0, 10);
		
		body.allowMovement = true;
		body.allowRotation = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function set_filter (filter:InteractionFilter):Void
	{
		body.shapes.at(0).filter = filter;
	}
	
	public function activate():Void {
		FlxTween.tween(body.position, { x: dest_x, y: dest_y }, .2, { type: FlxTween.ONESHOT } );
	}
	
	public function deactivate():Void {
		FlxTween.tween(body.position, { x: origin_x, y: origin_y }, .2, { type: FlxTween.ONESHOT } );
	}
}