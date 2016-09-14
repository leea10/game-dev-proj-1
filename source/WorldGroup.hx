package;
import flixel.group.FlxGroup;
import flixel.addons.nape.FlxNapeSprite;

// All the entities in a world.
class WorldGroup extends FlxGroup
{
	public var walls:FlxTypedGroup<Wall>;
	public var lasers:FlxTypedGroup<LaserEmitter>;
	public var lights:FlxTypedGroup<Light>;
	
	public function new() 
	{
		super();
		walls = new FlxTypedGroup<Wall>();
		lasers = new FlxTypedGroup<LaserEmitter>();
		lights = new FlxTypedGroup<Light>();
		
		add(walls);
		add(lasers);
		add(lights);
	}
	
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
}
