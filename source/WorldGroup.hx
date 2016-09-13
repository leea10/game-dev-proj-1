package;
import flixel.group.FlxGroup;

// All the entities in a world.
class WorldGroup extends FlxGroup
{
	public var walls:FlxTypedGroup<Wall>;
	
	public function new() 
	{
		super();
		walls = new FlxTypedGroup<Wall>();
		add(walls);
	}
	
	public function addWall(x:Int, y:Int, width:Int, height:Int) 
	{
		walls.add(new Wall(x, y, width, height));
	}
}