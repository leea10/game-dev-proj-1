package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class TestLevelState extends PlayState
{

	override public function create():Void
	{
		super.create();
		
		// load a level -- the player is in the light version, and we want them to appear on top of everything else, so we load that level last
			// dark version
		level = new TiledLevel("assets/levels/templevel_dark.tmx", this, true);
			// light version
		level = new TiledLevel("assets/levels/templevel_light.tmx", this, false);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
}