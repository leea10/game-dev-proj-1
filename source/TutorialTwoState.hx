package;

/**
 * ...
 * @author ...
 */
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
		/*
		var x:TutorialTwoState = new TutorialTwoState();
		FlxG.switchState(x);
		x._isDark = _isDark;
		*/
	}
}