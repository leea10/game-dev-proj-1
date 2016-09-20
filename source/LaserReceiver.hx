package;

import flixel.FlxG;
import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

/**
 * ...
 * @author ...
 */
class LaserReceiver extends FlxNapeSprite implements Trigger 
{
	public var _receiver:Receiver;
	private var _on:Bool;
	
	public var just_triggered = true;

	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		makeGraphic(16, 16, FlxColor.ORANGE);
		createRectangularBody();
		body.type = BodyType.STATIC;
		
		setBodyMaterial(0, 0, 0, 10);
		
		body.allowMovement = false;
		body.allowRotation = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (!just_triggered) {
			release();
		}
		just_triggered = false;
	}
	
	public function set_filter (filter:InteractionFilter):Void
	{
		body.shapes.at(0).filter = filter;
	}
	
	public function trigger() 
	{
		if (!_on) {
			_on = true;
			
			trace("now on");
			
			if (_receiver != null) 
			{
				_receiver.activate();
			}
		}
		
		just_triggered = true;
	}
	
	public function release() 
	{
		if (_on) {
			_on = false;
			
			if (_receiver != null) 
			{
				_receiver.deactivate();
			}
		}
	}
}