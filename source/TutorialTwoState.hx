package;
import flixel.FlxG;

class TutorialTwoState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/Tutorial_2.tmx");
		is_tutorial = true;
	}
	
	override function nextLevel()
	{	
		var x:TutorialThreeState = new TutorialThreeState();
		FlxG.switchState(x);
		x._isDark = _isDark;
	}
}