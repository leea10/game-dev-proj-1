package;
import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

// TODO(Ariel): Maybe this needs to extend FlxNapeSprite? I'll let Sam decide that.
/**
 * TODO(Ariel): It's possible that we should extract an "ImageSprite" base class and have Box extends that.
 * We'll see when we have more objects to work with.
 */
class Box extends FlxNapeSprite
{
	public var origin_x:Float;
	public var origin_y:Float;
	
	public function new(tilesheetPath:String, frame:Int, x_in:Int, y_in:Int, width:Int, height:Int) 
	{
		origin_x = x_in + (width / 2);
		origin_y = y_in + (height / 2) + (64 - height);
		
		super(origin_x, origin_y);
				
		loadGraphic(tilesheetPath, true, width, height);
		createRectangularBody();
		animation.frameIndex = frame;
		body.type = BodyType.DYNAMIC;
		
		setBodyMaterial(0, 0, 0, 5);
		setDrag(0.5, 0.5);
		
		body.allowMovement = true;
		body.allowRotation = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function set_filter (filter:InteractionFilter)
	{
		body.shapes.at(0).filter = filter;
	}
}