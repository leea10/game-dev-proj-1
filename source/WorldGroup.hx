package;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.addons.nape.FlxNapeSprite;

// All the entities in a world.
class WorldGroup extends FlxGroup
{
	public var walls:FlxTypedGroup<Wall>;
	public var lasers:FlxTypedGroup<LaserEmitter>;
	public var lights:FlxTypedGroup<Light>;
	public var boxes:FlxTypedGroup<Box>;
	
	public function new() 
	{
		super();
		
		// Groups made for easy collision checks.
		walls = new FlxTypedGroup<Wall>();
		lasers = new FlxTypedGroup<LaserEmitter>();
		lights = new FlxTypedGroup<Light>();
		boxes = new FlxTypedGroup<Box>();
		
		add(walls);
		add(lasers);
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
	public function addWall(x:Int, y:Int, width:Int, height:Int) 
	{
		walls.add(new Wall(x, y, width, height));
	}
	
	public function addLaser(x:Int, y:Int, playstate:PlayState)
	{
		var l:LaserEmitter = new LaserEmitter(x, y, playstate, this);
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
	}
}
