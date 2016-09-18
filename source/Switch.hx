package;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

class Switch extends FlxNapeSprite implements Trigger
{
	public var _receiver:Receiver;
	private var _on:Bool;
	
	// TODO(ariel): Include a sprite
	public function new(x:Int, y:Int, width:Int, height:Int, ?receiver:Receiver = null) 
	{
		super(x + width/2, y + width/2);
		makeGraphic(width, height, FlxColor.BLUE);
		_receiver = receiver;
		
		createRectangularBody();
		
		setBodyMaterial(0, 0, 0, 1);		
		body.allowMovement = false;
		body.allowRotation = false;
		solid = true;
		
		_on = false;
	}
	
	public function setReceiver(receiver:Receiver)
	{
		_receiver = receiver;
	}
	
	public function setFilter (filter:InteractionFilter)
	{
		body.shapes.at(0).filter = filter;
	}
	
	public function trigger():Void
	{
		_on = !_on;
		// TODO(ariel): Possibly switch sprite to show which state the switch is in
		if (_receiver != null) 
		{
			_on ? _receiver.activate() : _receiver.deactivate();
		}
	}
}