package;
import flixel.FlxG;

class LevelOneState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/level_1.tmx");
	}
	
	override function nextLevel()
	{
		var x:LevelTwoState = new LevelTwoState();
		FlxG.switchState(x);
		x._isDark = _isDark;		
	}
}