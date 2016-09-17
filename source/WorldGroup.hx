package;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

// All the entities in a world.
class WorldGroup extends FlxGroup
{
	public var walls:FlxTypedGroup<Wall>;
	public var lasers:FlxTypedGroup<LaserEmitter>;
	public var lights:FlxTypedGroup<Light>;
	public var boxes:FlxTypedGroup<Box>;
	public var mirrors:FlxTypedGroup<FlxNapeSprite>;
	public var switches:FlxTypedGroup<Switch>;
	public var worldname:String;
	
	var filter:InteractionFilter;
	
	public function new(filt:InteractionFilter, world:String) 
	{
		super();
		filter = filt;
		worldname = world;
		
		// Groups made for easy collision checks.
		walls = new FlxTypedGroup<Wall>();
		lasers = new FlxTypedGroup<LaserEmitter>();
		lights = new FlxTypedGroup<Light>();
		boxes = new FlxTypedGroup<Box>();
		mirrors = new FlxTypedGroup<FlxNapeSprite>();
		switches = new FlxTypedGroup<Switch>();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		FlxG.collide(boxes); // boxes in this world collide with each other
		FlxG.collide(boxes, walls);
	}
	
	/**
	 * TODO(Ariel): This could get a little out of hand when we start adding
	 * more objects, but we can totally consolidate later if we have time / find it necessary
	 */
	public function addWall(x:Int, y:Int, width:Int, height:Int) 
	{
		var w:Wall = new Wall(x, y, width, height);
		walls.add(w);
		w.set_filter(filter);
	}
	
	public function addLaser(x:Int, y:Int, rot:Float, playstate:PlayState)
	{
		var l:LaserEmitter = new LaserEmitter(x, y, playstate, this);
		l.angle = rot;
		lasers.add(l);
		add(l);
		l.initialize();
	}
	
	public function addLight(x:Int, y:Int, playstate:PlayState)
	{
		var l:Light = new Light(x, y, playstate, this);
		lights.add(l);
		add(l);
		l.initialize();
	}
	
	public function addBox(tilesheetPath:String, frame:Int, x:Int, y:Int, width:Int, height:Int)
	{
		var b:Box = new Box(tilesheetPath, frame, x, y, width, height);
		boxes.add(b);
		add(b);
		b.set_filter(filter);
	}
	
	public function addSwitch(x:Int, y:Int, width:Int, height:Int)
	{
		var s:Switch = new Switch(x, y, width, height);
		switches.add(s);
		add(s);
		s.setFilter(filter);
	}
}