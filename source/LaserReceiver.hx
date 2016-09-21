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
		
		loadGraphic("assets/images/laser receiver off.png");
		
		createRectangularBody();
		body.type = BodyType.KINEMATIC;
		
		setBodyMaterial(0, 0, 0, 10);
		
		body.allowMovement = false;
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
			loadGraphic("assets/images/laser receiver on.png");
			
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
			loadGraphic("assets/images/laser receiver off.png");
			
			if (_receiver != null) 
			{
				_receiver.deactivate();
			}
		}
	}
}