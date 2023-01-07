package ecs.c;

import defold.types.Hash;

enum ChefComponentState {
	spawn;
	walk;
	salted;
	die;
	falling;
}

class BehaviorChefComponent {
	public var timer:Float;
	public var changeFlag:Bool = false;
	public var id:Hash;
	public var componentState:ChefComponentState;

	public function new(_id) {
		this.id = _id;
	}
}
