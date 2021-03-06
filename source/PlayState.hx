package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	public var level:TiledLevel;
	public var player:Player;
	public var mirror:Mirror;
	
	public var wall:Wall;
	
	private var wall_group:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	
	public var wall_tiles_light:FlxGroup;
	public var wall_tiles_dark:FlxGroup;
	public var wall_tiles_light_copy:FlxGroup;	// a copy of the light-world tiles in the dark world (for collision purposes)
	public var wall_tiles_dark_copy:FlxGroup;	// a copy of the dark-world tiles in the light world (for collision purposes)
	
	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
		
		FlxG.collide(player, wall_tiles_light);
		FlxG.collide(player, wall_tiles_dark);
	}
}
