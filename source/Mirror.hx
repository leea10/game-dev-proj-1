package;

import flixel.FlxSprite;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

class Mirror extends FlxNapeSprite
{
	public var origin_x:Float;
	public var origin_y:Float;
	
	public var swivel_top:FlxNapeSprite;
	
	public function new(x_in:Int, y_in:Int)
	{
		super(x_in, y_in);
		
		makeGraphic(64, 64, FlxColor.WHITE);
		createRectangularBody();
		body.type = BodyType.DYNAMIC;
		
		setBodyMaterial(0, 0, 0, 10);
		setDrag(0.5, 0.5);
		
		body.allowMovement = true;
		body.allowRotation = false;
		
		// add the actual swiveling mirror part
		swivel_top = new FlxNapeSprite(x+width/2, y+height/2);
		swivel_top.makeGraphic(55, 10, FlxColor.BLACK);
		swivel_top.createRectangularBody();
		swivel_top.body.type = BodyType.DYNAMIC;
		swivel_top.body.allowMovement = false;
		swivel_top.body.allowRotation = true;
		
		// we don't want this to collide with anything
		/// ...1000, ...0000
		var no_filter:InteractionFilter = new InteractionFilter(8, 0);
		swivel_top.body.shapes.at(0).filter = no_filter;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		swivel_top.reset(x+width/2,y+height/2);
		swivel_top.body.rotation += 0.02;
	}
	
	public function set_filter (filter:InteractionFilter)
	{
		body.shapes.at(0).filter = filter;
	}
	
	
}