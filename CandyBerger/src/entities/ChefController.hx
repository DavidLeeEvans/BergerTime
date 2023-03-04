package entities;

import defold.Msg;

import hud.GHud.GHudMessage;

// if (self.faceDir != 2) {
// 	Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_back});
// 	self.faceDir = 2;
// -1 = NONE
//  0 = North
//  1 = East
//  2 = South
//  3 = West
///
//  4 = North-West
//  5 = North-East
//  6 = South-West
//  7 = South-East
//  8 = UNKNOWN
class ChefController {
	var _delay:Float;
	private var _prim_state:Int;
	private var _sec_state:Int;
	private var _final_state:Int;
	private var _reg0:Float;
	private var _ps:Bool;

	public function input_dir(d:Int):Void {
		if (_ps) {
			_prim_state = d;
			_ps = false;
		} else {
			_sec_state = d;
			finished();
		}
	}

	public function start():Void {
		_final_state = 8;
	}

	private function trigger(t:Int):Void {}

	public function finished():Void {
		if (_prim_state == 0 && _sec_state == 0) //
			_final_state = 0;
		else if (_prim_state == 0 && _sec_state == -1)
			_final_state = -1;
		else if (_prim_state == 0 && _sec_state == 1)
			_final_state = 5;
		else if (_prim_state == 0 && _sec_state == 2)
			_final_state = 2;
		else if (_prim_state == 0 && _sec_state == 3)
			_final_state = 4;
		else if (_prim_state == 0 && _sec_state == 8)
			_final_state = 0;
		else if (_prim_state == 1 && _sec_state == 0) //
			_final_state = 1; // TODO EN
		else if (_prim_state == 1 && _sec_state == -1)
			_final_state = -1;
		else if (_prim_state == 1 && _sec_state == 1)
			_final_state = 1;
		else if (_prim_state == 1 && _sec_state == 2)
			_final_state = 1; // TODO ES
		else if (_prim_state == 1 && _sec_state == 3)
			_final_state = 3;
		else if (_prim_state == 1 && _sec_state == 8)
			_final_state = 1;
		else if (_prim_state == 2 && _sec_state == 0) //
			_final_state = 0;
		else if (_prim_state == 2 && _sec_state == -1)
			_final_state = -1;
		else if (_prim_state == 2 && _sec_state == 1)
			_final_state = 7; // SE
		else if (_prim_state == 2 && _sec_state == 2)
			_final_state = 2;
		else if (_prim_state == 2 && _sec_state == 3)
			_final_state = 6; // SW
		else if (_prim_state == 2 && _sec_state == 8)
			_final_state = 2;
		else if (_prim_state == 3 && _sec_state == 0) //
			_final_state = 3; // TODO WN
		else if (_prim_state == 3 && _sec_state == -1)
			_final_state = -1;
		else if (_prim_state == 3 && _sec_state == 1)
			_final_state = 1;
		else if (_prim_state == 3 && _sec_state == 2)
			_final_state = 3; // WS
		else if (_prim_state == 3 && _sec_state == 3)
			_final_state = 3;
		else if (_prim_state == 3 && _sec_state == 8)
			_final_state = 3;
		else if (_prim_state == -1 && _sec_state == 0) //
			_final_state = 0; // TODO WN
		else if (_prim_state == -1 && _sec_state == -1)
			_final_state = -1;
		else if (_prim_state == -1 && _sec_state == 1)
			_final_state = 1;
		else if (_prim_state == -1 && _sec_state == 2)
			_final_state = 2; // WS
		else if (_prim_state == -1 && _sec_state == 3)
			_final_state = 3;
		else if (_prim_state == -1 && _sec_state == 8)
			_final_state = -1;

		switch (get_final_state()) { // TODO Doc Touch Input
			case -1:
				Msg.post("/go#ghud", GHudMessage.idle);
				Msg.post("/chef", GHudMessage.idle);
			case 0:
				Msg.post("/go#ghud", GHudMessage.sup);
				Msg.post("/chef", GHudMessage.sup);
			case 1:
				Msg.post("/go#ghud", GHudMessage.sright);
				Msg.post("/chef", GHudMessage.sright);
			case 2:
				Msg.post("/go#ghud", GHudMessage.sdown);
				Msg.post("/chef", GHudMessage.sdown);
			case 3:
				Msg.post("/go#ghud", GHudMessage.sleft);
				Msg.post("/chef", GHudMessage.sleft);
			case 4:
				Msg.post("/go#ghud", GHudMessage.sup_left);
				Msg.post("/chef", GHudMessage.sup_left);
			case 5:
				Msg.post("/go#ghud", GHudMessage.sup_right);
				Msg.post("/chef", GHudMessage.sup_right);
			case 6:
				Msg.post("/go#ghud", GHudMessage.sdown_left);
				Msg.post("/chef", GHudMessage.sdown_left);
			case 7:
				Msg.post("/go#ghud", GHudMessage.sdown_right);
				Msg.post("/chef", GHudMessage.sdown_right);

			case 8:
				trace("UNKNOWN STATE");
		}

		print_string();
		_ps = true;
		_prim_state = 8;
		_sec_state = 8;
		_reg0 = 0;
	}

	public function new(d:Float) {
		finished();
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
			//			trace("----------------------------ChefController Triggered-------------------------");
			finished();
			_reg0 = 0;
			_prim_state = 8;
			_sec_state = 8;
			// _prim_state = 8;
		}
	}

	public function get_final_state():Int {
		return _final_state;
	}

	private function print_string() {
		Defold.pprint(' prime state ${_prim_state}, sec state${_sec_state}');
		Defold.pprint('final state ${get_final_state()}');
	}
}
