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
	var msg_go_idle;
	var local_msg_retract_chef_transponder_send;
	var remote_msg_retract_chef_transponder_send;
	var msg_retract_chef_transponder_receive:{
		n:Bool,
		e:Bool,
		s:Bool,
		w:Bool
	};
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

private typedef EnemyData = {
	var _trig_abort:Bool;
	var _border:Bool;
	var _debug:Bool;
	@property(true) var not_peppered:Bool;
	@property(true) var is_tracking:Bool;
	@property(-1) var type:Int; // egg-0, pickle-1, sausage-2
	var can_go_n:Bool;
	var can_go_e:Bool;
	var can_go_s:Bool;
	var can_go_w:Bool;
	var down_none_up:Int;
	var left_none_right:Int;
	var isMoving:Bool;
	var swenf:SWENF; //
	var tableFloor:lua.Table<Int, Hash>;
	var tableNorth:lua.Table<Int, Hash>;
	var tableEast:lua.Table<Int, Hash>;
	var tableSouth:lua.Table<Int, Hash>;
	var tableWest:lua.Table<Int, Hash>;
	var tableOnLadder:lua.Table<Int, Hash>;
	var vborder:lua.Table<Int, Hash>;
	//
}

class Entity extends Script<EnemyData> {
	//
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
	final hladder:Hash = hash('movement');
	final hFloor:Hash = hash('fixture');
	final hLBorder:Hash = hash('vl_border');
	final hRBorder:Hash = hash('vr_border');

	//
	// Enemy Egg 0 == Create Broken Eggs Animations
	// Enemy Pickle 1
	// Enemy Sausage 2

	override function init(self:EnemyData) {
		lua.Lua.assert(self.type != -1, "Enemy Type Not Set");
		self._border = true;
		self._trig_abort = false;
		self.can_go_n = false;
		self.can_go_e = false;
		self.can_go_s = false;
		self.can_go_w = false;

		self.down_none_up = 0;
		self.left_none_right = 0;
		//
		self._debug = defold.Sys.get_engine_info().is_debug;
		self.swenf = new SWENF();
		set_animation_front(self);
		self.swenf.n = false;
		self.swenf.e = false;
		self.swenf.s = false;
		self.swenf.w = false;
		self.swenf.i = false;

		self.isMoving = true;
		if (Rand.bool()) {
			Msg.post("#", EnemyMessage.msg_go_left);
			self.can_go_e = false;
			self.can_go_w = true;
		} else {
			Msg.post("#", EnemyMessage.msg_go_right);
			self.can_go_e = true;
			self.can_go_w = false;
		}

		counter = 0.0;
		self.tableFloor = lua.Table.create();
		self.tableNorth = lua.Table.create();
		self.tableEast = lua.Table.create();
		self.tableSouth = lua.Table.create();
		self.tableWest = lua.Table.create();

		lua.Table.insert(self.tableFloor, hFloor);
		//
		//
		lua.Table.insert(self.tableEast, hladder);
		lua.Table.insert(self.tableWest, hladder);
		//
		lua.Table.insert(self.tableNorth, hladder);
		lua.Table.insert(self.tableSouth, hladder);
	}

	override function update(self:EnemyData, dt:Float):Void {
		counter = counter + 1.0;
		if (counter > 15.0) {
			if (self.swenf.e) {
				Label.set_text("#debug", "e");
			} else if (self.swenf.w) {
				Label.set_text("#debug", "w");
			} else if (self.swenf.n) {
				Label.set_text("#debug", "n");
			} else if (self.swenf.s) {
				Label.set_text("#debug", "s");
			}

			if (self.is_tracking) {
				final ENEMY_MOVEMENT_SPEED = 6.9; // TODO?? dle
				if (self.swenf.n)
					Go.set_position(Go.get_position() + Vmath.vector3(0, ENEMY_MOVEMENT_SPEED, 0));
				else if (self.swenf.e)
					Go.set_position(Go.get_position() + Vmath.vector3(ENEMY_MOVEMENT_SPEED, 0, 0));
				else if (self.swenf.s)
					Go.set_position(Go.get_position() + Vmath.vector3(0, -ENEMY_MOVEMENT_SPEED, 0));
				else if (self.swenf.w)
					Go.set_position(Go.get_position() + Vmath.vector3(-ENEMY_MOVEMENT_SPEED, 0, 0));
			} else {
				return;
			}
			// final rlenght:Float = 20.0;
			final rlenght:Float = 10.0;
			var from = Go.get_position();

			// South Direction
			var lenght:Vector3 = vector3(0, -rlenght, 0); // TODO get image size and adjust
			var efrom = from + vector3(0, -10, 0); // TODO get image size and adjust
			var sto:Vector3 = vector3(efrom + lenght);
			Physics.raycast_async(efrom, sto, self.tableFloor, RCTABLE_FLOOR);
			//
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
			counter = 0.0;
		}
	}

