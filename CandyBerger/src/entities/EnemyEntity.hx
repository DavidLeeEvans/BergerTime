package entities;

import Defold.hash;

import defold.Go;
import defold.Label;
import defold.Msg;
import defold.Physics;

import defold.Sprite.SpriteMessages;

import defold.Timer;

import defold.Vmath.vector3;

import defold.Vmath;

import defold.support.Script;

import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;

import dex.util.Rand;

import entities.SWEN;

/**
	Candy Berger Game:
**/
@:build(defold.support.MessageBuilder.build())
class EnemyMessage {
	var msg_die; // Never really happens in the original game
	var msg_go_right;
	var msg_go_left;
	var msg_go_up;
	var msg_go_down;
	var msg_retract_chef_transponder;
}

@:build(defold.support.HashBuilder.build())
class EnemyEntityHash {
	var _debug;
	//
	var egg_dead;
	var egg_left;
	var egg_right;
	var egg_front;
	var egg_back;
	var egg_peppered;
	//
	var pickle_dead;
	var pickle_left;
	var pickle_right;
	var pickle_front;
	var pickle_back;
	var pickle_peppered;

	//
	var hotdog_dead;
	var hotdog_left;
	var hotdog_right;
	var hotdog_front;
	var hotdog_back;
	var hotdog_peppered;
}

private typedef Data = {
	// go.set("myobject#my_script", "my_property", val + 1)
	var _not_taking_off:Bool;
	var _border:Bool;
	var _debug:Bool;
	@property(true) var not_peppered:Bool;
	@property(true) var is_tracking:Bool;
	@property(-1) var type:Int; // egg-0, pickle-1, sausage-2
	var isMoving:Bool;
	var swenf:SWENF; //
	var tableFloor:lua.Table<Int, Hash>;
	var tableNorth:lua.Table<Int, Hash>;
	var tableEast:lua.Table<Int, Hash>;
	var tableSouth:lua.Table<Int, Hash>;
	var tableWest:lua.Table<Int, Hash>;
	var tableOnLadder:lua.Table<Int, Hash>;
	//
}

class Entity extends Script<Data> {
	var debug:Bool;
	var counter:Float;
	final MOVEMENT_SPEED = 6.0;
	final RCTABLE_FLOOR:Int = 1;
	final RCNORTH:Int = 2;
	final RCEAST:Int = 3;
	final RCSOUTH:Int = 4;
	final RCWEST:Int = 5;
	final RCONLADDER:Int = 6;
	//
	final hPlate:Hash = hash('fixture');
	final hladder:Hash = hash('ladder');
	final hFloor:Hash = hash('fixture');
	final hBorder:Hash = hash('border');

	//
	// Enemy Egg 0
	// Enemy Pickle 1
	// Enemy Sausage 2

	override function init(self:Data) {
		lua.Lua.assert(self.type != -1, "Enemy Type Not Set");
		self._not_taking_off = false;
		self._border = true;
		//
		self._debug = defold.Sys.get_engine_info().is_debug;
		self.swenf = new SWENF();
		set_animation_front(self);
		self.swenf.f = false;
		self.swenf.n = false;
		self.swenf.e = false;
		self.swenf.s = false;
		self.swenf.i = false;
		self.swenf.w = false;
		self.isMoving = true;
		if (Rand.bool())
			Msg.post("#", EnemyMessage.msg_go_left);
		else
			Msg.post("#", EnemyMessage.msg_go_right);

		counter = 0.0;
		self.tableFloor = lua.Table.create();
		self.tableNorth = lua.Table.create();
		self.tableEast = lua.Table.create();
		self.tableSouth = lua.Table.create();
		self.tableWest = lua.Table.create();

		lua.Table.insert(self.tableFloor, hFloor);
	}

	override function update(self:Data, dt:Float):Void {
		counter = counter + 1.0;
		if (counter > 30.0) {
			if (self.swenf.e) {
				Label.set_text("#debug", "e");
			} else if (self.swenf.w) {
				Label.set_text("#debug", "w");
			}

			if (self._not_taking_off) {
				if (self.is_tracking) {
					Go.set_position(Go.get_position() + Vmath.vector3(0, -0.1, 0));
				} else {
					return;
				}
			}
			final rlenght:Float = 4.0;
			var from = Go.get_position();
			// South Direction
			var lenght:Vector3 = vector3(0, -rlenght, 0); // TODO get image size and adjust
			var efrom = from + vector3(0, -10, 0); // TODO get image size and adjust
			var sto:Vector3 = vector3(efrom + lenght);
			Physics.raycast_async(efrom, sto, self.tableFloor, RCTABLE_FLOOR);

			Tools.draw_line(efrom, sto);
			Physics.raycast_async(from, sto, self.tableSouth, RCSOUTH);
			// North Direction
			final nlenght:Vector3 = vector3(0, rlenght, 0);
			final nto:Vector3 = vector3(from + nlenght);
			Tools.draw_line(from, nto);
			Physics.raycast_async(from, nto, self.tableNorth, RCNORTH);
			// East Direction
			final elenght:Vector3 = vector3(rlenght, 0, 0);
			final eto:Vector3 = vector3(from + elenght);
			Tools.draw_line(from, eto);
			Physics.raycast_async(from, eto, self.tableEast, RCEAST);
			// West Direction
			final wlenght:Vector3 = vector3(-rlenght, 0, 0);
			final wto:Vector3 = vector3(from + wlenght);
			Tools.draw_line(from, wto);
			Physics.raycast_async(from, wto, self.tableWest, RCWEST);
			//
			if (self.swenf.f) {
				trace("Moving Falling");
				self.swenf.i = false;
			} else if (self.swenf.n && !self.swenf.i) {
				trace("Moving North");
				final p = Go.get_position();
				Go.set_position(p + Vmath.vector3(0, MOVEMENT_SPEED, 0));
			} else if (self.swenf.e && !self.swenf.i) {
				//				trace("Moving East");
				final p = Go.get_position();
				Go.set_position(p + Vmath.vector3(MOVEMENT_SPEED, 0, 0));
			} else if (self.swenf.s && !self.swenf.i) {
				trace("Moving South");
				final p = Go.get_position();
				Go.set_position(p + Vmath.vector3(0, -MOVEMENT_SPEED, 0));
			} else if (self.swenf.w && !self.swenf.i) {
				//				trace("Moving West");
				final p = Go.get_position();
				Go.set_position(p + Vmath.vector3(-MOVEMENT_SPEED, 0, 0));
			} else if (self.swenf.i) {
				trace("Not Moving, Idle");
			}
			counter = 0.0;
		}
	}

