package;

/**
 * ...
 * @author ...
 */
class LevelOneState extends PlayState 
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/level_1.tmx");
	}
	
	override function nextLevel()
	{
		// this is currently the last level
	}
}