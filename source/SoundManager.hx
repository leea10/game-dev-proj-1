package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class SoundManager extends FlxGroup
{
	public var scream_noise:FlxSound;
	
	public function new()
	{
		super();
		scream_noise = FlxG.sound.load("assets/sounds/SCREAM.ogg");
		trace("????");
		scream_noise.play();
		scream_noise.volume = 1;
		trace (scream_noise.playing);
		
		//FlxG.sound.play("scream");
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//scream_noise.play();
		//trace("!!!");
	}

}