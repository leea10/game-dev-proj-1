 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;

 class Wall extends FlxSprite
 {
	public function new(?x:Float=0, ?y:Float=0, ?w:Int=0, ?h:Int=0)
	{
		super(x, y);
		
		makeGraphic(w, h, FlxColor.LIME);
		solid = true;
		immovable = true;
		visible = false;
	}
	
}