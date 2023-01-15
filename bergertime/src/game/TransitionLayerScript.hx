package game;

//
import Defold.hash;

import defold.Go;

import defold.Physics.PhysicsMessages;
import defold.Physics.PhysicsMessages;

import defold.Physics;
import defold.Vmath;

import defold.support.Script;

import defold.types.Message;
import defold.types.Url;

// Testing

typedef TransitionLayerData = {}

class TransitionLayerScript extends Script<TransitionLayerData> {
	override function on_reload(self:TransitionLayerData) {
		super.on_reload(self);
	}

	//
	override function init(self:TransitionLayerData) {}

	override function update(self:TransitionLayerData, dt:Float) {
		// Testing
		// var p = Go.get("/topbun_full", "position") + Vmath.vector3(0, -0.61, 0);

		//	Go.set("/topbun_full", "position", p);
	}

	override function on_message<TMessage>(self:TransitionLayerData, message_id:Message<TMessage>, message:TMessage, sender:Url) {
		// switch (message_id){
		// 	PhysicsMessages.collision_response:
		// 	trace('Collision Happened Transition Layer');

		// }
	}

	private function bouncing() {
		// TODO Finish testing this Y3K like???
	}

	private function falling() {
		// TODO Finish testing this Y3K like?? ?
	}
}
