package ecs.c;

import defold.types.Url;

enum abstract CompassDir(Int) {
	var N = 0;
	var NE = 1;
	var E = 2;
	var SE = 3;
	var S = 4;
	var SW = 5;
	var W = 6;
	var NW = 7;
}

class MovementComponent {
	public var id:Url;
	public var game_object:String;
	public var compass:Int;
	public var switch_delay:Float;
	public var switch_delay_trigger:Float;
	public var current_dir:Int;

	public function new(_id:Url, _game_object:String, _compass:Int, _switch_delay:Float, _switch_delay_trigger:Float, _current_dir:Int) {
		this.id = _id;
		this.game_object = _game_object;
		this.compass = _compass;
		this.switch_delay = _switch_delay;
		this.switch_delay_trigger = _switch_delay_trigger;
		this.current_dir = _current_dir;
	}

	public function on_touch(action:Int):Void {
		trace('Movement_component $action');
	}
}
