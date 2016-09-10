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
		
		//FlxG.scaleMode = new StageSizeScaleMode();
		//FlxG.fullscreen = true;
		
		// custom cursors suck. we should just use the system default
		FlxG.mouse.useSystemCursor = true;
		
		// put a PLAY button in the middle of the screen
		play_button = new FlxButton(0, 0, "PLAY", switchToPlayState);
		play_button.screenCenter();
		add(play_button);
		
		// TO DO: make a real menu...
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function switchToPlayState():Void
	{
		// switch to play state (only one state can be active at a time)
		FlxG.switchState(new PlayState());
	}
}
