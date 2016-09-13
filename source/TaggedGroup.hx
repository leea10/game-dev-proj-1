package;

import flixel.group.FlxGroup;
import flixel.FlxObject;

/**
 * A group of entities with (optional) corresponding tags for easy access.
 * This is just a FlxGroup with an added index.
 * @author Ariel Lee
 */
class TaggedGroup extends FlxGroup
{
	// A map of tag -> FlxObject reference.
	private var _entityMap:Map<String, FlxObject>;
	
	public function new() 
	{
		super();
		_entityMap = new Map<String, FlxObject>();
	}
	
	// Adds a new tagged entity to the group. Replaces existing.
	// (Boooooo Haxe doesn't support method overloading)
	public function addTag(tag:String, entity:FlxObject):Void
	{
		_entityMap.set(tag, entity);
		add(entity);
	}
	
	// Returns a reference to the FlxObject with the given tag.
	public function get(tag:String):FlxObject
	{
		return _entityMap.get(tag);
	}	
}