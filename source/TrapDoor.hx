package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class TrapDoor extends Pit implements Receiver  
{
	private var _closed:Bool;
	
	public function new(x:Int, y:Int, width:Int, height:Int, group:FloorEntitiesGroup, playstate:PlayState) 
	{
		super(x, y, width, height, group, playstate);
		_closed = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		// fall in pit if the trap door is open
		if (!_closed) {
			super.update(elapsed);
		}
	}
	
	// Opens the trap door
	public function activate() 
	{
		if (_closed) {
			// TODO(ariel): Animation to open trap door.
			makeGraphic(width, height, FlxColor.WHITE);
			_closed = false;
		}
	}
	
	// Closes the trap door
	public function deactivate() 
	{
		if (!_closed) {
			// TODO(Ariel): Animation to close trap door.
			makeGraphic(width, height, FlxColor.BLACK);
			_closed = true;
		}
	}
}