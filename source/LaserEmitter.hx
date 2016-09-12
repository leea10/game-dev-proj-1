package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.addons.nape.FlxNapeSprite;

class LaserEmitter extends FlxSprite
{
	var length:Int = 600;
	var state:PlayState;
	
	var laser:Laser;

	public function new(?x:Float=0, ?y:Float=0, playstate:PlayState)
	{
		super(x, y);
		state = playstate;
		
		makeGraphic(16, 16, FlxColor.ORANGE);
		origin.set(width / 2, height / 2);
		
		laser = new Laser(x+(width/2), y+(height/2)-4, length, angle);
		state.add(laser);
		//visible = false;
		
		//var house = new FlxNapeSprite(x + 100, y + 100);
		//state.add(house);
		
		
		var _test = new FlxNapeSprite(x + 100, y + 100);
        _test.makeGraphic(16, 16, FlxColor.GRAY);
        _test.createRectangularBody();
        state.add(_test);
		
		var _test2 = new FlxNapeSprite(x + 150, y + 100);
        _test2.makeGraphic(20, 50, FlxColor.GRAY);
        _test2.createRectangularBody();
        state.add(_test2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		update_laser();
	}
	
	function update_laser():Void
	{	
		angle += 1;
		laser.angle = angle;
	}

}