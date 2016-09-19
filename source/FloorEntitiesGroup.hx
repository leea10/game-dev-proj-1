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
		
		add(pressurePlates);
		add(pits);
	}
	
	public function addPlate(x:Int, y:Int, width:Int, height:Int, playstate:PlayState):PressurePlate
	{
		var p:PressurePlate = new PressurePlate(x, y, width, height, this, playstate);
		pressurePlates.add(p);
		p.initialize();
		return p;
	}
	
	public function addPit(x:Int, y:Int, width:Int, height:Int, playstate:PlayState):Pit
	{
		var p:Pit = new Pit(x, y, width, height, this, playstate);
		pits.add(p);
		p.initialize();
		return p;
	}
	
	public function addEnd(x:Int, y:Int, width:Int, height:Int, playstate:PlayState):LevelEnd
	{
		var e:LevelEnd = new LevelEnd(x, y, width, height, playstate);
		add(e);
		return e;
	}
}