package;

import flixel.FlxG;
import flixel.FlxState;

class TestLevelStateTwo extends PlayState
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/templevel.tmx");
	}
	
	override function nextLevel()
	{
		// this is currently the last level
	}
}