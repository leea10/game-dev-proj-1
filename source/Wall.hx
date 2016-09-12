package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.addons.nape.FlxNapeSprite;

class Wall extends FlxSprite
{
	public var w:Int;
	public var h:Int;
	
	public function new(?x:Float=0, ?y:Float=0, ?wid:Int=0, ?het:Int=0)
	{
		super(x, y);
		w = wid;
		h = het;

		makeGraphic(w, h, FlxColor.LIME);
		//createRectangularBody();
		solid = true;
		immovable = true;
		visible = false;
	}
	
}