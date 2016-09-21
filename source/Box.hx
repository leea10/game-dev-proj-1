package;

import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

class Box extends FlxNapeSprite
{
	public var origin_x:Float;
	public var origin_y:Float;
	
	var animating:Bool = false;
	
	var state:PlayState;
	
	public function new(x_in:Int, y_in:Int, width:Int, height:Int, groupname:String, playstate:PlayState) 
	{
		origin_x = x_in + (width / 2);
		origin_y = y_in + (height / 2) + (64 - height);
		
		super(origin_x, origin_y);
		state = playstate;
		
		if (groupname == "dark") {
			loadGraphic("assets/images/dark_crate.png");
		}
		if (groupname == "light") {
			loadGraphic("assets/images/light_crate.png");
		}
		if (groupname == "both") {
			loadGraphic("assets/images/paracrate.png");
		}
		
		createRectangularBody();
		body.type = BodyType.DYNAMIC;
		
		setBodyMaterial(0, 0, 0, 10);
		setDrag(0.5, 0.5);
		
		body.allowMovement = true;
		body.allowRotation = false;
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (animating) {
			if (animation.finished) {
				state.mirror.body.position = body.position;
				reset(0, 0);
				state.sound_man.mirror.play();
				
				animating = false;
			}
		}
	}
	
	public function set_filter (filter:InteractionFilter):Void
	{
		body.shapes.at(0).filter = filter;
	}
	
	public function deactivate ():Void
	{
		set_physicsEnabled(false);
	}
	
	public function break_animation ():Void
	{
		// this takes 1.2 seconds
		loadGraphic("assets/images/CrateBreakSpiteSheet.png", true, 64, 64);
		animation.add("break", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23], 5, false);
		animation.play("break");
		
		animating = true;
	}
}