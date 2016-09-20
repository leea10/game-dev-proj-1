package;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import nape.dynamics.InteractionFilter;

class Door extends FlxNapeSprite implements Receiver 
{
	private var _open:Bool = false;
	
	public function new(x:Int, y:Int, width:Int, height:Int) 
	{
		super(x + width/2, y + width/2);
		makeGraphic(width, height, FlxColor.RED);
		
		createRectangularBody();
		setBodyMaterial(0, 0, 0, 1);		
		body.allowMovement = false;
		body.allowRotation = false;
	}
	
	public function activate() 
	{
		// TODO(ariel): Play the open door animation
		makeGraphic(cast width, cast height, FlxColor.LIME);
		_open = true;
		set_physicsEnabled(false);
	}
	
	public function deactivate() 
	{
		// TODO(ariel): Play the close door animation
		makeGraphic(cast width, cast height, FlxColor.RED);
		_open = false;
		set_physicsEnabled(true);
	}
	
	public function setFilter (filter:InteractionFilter)
	{
		body.shapes.at(0).filter = filter;
	}
}