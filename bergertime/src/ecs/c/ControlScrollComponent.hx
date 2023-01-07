package ecs.c;

import defold.types.Vector3;

// import defold.types.Hash;
class ControlScrollComponent {
	public var id:String;
	public var rate:Float;
	public var direction:Vector3;
	public var isEnabled:Bool;

	public function new(_id, _rate, _direction, _isEnable) {
		this.id = _id;
		this.rate = _rate;
		this.direction = _direction;
		this.isEnabled = _isEnable;
	}
}
