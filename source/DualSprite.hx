 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;

 class DualSprite extends FlxSprite
 {
	var state:PlayState;
	
	var dark_version:FlxSprite;
	 
	public function new(?x:Float=0, ?y:Float=0, playstate:PlayState)
	{
		super(x, y);
		state = playstate;
		
		dark_version = new FlxSprite(x + 10000, y);
		state.add(dark_version);

		solid = true;
		dark_version.solid = true;
		
		drag.x = 10000;
		drag.y = 10000;
		
		dark_version.drag.x = 10000;
		dark_version.drag.y = 10000;
		
		makeGraphic(32, 32, FlxColor.WHITE);
		dark_version.makeGraphic(32, 32, FlxColor.BLACK);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(this, state.wall_tiles_light);
		FlxG.collide(this, state.wall_tiles_dark_copy);
		
		FlxG.collide(dark_version, state.wall_tiles_dark);
		FlxG.collide(dark_version, state.wall_tiles_light_copy);
		
		FlxG.collide(this, state.player);
		FlxG.collide(dark_version, state.player);
		
		if (state.player.in_dark_world){
			this.x = dark_version.x-10000;
			this.y = dark_version.y;
		}
		else {
			dark_version.x = this.x+10000;
			dark_version.y = this.y;
		}
		
		//this.velocity.x = 0;
		//this.velocity.y = 0;
		//dark_version.velocity.x = 0;
		//dark_version.velocity.y = 0;
	}

 }