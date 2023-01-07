package entities;

import defold.types.Vector3;

import defold.Go;
import defold.Physics;

import defold.types.Message;
import defold.types.Url;

import defold.support.Script;

import defold.Timer;

import defold.Vmath.vector3;

import Defold.hash;


@:build(defold.support.MessageBuilder.build())
class PepperMessage {
	var flight_path:{flight_direction:Vector3};
}

typedef PepperData = {
	var direction:Vector3;
	var speed:Float;
	// @property("none") var color:Hash;
}

class PepperEntity extends Script<PepperData> {
	override function init(self:PepperData) {
		self.speed = 0.61; // Y3K FOR TESING ONLY
		self.direction = vector3(0, 0, 0);
		Timer.delay(6.1, false, timer_callback);
	}

	override function update(self:PepperData, dt:Float):Void {
		var p = Go.get(".", "position");
		// Go.set(".", "position", p + self.direction * vector3(self.speed * dt, self.speed * dt, 0));
		Go.set(".", "position", p + self.direction);
	}

	override function on_message<T>(self:PepperData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case PepperMessage.flight_path: 
				self.direction = message.flight_direction;
			case PhysicsMessages.trigger_response:
				if (message.own_group == hash('enemy')) {
					// self.speed = 0;
					
				}
		}
	}

	override function final_(self:PepperData):Void {}

	override function on_reload(self:PepperData):Void {}

	function timer_callback(_, _, _):Void {
		trace("Pepper Timer called");
		// if not already deleted, then delete?
		Go.delete();
	}
}