	override function on_message<T>(self:EnemyData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case defold.PhysicsMessages.ray_cast_response:
				if (message.request_id == RCTABLE_FLOOR) {
					//					trace('!!!!!!HIT FLOOR message_id $message_id message $message');
				} else if (message.request_id == RCEAST) {
					if (message.group == hRBorder) {
						Defold.pprint("East");
						Msg.post("#", EnemyMessage.msg_go_left);
					}
				} else if (message.request_id == RCWEST) {
					if (message.group == hLBorder) {
						Defold.pprint("West");
						Msg.post("#", EnemyMessage.msg_go_right);
					}
				} else if (message.request_id == RCNORTH) {
					if (message.group == hPlate)
						Defold.pprint("Testing Tracking Of Enemies North");
				} else if (message.request_id == RCSOUTH) {
					if (message.group == hPlate)
						Defold.pprint("Testing Tracking Of Enemies South");
				}

			case PhysicsMessages.ray_cast_missed:
				if (message.request_id == RCTABLE_FLOOR) {
					Defold.pprint("---------------MISSED-------------");
					Go.set_position(Go.get_world_position() + Vmath.vector3(0, -1.0, 0));
				}
			case defold.PhysicsMessages.collision_response:
				if (message.other_group == hash('pepper')) {
					self.not_peppered = false;
					self.isMoving = false;
					Timer.delay(6.0, false, callback_peppered);
					set_animation_pepper(self);
				}
				if (message.other_group == hash('fixture')) {
					final u:Url = Msg.url(null, message.other_id, "fixture");
					final type:Int = Std.int(Go.get(u, hash("fixture_type")));
					if (type == 1)
						Msg.post("#", EnemyMessage.msg_go_right);
					else if (type == 2)
						Msg.post("#", EnemyMessage.msg_go_left);
					else if (type == 3) {
						Msg.post(message.other_id, EnemyMessage.remote_msg_retract_chef_transponder_send);
						Msg.post("#", EnemyMessage.local_msg_retract_chef_transponder_send);
						if (self.left_none_right == -1 && self.can_go_w)
							Msg.post("#", EnemyMessage.msg_go_left);
						else if (self.left_none_right == 1 && self.can_go_e)
							Msg.post("#", EnemyMessage.msg_go_right);
						else if (self.down_none_up == -1 && self.can_go_s)
							Msg.post("#", EnemyMessage.msg_go_down);
						else if (self.down_none_up == 1 && self.can_go_n)
							Msg.post("#", EnemyMessage.msg_go_up);
					}
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
					Msg.post("#", EnemyMessage.local_msg_retract_chef_transponder_send);
					self.not_peppered = true;
				} else if (message.id == EnemyEntityHash.egg_peppered) {
					Msg.post('#sprite', SpriteMessages.play_animation, {id: EnemyEntityHash.egg_front});
					Msg.post("#", EnemyMessage.local_msg_retract_chef_transponder_send);
					self.not_peppered = true;
				} else if (message.id == EnemyEntityHash.hotdog_peppered) {
					Msg.post('#sprite', SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_front});
					Msg.post("#", EnemyMessage.local_msg_retract_chef_transponder_send);
					self.not_peppered = true;
				}
			// Game Messages
			case EnemyMessage.msg_retract_chef_transponder_receive:
				self.can_go_n = message.n;
				self.can_go_e = message.e;
				self.can_go_s = message.s;
				self.can_go_w = message.w;
			case EnemyMessage.local_msg_retract_chef_transponder_send:
				if (self._trig_abort)
					return;
				Defold.pprint("Tracking Enemies Movements Pickle");
				self._trig_abort = true;
				Timer.delay(2.0, false, (self, _, _) -> self._trig_abort = false);
				Defold.pprint("msg_retract_chef_transponder:");
				self.swenf.w = false;
				self.swenf.e = false;
				self.swenf.n = false;
				self.swenf.s = false;
				final _chef_position = Go.get_world_position("/chef");
				lua.Lua.assert(_chef_position != null, "Error Couldn't Locate the Chef Position");
				final p = Go.get_world_position();
				self.left_none_right = 0;
				self.down_none_up = 0;
				if (p.y > _chef_position.y) {
					self.swenf.s = true;
					self.down_none_up = -1;
				} else {
					self.swenf.n = true;
					self.down_none_up = 1;
				}

				if (p.x > _chef_position.x) {
					self.swenf.w = true;
					self.left_none_right = -1;
				} else {
					self.swenf.e = true;
					self.left_none_right = 1;
				}

			case EnemyMessage.msg_die:
				if (self._border) {
					set_animation_dead(self);
					self._border = false;
				}
			case EnemyMessage.msg_go_left:
				self.swenf.w = true;
				self.swenf.e = false;
				self.swenf.s = false;
				self.swenf.n = false;
				set_animation_left(self);
			case EnemyMessage.msg_go_right:
				self.swenf.e = true;
				self.swenf.w = false;
				self.swenf.s = false;
				self.swenf.n = false;
				set_animation_right(self);
			case EnemyMessage.msg_go_up:
				self.swenf.n = true;
				self.swenf.s = false;
				self.swenf.e = false;
				self.swenf.w = false;
				set_animation_front(self);
			case EnemyMessage.msg_go_down:
				self.swenf.s = true;
				self.swenf.n = false;
				self.swenf.e = false;
				self.swenf.w = false;
				set_animation_back(self);
			case EnemyMessage.msg_go_idle:
				self.swenf.s = false;
				self.swenf.n = false;
				self.swenf.e = false;
				self.swenf.w = false;
				Defold.pprint("!!!IDLE!!!");
		}
	}

	override function final_(self:EnemyData):Void {}

	override function on_reload(self:EnemyData):Void {}

	private function set_animation_back(self:EnemyData):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_back});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_dead});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_back});
		}
	}

	private function set_animation_left(self:EnemyData):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_left});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_left});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_left});
		}
	}

	private function set_animation_right(self:EnemyData):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_right});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_right});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_right});
		}
	}

	private function set_animation_dead(self:EnemyData):Void {
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

	private function set_animation_pepper(self:EnemyData):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_peppered});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_peppered});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_peppered});
		}
	}

	private function set_animation_front(self:EnemyData):Void {
		switch (self.type) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.egg_front});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.pickle_front});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: EnemyEntityHash.hotdog_front});
		}
	}

	private function callback_peppered(self:EnemyData, _, _):Void {
		self.not_peppered = true;
		self.isMoving = true;
		set_animation_front(self);
		// TODO SWEN SCAN ?
	}
}
