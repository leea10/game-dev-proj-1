 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;

 class Player extends FlxSprite
 {

     public function new(?x:Float=0, ?y:Float=0)
     {
         super(x, y);
		 
		 makeGraphic(16, 16, FlxColor.BLUE);
		 FlxG.camera.follow(this);
     }
	 
	 override public function update(elapsed:Float):Void
	 {
		 super.update(elapsed);
	 }
	 
 }