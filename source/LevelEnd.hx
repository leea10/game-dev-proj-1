package;

import flixel.FlxG;
import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

class LevelEnd extends FlxSprite
{
	var state:PlayState;
	
	public function new(x:Int, y:Int, width:Int, height:Int, playstate:PlayState) 
	{
		super(x, y);
		state = playstate;
		
		makeGraphic(width, height, FlxColor.TRANSPARENT);
		immovable = true;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// continue to the next level if the player and the mirror are both in this zone
		if (FlxG.overlap(this, state.player.hit_area)) {
		
			if (state.is_tutorial){
				if (FlxG.overlap(this, state.box)){
					state.waitAndNextLevel(1500);
				}
			}
			else {
				if (FlxG.overlap(this, state.mirror)){
					state.waitAndNextLevel(1500);
				}
			}
		}
	}

}