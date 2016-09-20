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
		init("assets/levels/level1 copy.tmx");
	}
	
	override function nextLevel()
	{
		// this is currently the last level
	}
}