package entities;

import Defold.hash;

import defold.Go;
import defold.Physics;
import defold.Timer;
import defold.Vmath;

import defold.support.Script;

import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;

@:build(defold.support.MessageBuilder.build())
private typedef PepperData = {
	@property var direction:Vector3;
}

class PepperEntity extends Script<PepperData> {
	override function init(self:PepperData) {
		lua.Lua.assert(self.direction != null, "Pepper Direction Not Set!!");
		Timer.delay(6.1, false, timer_callback);
	}

	override function update(self:PepperData, dt:Float):Void {
		Defold.pprint(Go.get_position());
		var p = Go.get_world_position();
		Go.set_position(p + self.direction);
	}

	override function on_message<T>(self:PepperData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case PhysicsMessages.trigger_response:
				if (message.own_group == hash('enemy')) {
					self.direction = Vmath.vector3(0, 0, 0);
				}
		}
	}

	override function final_(self:PepperData):Void {}

	override function on_reload(self:PepperData):Void {}

	function timer_callback(_, _, _):Void {
		trace("Pepper Timer called");
		Go.delete();
	}
}
