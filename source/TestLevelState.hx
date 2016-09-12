package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.addons.nape.FlxNapeSprite;

class TestLevelState extends PlayState
{
	var nape_player:FlxNapeSprite;

	override public function create():Void
	{
		super.create();
		
		// load a level -- the player is in the light version, and we want them to appear on top of everything else, so we load that level last
			// dark version
		level = new TiledLevel("assets/levels/templevel_dark.tmx", this, true);
			// light version
		level = new TiledLevel("assets/levels/templevel_light.tmx", this, false);
		
		FlxG.worldBounds.width = (level.width*level.tileWidth)*2+10000;
		FlxG.worldBounds.height = level.height * level.tileHeight;
		
		add(new DualSprite(1000, 900, this));
		add(new LaserEmitter(1100, 900, this));

		nape_player = new FlxNapeSprite(1000,1000);
		//nape_player.makeGraphic(32, 32, FlxColor.CYAN);
		nape_player.createCircularBody(10);
		nape_player.visible = false;
		add(nape_player);
		
		create_nape_walls();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		nape_player.reset(player.x + 16, player.y + 16); //player sprite is 32x32 and we need this nape collider to be in the center
	}
	
}