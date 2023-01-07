package ecs.c;

import defold.types.Hash;

class StatisticsComponent {
	public var id:Hash;
	public var changeFlag:Bool = false;

	public function new(_id):Void {
		this.id = _id;
	}
}
