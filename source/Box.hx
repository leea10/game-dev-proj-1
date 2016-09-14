package;
import flixel.FlxSprite;

// TODO(Ariel): Maybe this needs to extend FlxNapeSprite? I'll let Sam decide that.
/**
 * TODO(Ariel): It's possible that we should extract an "ImageSprite" base class and have Box extends that.
 * We'll see when we have more objects to work with.
 */
class Box extends FlxSprite
{
	public function new(tilesheetPath:String, frame:Int, x:Int, y:Int, width:Int, height:Int) 
	{
		super(x, y);
		loadGraphic(tilesheetPath, true, width, height);
		animation.frameIndex = frame;
		drag.x = drag.y = 1000;
	}
}