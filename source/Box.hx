package;
import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.addons.nape.FlxNapeSprite;

// TODO(Ariel): Maybe this needs to extend FlxNapeSprite? I'll let Sam decide that.
/**
 * TODO(Ariel): It's possible that we should extract an "ImageSprite" base class and have Box extends that.
 * We'll see when we have more objects to work with.
 */
class Box extends FlxNapeSprite
{
	public function new(tilesheetPath:String, frame:Int, x:Int, y:Int, width:Int, height:Int) 
	{
		super(x, y);
		loadGraphic(tilesheetPath, true, width, height);
		createRectangularBody();
		animation.frameIndex = frame;
		body.type = BodyType.DYNAMIC;
		solid = true;
		
		setBodyMaterial(0, 0, 0, 1);
		setDrag(0.5, 0.5);
		
		body.allowMovement = true;
		body.allowRotation = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}