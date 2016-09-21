package;
import flixel.FlxG;
import haxe.Timer;

class TutorialFourState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/Tutorial_4.tmx");
		is_tutorial = true;
		
		Timer.delay(break_box, 1000);
	}
	
	override function nextLevel()
	{	
		/*
		var x:TutorialTwoState = new TutorialTwoState();
		FlxG.switchState(x);
		x._isDark = _isDark;
		*/
	}
}