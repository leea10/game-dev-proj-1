package;
import flixel.FlxG;

class TutorialThreeState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/Tutorial_3.tmx");
		is_tutorial = true;
	}
	
	override function nextLevel()
	{	
		var x:TutorialFourState = new TutorialFourState();
		FlxG.switchState(x);
		x._isDark = _isDark;
	}
}