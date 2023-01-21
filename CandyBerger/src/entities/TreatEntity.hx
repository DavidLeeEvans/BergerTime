package entities;

import lua.lib.luasocket.socket.SelectResult;

import defold.Timer;
import defold.Go;
import defold.Physics;

import Defold.hash;

import defold.types.Message;
import defold.types.Url;

import defold.support.Script;


@:build(defold.support.MessageBuilder.build())
class TreatType {
	var set_treat:{type:Int};
}

typedef TreatData = {
	var treat_type:Int;
}

class TreatEntity extends Script<TreatData> {
	override function init(self:TreatData) {
		Timer.delay(11.0, false, timer_callback);
	}

	override function update(self:TreatData, dt:Float):Void {}

	override function on_message<T>(self:TreatData, message_id:Message<T>, message:T, _):Void {
		switch (message_id) {
			case TreatType.set_treat:
				self.treat_type = message.type;
			case PhysicsMessages.trigger_response:
				if (message.other_group == hash("chef")) {
					Go.delete();
				}
		}
	}

	override function final_(self:TreatData):Void {}

	override function on_reload(self:TreatData):Void {}

	public function get_type(self:TreatData):Int {
		return self.treat_type;
	}

	function timer_callback(_, _, _):Void {
		trace("Timer called");
		Go.delete();
	}
}
