package;

class LevelTwoState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/level_2.tmx");
	}
	
	override function nextLevel()
	{
		var x:LevelTwoState = new LevelThreeState();
		FlxG.switchState(x);
		x._isDark = _isDark;
	}
}