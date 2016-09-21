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
		// this is currently the last level
	}
}