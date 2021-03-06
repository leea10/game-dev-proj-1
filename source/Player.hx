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
	
	public var vx:Float = 0;
	public var vy:Float = 0;
		
	public function new(?x:Float=0, ?y:Float=0)
	{
		super(x, y);
		 
		makeGraphic(32, 32, FlxColor.BLUE);
		FlxG.camera.follow(this);
		
		solid = true;
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
		//var shortest_angle:Float = ((((rotation - angle) % 360) + 540) % 360) - 180;
		//angle += shortest_angle * 0.3;
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
				velocity.x = -speed;
			}
			if (right_pressed)
			{
				velocity.x = speed;
			}
			if (up_pressed)
			{
				velocity.y = -speed;
			}
			if (down_pressed)
			{
				velocity.y = speed;
			}

			/*
			if ((left_pressed && (up_pressed || down_pressed)) || (right_pressed && (up_pressed || down_pressed)))
			{
				vy /= 1.414;
				vx /= 1.414;
			}
			*/
		}
		else {
			//vx = 0;
			//vy = 0;
		}

		//x += vx;
		//y += vy;
	}
	
	public function enter_dark_world():Void
	{
		if (!in_dark_world)
		{
			reset(x + 10000, y);
			in_dark_world = true;
		}
	}
	
	public function enter_light_world():Void
	{
		if (in_dark_world)
		{
			reset(x - 10000, y);
			in_dark_world = false;
		}
	}
	
 }