package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{	
	var play_button : FlxButton;
	
	override public function create():Void
	{
		super.create();

		// Replace the default Haxeflixel custom cursor with the system cursor
		FlxG.mouse.useSystemCursor = true;
		
		play_button = new FlxButton(0, 0, "PLAY", switchToPlayState);
		play_button.screenCenter();
		add(play_button);
		
		// TO DO: Complete menu; style buttons to be consistent with our asthetic.
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function switchToPlayState():Void
	{
		// switch to play state (only one state can be active at a time)
		// TODO: replace with first tutorial level.
		FlxG.switchState(new LevelOneState());
	}
}
