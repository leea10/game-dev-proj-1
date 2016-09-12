 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;
 import flixel.addons.nape.FlxNapeSprite;

 class Wall extends FlxNapeSprite
 {
	public function new(?x:Float=0, ?y:Float=0, ?w:Int=0, ?h:Int=0)
	{
		super(x+(w/2), y+(h/2));
		
		//makeGraphic(w, h, FlxColor.LIME);
		createRectangularBody();
		//solid = true;
		//immovable = true;
		//visible = false;
	}
	
}