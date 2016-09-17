package;
import nape.dynamics.InteractionFilter;


/**
 * Global static constants for interaction filters.
 */
class CollisionFilter 
{
	private static var light_collision_group:Int = 1; /// .....0001
	private static var dark_collision_group:Int = 2;  /// .....0010
	private static var both_collision_group:Int = 4;  /// .....0100

	private static var light_collision_mask:Int = 5;  /// .....0101 -- collide with stuff in the light world and in both worlds
	private static var dark_collision_mask:Int = 6;   /// .....0110 -- collide with stuff in the dark world and in both worlds
	private static var both_collision_mask:Int = 7;   /// .....0111 -- collide with everything

	public static var LIGHT = new InteractionFilter(light_collision_group, light_collision_mask);
	public static var DARK = new InteractionFilter(dark_collision_group, dark_collision_mask);
	public static var BOTH = new InteractionFilter(both_collision_group, both_collision_mask);
	
	// To make sure no one tries to instantiate this.
	private function new() {}
}