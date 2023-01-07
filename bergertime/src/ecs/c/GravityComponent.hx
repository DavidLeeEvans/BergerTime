package ecs.c;

import defold.types.Vector3;
import defold.types.Hash;

class GravityComponent {
	public var id:Hash;
	public var gravity:Vector3;
	public var notOnGround:Bool;
	public var changeFlag:Bool = false;

	public function new(_id, _gravity):Void {
		this.id = _id;
		this.gravity = _gravity;
		this.notOnGround = true;
	}
}
