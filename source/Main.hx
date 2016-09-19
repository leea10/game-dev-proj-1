package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.FPS;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1280, 720, MenuState));
		
		//var fps:FPS = new FPS(10, 10, 0xff0000);
		//addChild(fps);
	}
}
