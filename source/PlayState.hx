package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	public var level:TiledLevel;
	public var player:Player;
	public var mirror:Mirror;
	
	override public function create():Void
	{
		super.create();
		
		add(new FlxText(10, 10, 100, "We did it! This is the play state!"));
		
		// load a level
		level = new TiledLevel("assets/levels/templevel.tmx", this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
