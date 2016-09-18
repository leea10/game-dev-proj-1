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
	public var pits:FlxTypedGroup<Pit>;
	
	public var worldname:String;
	var filter:InteractionFilter;
	
	public function new(filt:InteractionFilter, world:String) 
	{
		super();
		filter = filt;
		worldname = world;
		
		// Groups made for easy collision checks.
		pressurePlates = new FlxTypedGroup<PressurePlate>();
		pits = new FlxTypedGroup<Pit>();
		// TODO(ariel): Add trapdoors here too.
		
		add(pressurePlates);
		add(pits);
	}
	
	public function addPlate(x:Int, y:Int, width:Int, height:Int)
	{
		var p:PressurePlate = new PressurePlate(x, y, width, height);
		pressurePlates.add(p);
	}
	
	public function addPit(x:Int, y:Int, width:Int, height:Int, playstate:PlayState)
	{
		var p:Pit = new Pit(x, y, width, height, this, playstate);
		pits.add(p);
		p.initialize();
	}
}