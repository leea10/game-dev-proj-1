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
	
	public function new(x_in:Int, y_in:Int, width:Int, height:Int, groupname:String) 
	{
		origin_x = x_in + (width / 2);
		origin_y = y_in + (height / 2) + (64 - height);
		
		super(origin_x, origin_y);
		
		
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
	}
	
	public function set_filter (filter:InteractionFilter):Void
	{
		body.shapes.at(0).filter = filter;
	}
	
	public function deactivate ():Void
	{
		set_physicsEnabled(false);
	}
}