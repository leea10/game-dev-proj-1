package;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import nape.phys.BodyType;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;

// All the entities in a world.
class WorldGroup extends FlxGroup
{
	public var walls:FlxTypedGroup<FlxNapeSprite>;
	public var laseremitters:FlxTypedGroup<FlxSprite>;
	public var lights:FlxTypedGroup<Light>;
	public var boxes:FlxTypedGroup<Box>;
	public var mirrors:FlxTypedGroup<Mirror>;
	public var switches:FlxTypedGroup<Switch>;
	public var doors:FlxTypedGroup<Door>;
	public var worldname:String;
	
	var filter:InteractionFilter;
	
	public function new(filt:InteractionFilter, world:String) 
	{
		super();
		filter = filt;
		worldname = world;
		
		// Groups made for easy collision checks.
		walls = new FlxTypedGroup<FlxNapeSprite>();
		laseremitters = new FlxTypedGroup<FlxSprite>();
		lights = new FlxTypedGroup<Light>();
		boxes = new FlxTypedGroup<Box>();
		mirrors = new FlxTypedGroup<Mirror>();
		switches = new FlxTypedGroup<Switch>();
		doors = new FlxTypedGroup<Door>();
		
		add(mirrors);
        add(walls);
        add(lights);
        add(boxes);
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
	public function addWall(x:Int, y:Int, width:Int, height:Int):Wall
	{
		var w:Wall = new Wall(x, y, width, height);
		walls.add(w);
		w.set_filter(filter);
		return w;
	}
	
	public function addLaser(x:Int, y:Int, rot:Float, playstate:PlayState, flip:WorldGroup):LaserEmitter
	{
		var base:FlxNapeSprite = new FlxNapeSprite(x, y);
		base.loadGraphic("assets/images/dark_laser_base.png");
		base.createRectangularBody();
		walls.add(base);
		
		var l:LaserEmitter = new LaserEmitter(x, y, playstate, this);
		l.angle = rot;
		laseremitters.add(l);
		add(l);
		l.initialize();

		base.reset(base.x + l.width / 2, base.y + l.height / 2);
		base.body.type = BodyType.STATIC;
		
		return l;
	}
	
	public function addLight(x:Int, y:Int, playstate:PlayState):Light
	{
		var l:Light = new Light(x, y, playstate, this);
		lights.add(l);
		add(l);
		l.initialize();
		return l;
	}
	
	public function addBox(tilesheetPath:String, frame:Int, x:Int, y:Int, width:Int, height:Int):Box
	{
		var b:Box = new Box(tilesheetPath, frame, x, y, width, height);
		boxes.add(b);
		add(b);
		b.set_filter(filter);
		return b;
	}

	public function addDoor(x:Int, y:Int, width:Int, height:Int):Door
	{
		var d:Door = new Door(x, y, width, height);
		doors.add(d);
		add(d);
		d.setFilter(filter);
		return d;
	}	
	
	public function addSwitch(x:Int, y:Int, width:Int, height:Int):Switch
	{
		var s:Switch = new Switch(x, y, width, height);
		switches.add(s);
		add(s);
		s.setFilter(filter);
		return s;
	}
}