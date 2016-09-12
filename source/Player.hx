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
	// key presses	
	var up_pressed:Bool = false;
	var down_pressed:Bool = false;
	var left_pressed:Bool = false;
	var right_pressed:Bool = false;

	var _speed:Float = 200;	
	var _rotation = 0;
	
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
		up_pressed = FlxG.keys.anyPressed([UP, W]);
		down_pressed = FlxG.keys.anyPressed([DOWN, S]);
		left_pressed = FlxG.keys.anyPressed([LEFT, A]);
		right_pressed = FlxG.keys.anyPressed([RIGHT, D]);
	}
	
	public function handle_movement():Void
	{	
		// cancel opposing directions
		if (up_pressed && down_pressed)
			up_pressed = down_pressed = false;
		if (left_pressed && right_pressed)
			left_pressed = right_pressed = false;

		// should we move at all?
		if (left_pressed) {
			_rotation = 180;
			if (up_pressed) _rotation += 45;
			else if (down_pressed) _rotation -= 45;
		} else if (right_pressed) {
			_rotation = 0;
			if (up_pressed) _rotation -= 45;
			else if (down_pressed) _rotation += 45;
		} else if (down_pressed) {
			_rotation = 90;
		} else if (up_pressed) {
			_rotation = 270;
		} else {
			return;
		}
		
		velocity.set(_speed, 0);
		velocity.rotate(new FlxPoint(0, 0), _rotation);
	}
 }