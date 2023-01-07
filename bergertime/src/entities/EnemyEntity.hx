package entities;

import defold.Vmath;
import haxe.ValueException;
import defold.Timer;

import entities.SWEN;

import defold.Sprite.SpriteMessages;

import Defold.hash;

import defold.Vmath.vector3;

import defold.types.Vector3;

import ecs.c.GravityComponent;

import defold.Physics;

import defold.types.Hash;

import defold.Go;
import defold.Msg;

import defold.types.Message;
import defold.types.Url;

import defold.support.Script;

@:build(defold.support.MessageBuilder.build())
class EnemyMessage {
	var msg_init:{type:Int};
	var msg_modify_pos:{p:Vector3};
	var msg_die; // Never really happens in the original game
	var msg_spawn;
}

typedef Data = {
	// go.set("myobject#my_script", "my_property", val + 1)
	@property(true) var not_peppered:Bool;
	var type:Int;
	var isMoving:Bool;
	var swen:SWEN; //
	var tableFloor:lua.Table<Int, Hash>;
	var tableNorth:lua.Table<Int, Hash>;
	var tableEast:lua.Table<Int, Hash>;
	var tableSouth:lua.Table<Int, Hash>;
	var tableWest:lua.Table<Int, Hash>;
	var tableOnLadder:lua.Table<Int, Hash>;
	//
	var c0:GravityComponent;
	var e:eskimo.Entity;

}

class Entity extends Script<Data> {
	var counter:Float;
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
		//
		// self.not_peppered = true;
		self.c0 = new GravityComponent(Go.get_id(), vector3(0, -0.20, 0));
		self.c0.changeFlag = true;
		self.e = Globals.context.entities.create();
		// TODO dle left off here and enemy components 
		Globals.context.components.set(self.e, self.c0);
		//
		set_animation_front(self.type);
		self.isMoving = true;
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

			counter = 0.0;
		}
	}

	override function on_message<T>(self:Data, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case defold.PhysicsMessages.ray_cast_response:
				if (message.request_id == RCTABLE_FLOOR) {
					trace('!!!!!!HIT FLOOR message_id $message_id message $message');
					self.c0.notOnGround = false;
					self.c0.changeFlag = true;
				}
			case PhysicsMessages.ray_cast_missed:
				if (message.request_id == RCTABLE_FLOOR) {
					trace('******MISSED FLOOR message_id $message_id message $message');
					self.c0.notOnGround = true;
					self.c0.changeFlag = true;
				}
			case defold.PhysicsMessages.collision_response:
				if (message.other_group == hash('pepper')) {
					self.not_peppered = false;
					self.isMoving = false;
					Timer.delay(6.0, false, callback_peppered);
					set_animation_pepper(self.type);
				}
			case EnemyMessage.msg_init:
				self.type = message.type;
			case EnemyMessage.msg_die:
				set_animation_dead(self.type);
			case EnemyMessage.msg_spawn:
				trace('spawn');
			case EnemyMessage.msg_modify_pos:
				Go.set(".", "position.y", message.p.y);
			case SpriteMessages.animation_done:
				if (message.id == hash('pickle-died')) {
					Globals.total_num_current_monsters--;
					Go.delete();
				}
				if (message.id == hash('egg-died')) {
					Globals.total_num_current_monsters--;
					Go.delete();
				}
				if (message.id == hash('hotdog-died')) {
					Globals.total_num_current_monsters--;
					Go.delete();
				}
		}
	}

	override function final_(self:Data):Void {}

	override function on_reload(self:Data):Void {}

	private function set_animation_back(t:Int):Void {
		switch (t) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("egg-back")});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("pickle-back")});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-back")});
		}
	}

	private function set_animation_left(t:Int):Void {
		switch (t) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("egg-left")});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("pickle-left")});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-left")});
		}
	}

	private function set_animation_right(t:Int):Void {
		switch (t) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("egg-right")});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("pickle-right")});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-right")});
		}
	}

	private function set_animation_dead(t:Int):Void {
		switch (t) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("egg-dead")});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("pickle-dead")});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-dead")});
		}
	}

	private function set_animation_pepper(t:Int):Void {
		switch (t) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("egg-peppered")});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("pickle-peppered")});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-peppered")});
		}
	}

	private function set_animation_front(t:Int):Void {
		switch (t) {
			case 0:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("egg-front")});
			case 1:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("pickle-front")});
			case 2:
				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-front")});
		}
	}

	private function callback_peppered(self:Data, _, _):Void {
		self.not_peppered = true;
		self.isMoving = true;
		set_animation_front(self.type);
		// TODO SWEN SCAN ?
	}
}