	override function on_message<T>(self:Data, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case defold.PhysicsMessages.ray_cast_response:
				if (message.request_id == RCTABLE_FLOOR) {
					//					trace('!!!!!!HIT FLOOR message_id $message_id message $message');
					self._not_taking_off = false;
				}
			case PhysicsMessages.ray_cast_missed:
				if (message.request_id == RCTABLE_FLOOR) {
					//					trace('******MISSED FLOOR message_id $message_id message $message');
					self._not_taking_off = true;
				}
			case defold.PhysicsMessages.collision_response:
				if (message.other_group == hash('pepper')) {
					self.not_peppered = false;
					self.isMoving = false;
					Timer.delay(6.0, false, callback_peppered);
					set_animation_pepper(self);
				}
			case SpriteMessages.animation_done:
				if (message.id == EnemyEntityHash.pickle_dead) {
					Globals.total_num_current_monsters--;
					Go.delete();
				} else if (message.id == EnemyEntityHash.egg_dead) {
					Globals.total_num_current_monsters--;
					Go.delete();
				} else if (message.id == EnemyEntityHash.hotdog_dead) {
					Globals.total_num_current_monsters--;
					Go.delete();
				} else if (message.id == EnemyEntityHash.pickle_peppered) {
					Msg.post('#sprite', SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_front});
					Msg.post("#", EnemyMessage.msg_retract_chef_transponder);
					self.not_peppered = true;
				} else if (message.id == EnemyEntityHash.egg_peppered) {
					Msg.post('#sprite', SpriteMessages.play_animation, {id: EnemyEntityHash.egg_front});
					Msg.post("#", EnemyMessage.msg_retract_chef_transponder);
					self.not_peppered = true;
				} else if (message.id == EnemyEntityHash.hotdog_peppered) {
					Msg.post('#sprite', SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_front});
					Msg.post("#", EnemyMessage.msg_retract_chef_transponder);
					self.not_peppered = true;
				}
			// Game Messages
			case EnemyMessage.msg_retract_chef_transponder:
			// TODO Left off here
			case EnemyMessage.msg_die:
				if (self._border) {
					set_animation_dead(self);
					self._border = false;
				}
			case EnemyMessage.msg_go_left:
				self.swenf.w = true;
				self.swenf.e = false;
				self.swenf.n = false;
				self.swenf.s = false;
			case EnemyMessage.msg_go_right:
				self.swenf.w = false;
				self.swenf.e = true;
				self.swenf.n = false;
				self.swenf.s = false;
			case EnemyMessage.msg_go_up:
				self.swenf.w = false;
				self.swenf.e = false;
				self.swenf.n = true;
				self.swenf.s = false;
			case EnemyMessage.msg_go_down:
				self.swenf.w = false;
				self.swenf.e = false;
				self.swenf.n = false;
				self.swenf.s = true;
		}
	}

	override function final_(self:Data):Void {}

	override function on_reload(self:Data):Void {}

	private function set_animation_back(self:Data):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_back});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_dead});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_back});
		}
	}

	private function set_animation_left(self:Data):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_left});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_left});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_left});
		}
	}

	private function set_animation_right(self:Data):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_right});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_right});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_right});
		}
	}

	private function set_animation_dead(self:Data):Void {
		switch (self.type) {
			case 0:
				self.isMoving = false;
				self.not_peppered = false;
				Timer.delay(Rand.float(2, 3), false, function(self, handle:TimerHandle, time_elapsed:Float) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_dead});
				});
			case 1:
				self.isMoving = false;
				self.not_peppered = false;

				Timer.delay(Rand.float(2, 3), false, function(self, handle:TimerHandle, time_elapsed:Float) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_dead});
				});
			case 2:
				self.isMoving = false;
				self.not_peppered = false;

				Timer.delay(Rand.float(2, 3), false, function(self, handle:TimerHandle, time_elapsed:Float) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_dead});
				});
		}
	}

	private function set_animation_pepper(self:Data):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_peppered});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_peppered});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_peppered});
		}
	}

	private function set_animation_front(self:Data):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_front});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_front});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_front});
		}
	}

	private function callback_peppered(self:Data, _, _):Void {
		self.not_peppered = true;
		self.isMoving = true;
		set_animation_front(self);
		// TODO SWEN SCAN ?
	}
}
