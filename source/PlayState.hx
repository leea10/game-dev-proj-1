package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;

class PlayState extends FlxState
{
	public var level:TiledLevel;
	public var player:Player;
	public var mirror:Mirror;
	
	public var wall:Wall;
	
	//private var wall_group:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	
	public var wall_tiles_light:FlxGroup;
	public var wall_tiles_dark:FlxGroup;
	public var wall_tiles_light_copy:FlxGroup;	// a copy of the light-world tiles in the dark world (for collision purposes)
	public var wall_tiles_dark_copy:FlxGroup;	// a copy of the dark-world tiles in the light world (for collision purposes)
	
	override public function create():Void
	{
		super.create();
		FlxNapeSpace.init();

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(player, wall_tiles_light);
		FlxG.collide(player, wall_tiles_dark);
	}
	
	public function create_nape_walls()
	{
		for (wallobj in wall_tiles_light)
		{
			var wall:Wall = cast wallobj;
			
			var _test = new FlxNapeSprite(wall.x + (wall.w/2), wall.y + (wall.h/2));
			_test.makeGraphic(wall.w, wall.h, FlxColor.CYAN);
			_test.createRectangularBody();
			_test.visible = false;
			add(_test);
		}
	}
}
