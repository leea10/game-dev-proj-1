package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class PressurePlate extends FlxSprite implements Trigger 
{
	public var _receiver:Receiver;
	private var _on:Bool;
	
	var floorgroup:FloorEntitiesGroup;
	public var in_dark_world:Bool = false;
	public var in_light_world:Bool = false;
	
	var state:PlayState;
	
	public function new(x:Int, y:Int, width:Int, height:Int, group:FloorEntitiesGroup, playstate:PlayState, ?receiver:Receiver = null)
	{
		super(x, y);
		state = playstate;
		floorgroup = group;
		
		if (floorgroup.worldname == "both"){
			loadGraphic("assets/images/para pressure plate off.png");
		}
		else {
			loadGraphic("assets/images/pressure plate off.png");
		}
		_receiver = receiver;
		
		immovable = true;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		var should_trigger:Bool = false;
		// if we're in the light world, things that are ONLY in the light world should fall in
		if (in_light_world){
			for (box in state._lightWorld.boxes){
				if (FlxG.overlap(this, box)){
					should_trigger = true;
				}
			}
		}
		if (in_dark_world){
			for (box in state._darkWorld.boxes){
				if (FlxG.overlap(this, box)){
					should_trigger = true;
				}
			}
		}
		for (box in state._bothWorlds.boxes){
			if (FlxG.overlap(this, box)){
				should_trigger = true;
			}
		}
		
		if (should_trigger && !_on){
			trigger();
		}
		else if (!should_trigger && _on){
			release();
		}
	}
	
	public function initialize():Void
	{
		get_worlds();
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
	
	public function trigger() 
	{
		if (!_on) {
			state.sound_man.plate_on.play();
			_on = true;
			if (floorgroup.worldname == "both"){
				loadGraphic("assets/images/para pressure plate on.png");
			}
			else {
				loadGraphic("assets/images/pressure plate on.png");
			}
			
			if (_receiver != null) 
			{
				_receiver.activate();
			}
		}
	}
	
	public function release() 
	{
		if (_on) {
			state.sound_man.plate_off.play();
			_on = false;
			if (floorgroup.worldname == "both"){
				loadGraphic("assets/images/para pressure plate off.png");
			}
			else {
				loadGraphic("assets/images/pressure plate off.png");
			}
			
			if (_receiver != null) 
			{
				_receiver.deactivate();
			}
		}
	}
}