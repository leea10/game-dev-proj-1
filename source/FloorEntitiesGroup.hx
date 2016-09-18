package;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

class FloorEntitiesGroup extends FlxGroup
{
	public var pressurePlates:FlxTypedGroup<PressurePlate>;
	var worldname:String;
	
	var filter:InteractionFilter;
	
	public function new(filt:InteractionFilter, world:String) 
	{
		super();
		filter = filt;
		worldname = world;
		
		// Groups made for easy collision checks.
		pressurePlates = new FlxTypedGroup<PressurePlate>();
		// TODO(ariel): Add trapdoors here too.
	}
	
	public function addPlate(x:Int, y:Int, width:Int, height:Int)
	{
		var p:PressurePlate = new PressurePlate(x, y, width, height);
		pressurePlates.add(p);
		add(p);
	}
}