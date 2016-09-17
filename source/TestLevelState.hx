package;

import flixel.FlxG;
import flixel.FlxState;

class TestLevelState extends PlayState
{
	override public function create():Void
	{
		super.create();
		init("assets/levels/templevel.tmx");
	}
}