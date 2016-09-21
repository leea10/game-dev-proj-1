package;
import flixel.FlxG;
import haxe.Timer;

class TutorialFourState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/Tutorial_4.tmx");
		
		//Timer.delay(break_box, 3000);
		break_box();
	}
	
	override function nextLevel()
	{	
		var x:LevelOneState = new LevelOneState();
		FlxG.switchState(x);
		x._isDark = _isDark;
	}
}