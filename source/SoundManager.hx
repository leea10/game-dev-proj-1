package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class SoundManager extends FlxGroup
{
	public var scream:FlxSound;
	public var ambience:FlxSound;
	public var drag:FlxSound;
	public var error:FlxSound;
	public var steps:FlxSound;
	public var laser:FlxSound;
	public var plate_on:FlxSound;
	public var plate_off:FlxSound;
	public var switch_hit:FlxSound;
	
	public function new()
	{
		super();
		scream = FlxG.sound.load("assets/sounds/SCREAM.ogg");//
		ambience = FlxG.sound.load("assets/sounds/ambience.ogg");//
		drag = FlxG.sound.load("assets/sounds/box drag.ogg");//
		error = FlxG.sound.load("assets/sounds/error.ogg");//
		steps = FlxG.sound.load("assets/sounds/footsteps.ogg");//
		laser = FlxG.sound.load("assets/sounds/laser.ogg");//
		plate_on = FlxG.sound.load("assets/sounds/pressure plate activate.ogg");//
		plate_off = FlxG.sound.load("assets/sounds/pressure plate deactivate.ogg");//
		switch_hit = FlxG.sound.load("assets/sounds/switch hit.ogg");//
		
		steps.volume = 0.7;
		error.volume = 0.5;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//scream_noise.play();
		//trace("!!!");
	}

}