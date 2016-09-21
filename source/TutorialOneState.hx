package;
import flixel.FlxG;

class TutorialOneState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/Tutorial_1.tmx");
	}
	
	override function nextLevel()
	{
		// initialize tutorial level 2
	}
}