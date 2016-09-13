package;
import flixel.group.FlxGroup;

// All the entities in a world.
class WorldGroup extends FlxGroup
{
	private var _walls:FlxTypedGroup<Wall>;
	
	public function new() 
	{
		super();
		_walls = new FlxTypedGroup<Wall>();
		add(_walls);
	}
	
	public function addWall(x:Int, y:Int, width:Int, height:Int) 
	{
		_walls.add(new Wall(x, y, width, height));
	}
}