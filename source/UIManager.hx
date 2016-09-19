package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class UIManager extends FlxGroup
{
	public var switch_prompt:FlxSprite;
	public var drag_prompt:FlxSprite;
	public var rotate_prompt:FlxSprite;
	public var jump_prompt:FlxSprite;
	
	public var dist:Float = 50;

	public function new()
	{
		super();
		
		switch_prompt = new FlxSprite(1060,525);
		drag_prompt = new FlxSprite(1060,575);
		rotate_prompt = new FlxSprite(1060,625);
		jump_prompt = new FlxSprite(1060,675);
		
		switch_prompt.scrollFactor.set(0, 0);
		drag_prompt.scrollFactor.set(0, 0);
		rotate_prompt.scrollFactor.set(0, 0);
		jump_prompt.scrollFactor.set(0, 0);
		
		switch_prompt.loadGraphic("assets/images/ui/flip switch.png");
		drag_prompt.loadGraphic("assets/images/ui/push pull.png");
		rotate_prompt.loadGraphic("assets/images/ui/rotate.png");
		jump_prompt.loadGraphic("assets/images/ui/jump through.png");
		
		add(switch_prompt);
		add(drag_prompt);
		add(rotate_prompt);
		add(jump_prompt);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		var draw_x:Float = 1060;
		var draw_y:Float = 675;
		
		if (switch_prompt.visible){
			switch_prompt.x = draw_x;
			switch_prompt.y = draw_y;
			draw_y -= dist;
		}
		
		if (drag_prompt.visible){
			drag_prompt.x = draw_x;
			drag_prompt.y = draw_y;
			draw_y -= dist;
		}
		
		if (rotate_prompt.visible){
			rotate_prompt.x = draw_x;
			rotate_prompt.y = draw_y;
			draw_y -= dist;
		}
		
		if (jump_prompt.visible){
			jump_prompt.x = draw_x;
			jump_prompt.y = draw_y;
			draw_y -= dist;
		}
	}

}