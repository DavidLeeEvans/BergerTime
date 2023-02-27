package entities;

// if (self.faceDir != 2) {
// 	Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_back});
// 	self.faceDir = 2;
// -1 = NONE
//  0 = North
//  1 = East
//  2 = South
//  3 = West
class ChefController {
	var _delay:Float;
	var _prim_state:Int;
	var _sec_state:Int;
	var _reg0:Float;

	public function input_dir(d:Int):Void {}

	public function trigger(t:Int):Void {}

	public function reset_state():Void {
		_prim_state = -1;
		_sec_state = -1;
		_reg0 = 0;
	}

	public function new(d:Float) {
		reset_state();
		set_delay(d);
	}

	public function set_delay(d:Float):Void {
		if (d > 0)
			_delay = d;
	}

	public function get_delay():Float {
		return _delay;
	}

	public function update(delta:Float):Void {
		_reg0 += delta;
		if (_reg0 > _delay) {
			_reg0 = 0;
			_prim_state = -1;
			_sec_state = -1;
		}
	}

	public function get_state():Int {
		var s:Int = 0;
		// TODO
		return s;
	}
}
