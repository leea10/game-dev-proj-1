package;
import flixel.group.FlxGroup;
import flixel.addons.nape.FlxNapeSprite;

// All the entities in a world.
class WorldGroup extends FlxGroup
{
	public var walls:FlxTypedGroup<Wall>;
	public var lasers:FlxTypedGroup<LaserEmitter>;
	
	public function new() 
	{
		super();
		walls = new FlxTypedGroup<Wall>();
		lasers = new FlxTypedGroup<LaserEmitter>();
		add(walls);
		add(lasers);
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
}
