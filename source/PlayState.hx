package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		add(new FlxText(10, 10, 100, "We did it! This is the play state!"));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
