package;
import flixel.FlxG;

class TutorialOneState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/Tutorial_1.tmx");
		is_tutorial = true;
	}
	
	override function nextLevel()
	{
		var x:TutorialTwoState = new TutorialTwoState();
		FlxG.switchState(x);
		x._isDark = _isDark;
	}
}