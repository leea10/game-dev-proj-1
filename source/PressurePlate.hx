package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class PressurePlate extends FlxSprite implements Trigger 
{
	public var _receiver:Receiver;
	private var _on:Bool;
	
	public function new(x:Int, y:Int, width:Int, height:Int, ?receiver:Receiver = null)
	{
		super(x, y);
		makeGraphic(width, height, FlxColor.YELLOW);
		_receiver = receiver;
		
		immovable = true;
	}
	
	public function trigger() 
	{
		if (!_on) {
			_on = true;
			// Change appearance
		}
	}
	
	public function release() 
	{
		if (_on) {
			_on = false;
			// Change appearance
		}
	}
}