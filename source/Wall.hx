package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.addons.nape.FlxNapeSprite;
import nape.phys.BodyType;

class Wall extends FlxNapeSprite
{
	public var w:Int;
	public var h:Int;
	
	public var origin_x:Float;
	public var origin_y:Float;
	
	public function new(?x:Float=0, ?y:Float=0, ?wid:Int=0, ?het:Int=0)
	{
		w = wid;
		h = het;
		
		origin_x = x + (w / 2);
		origin_y = y + (h / 2);
		
		super(origin_x, origin_y);

		immovable = true;
		solid = true;
		makeGraphic(w, h, FlxColor.LIME);
		createRectangularBody();
		body.type = BodyType.STATIC;
		//visible = false;
	}
}