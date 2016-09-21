package;

class LevelThreeState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/level_3.tmx");
	}
	
	override function nextLevel()
	{
		// this is currently the last level
	}
}