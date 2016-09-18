package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class Pit extends FlxSprite
{
	var floorgroup:FloorEntitiesGroup;
	public var in_dark_world:Bool = false;
	public var in_light_world:Bool = false;
	
	var state:PlayState;
	
	public function new(x:Int, y:Int, width:Int, height:Int, group:FloorEntitiesGroup, playstate:PlayState)
	{
		super(x, y);
		floorgroup = group;
		state = playstate;
		
		makeGraphic(width, height, FlxColor.BLACK);
		
		immovable = true;
	}
		
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// if we're in the light world, things that are ONLY in the light world should fall in
		if (in_light_world){
			for (box in state._lightWorld.boxes){
				if (FlxG.overlap(this, box)){
					if (overlap_inside(box, this)){
						box.deactivate();
						fall(box);
						state.waitAndRestart(1500);
					}
				}
			}
		}
		// if we're in the dark world, things that are ONLY in the light world should fall in
		if (in_dark_world){
			for (box in state._darkWorld.boxes){
				if (FlxG.overlap(this, box)){
					if (overlap_inside(box, this)){
						box.deactivate();
						fall(box);
						state.waitAndRestart(1500);
					}
				}
			}
		}
		// if we're in both, things in both should also fall in
		if (in_light_world && in_dark_world){
			for (box in state._bothWorlds.boxes){
				if (FlxG.overlap(this, box)){
					if (overlap_inside(box, this)){
						box.deactivate();
						fall(box);
						state.waitAndRestart(1500);
					}
				}
			}
			
			if (FlxG.overlap(this, state.mirror)){
				if (overlap_inside(state.mirror, this)){
					state.mirror.deactivate();
					fall(state.mirror);
					fall(state.mirror.swivel_top);
					state.waitAndRestart(1500);
				}
			}
		}
		
		//also the player should fall in if we're in the same world as it
		if ((in_light_world && !state._isDark) || (in_dark_world && state._isDark)){
			if (FlxG.overlap(this, state.player)){
				if (overlap_inside(state.player, this)){
					state.player.die();
					fall(state.player);
				}
			}
		}
		
	}
	
	public function initialize():Void
	{
		get_worlds();
	}
	
	// is a sprite entirely inside another? there's a little fudging here so things will fall in if they're ALMOST all the way inside (fixes some issues with float comparisons)
	public function overlap_inside(in_object:FlxSprite, out_object:FlxSprite):Bool
	{
		var inside:Bool = true;
		
		if (in_object.x+1 < out_object.x){
			inside = false;
		}
		if (in_object.y+1 < out_object.y){
			inside = false;
		}
		if (in_object.x+in_object.width > out_object.x+out_object.width+1){
			inside = false;
		}
		if (in_object.y+in_object.height > out_object.y+out_object.height+1){
			inside = false;
		}
		
		return inside;
	}
	
	function get_worlds():Void
	{
		if (floorgroup.worldname == "light"){
			in_light_world = true;
		}
		else if (floorgroup.worldname == "dark"){
			in_dark_world = true;
		}
		else{
			in_light_world = true;
			in_dark_world = true;
		}
	}
	
	function fall(faller:FlxSprite):Void
	{		
		FlxTween.tween(faller.scale, { x: 0, y: 0 }, .8, { type: FlxTween.ONESHOT } );
		//FlxTween.color(faller, 1, FlxColor.WHITE, FlxColor.TRANSPARENT, { type: FlxTween.ONESHOT } );
	}
}