package ecs.c;

import defold.types.Hash;

enum TreatComponentState {
	spawn;
	capture;
	disappearing;
	anim0;
	anim1;
}

class BehaviorTreatComponent {
	public var timer:Float;
	public var changeFlag:Bool = false;
	public var id:Hash;
	public var componentState:TreatComponentState;

	public function new(_id) {
		this.id = _id;
	}
}
