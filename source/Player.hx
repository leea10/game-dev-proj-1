 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;
 import flixel.math.FlxMath;

 class Player extends FlxSprite
 {
	public var in_dark_world:Bool = false;
	
	
	// key presses
	var space_just_pressed:Bool;
	
	var up_pressed:Bool = false;
	var down_pressed:Bool = false;
	var left_pressed:Bool = false;
	var right_pressed:Bool = false;
	
	var speed:Float = 150;
	var rotation:Float = 0;
	
	
	public function new(?x:Float=0, ?y:Float=0)
	{
		super(x, y);
		 
		makeGraphic(32, 32, FlxColor.BLUE);
		FlxG.camera.follow(this);
		
		drag.x = 1600;
		drag.y = 1600;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		handle_key_presses();
		handle_movement();
		
		// magic 
		// (lerps player in the direction of their velocity)
		var shortest_angle:Float = ((((rotation - angle) % 360) + 540) % 360) - 180;
		angle += shortest_angle * 0.3;
	}
	
	public function handle_key_presses():Void
	{
		space_just_pressed = FlxG.keys.anyJustPressed([SPACE]);

		up_pressed = FlxG.keys.anyPressed([UP, W]);
		down_pressed = FlxG.keys.anyPressed([DOWN, S]);
		left_pressed = FlxG.keys.anyPressed([LEFT, A]);
		right_pressed = FlxG.keys.anyPressed([RIGHT, D]);
	}
	
	public function handle_movement():Void
	{
		// should we swap worlds?
		if (space_just_pressed)
		{
			if (in_dark_world)
				enter_light_world();
			else
				enter_dark_world();
		}
		
		// cancel opposing directions
		if (up_pressed && down_pressed)
			up_pressed = down_pressed = false;
		if (left_pressed && right_pressed)
			left_pressed = right_pressed = false;

		// should we move at all?
		if (up_pressed || down_pressed || left_pressed || right_pressed)
		{
			if (left_pressed)
			{
				rotation = 180;
				facing = FlxObject.LEFT;
				if (up_pressed)
					rotation += 45;
				else if (down_pressed)
					rotation -= 45;
			}
			else if (right_pressed)
			{
				rotation = 0;
				facing = FlxObject.RIGHT;
				if (up_pressed)
					rotation -= 45;
				else if (down_pressed)
					rotation += 45;
			}
			else if (down_pressed)
				rotation = 90;
			else if (up_pressed)
				rotation = 270;
			 
			velocity.set(speed,0);
			velocity.rotate(new FlxPoint(0, 0), rotation);
		}
	}
	
	public function enter_dark_world():Void
	{
		if (!in_dark_world)
		{
			x += 10000;
			in_dark_world = true;
		}
	}
	
	public function enter_light_world():Void
	{
		if (in_dark_world)
		{
			x -= 10000;
			in_dark_world = false;
		}
	}
	
 }