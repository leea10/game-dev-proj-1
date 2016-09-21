package;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import nape.dynamics.InteractionFilter;

class Door extends FlxNapeSprite implements Receiver 
{
	private var _open:Bool = false;
	
	public function new(x:Int, y:Int, width:Int, height:Int) 
	{	
		super(x + width/2, y + height/2);
		loadGraphic("assets/images/door2 small.png", true, 9, 128);
		
		createRectangularBody();
		setBodyMaterial(0, 0, 0, 1);
		body.allowMovement = false;
		body.allowRotation = false;
		
		animation.add("open", [0, 1, 2, 3, 4, 5], 20, false);
		animation.add("close", [5, 4, 3, 2, 1, 0], 20, false);
		
		_open = false;
		set_physicsEnabled(true);
		animation.play("close");
	}
	
	public function activate() 
	{
		// TODO(ariel): Play the open door animation
		//makeGraphic(cast width, cast height, FlxColor.LIME);
		if (!_open) {
			animation.play("open");
		}
		_open = true;
		set_physicsEnabled(false);
	}
	
	public function deactivate() 
	{
		
	}
	
	public function setFilter (filter:InteractionFilter)
	{
		body.shapes.at(0).filter = filter;
	}
}