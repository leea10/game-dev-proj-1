package;

import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.FlxObject;

class MenuButton extends FlxButton
{
	
	public function new(X:Float = 0, Y:Float = 0, ?Text:String, ?OnClick:Void>Void)
	{
		super(X,Y,Text,OnClick);
		
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}