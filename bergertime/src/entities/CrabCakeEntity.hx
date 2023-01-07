package entities;

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
class CrabCakeMessage {
	var msg_modify_pos:{p:Vector3};
	var msg_die; // Never really happens in the original game
	var msg_spawn;
	var msg_init;
}

typedef CrabCakeData = {
	var isMoving:Bool;
	// var e:Entity;
	var swen:SWEN; //
	var tableFloor:lua.Table<Int, Hash>;
	var tableNorth:lua.Table<Int, Hash>;
	var tableEast:lua.Table<Int, Hash>;
	var tableSouth:lua.Table<Int, Hash>;
	var tableWest:lua.Table<Int, Hash>;
	var tableOnLadder:lua.Table<Int, Hash>;
	//
	var c0:GravityComponent;
}

class CrabCakeEntity extends Script<CrabCakeData> {
	var counter:Float;
	final RCTABLE_FLOOR:Int = 1;
	final RCNORTH:Int = 2;
	final RCEAST:Int = 3;
	final RCSOUTH:Int = 4;
	final RCWEST:Int = 5;
	final RCONLADDER:Int = 6;
	//
	final hPlate:Hash = hash('plate');
	final hladder:Hash = hash('ladder');
	final hFloor:Hash = hash('floor');
	final hBorder:Hash = hash('border');


	override function init(self:CrabCakeData) {
		self.c0 = new GravityComponent(Go.get_id(), vector3(0, -0.20, 0));
		self.c0.changeFlag = true;
		//
		set_animation_front();
		self.isMoving = true;
		counter = 0.0;
		self.tableFloor = lua.Table.create();
		self.tableNorth = lua.Table.create();
		self.tableEast = lua.Table.create();
		self.tableSouth = lua.Table.create();
		self.tableWest = lua.Table.create();
		self.tableOnLadder = lua.Table.create();
		//
		// lua.Table.insert(self.tableFloor, ); //TODO finish this game!!
	}

	override function update(self:CrabCakeData, dt:Float):Void {
		counter = counter + 1.0;
		if (counter > 30.0) {
			var from = Go.get_position();
			// South Direction
			final slenght:Vector3 = vector3(0, -6.0, 0);
			final sto:Vector3 = vector3(from + slenght);
			Physics.raycast_async(from, sto, self.tableSouth, RCSOUTH);
			// North Direction
			final nlenght:Vector3 = vector3(0, 6.0, 0);
			final nto:Vector3 = vector3(from + nlenght);
			Physics.raycast_async(from, nto, self.tableNorth, RCNORTH);
			// East Direction
			final elenght:Vector3 = vector3(6, 0, 0);
			final eto:Vector3 = vector3(from + elenght);
			Physics.raycast_async(from, eto, self.tableEast, RCEAST);
			// West Direction
			final wlenght:Vector3 = vector3(-6, 0, 0);
			final wto:Vector3 = vector3(from + wlenght);
			Physics.raycast_async(from, wto, self.tableWest, RCWEST);
			counter = 0.0;
		}
	}

	override function on_message<T>(self:CrabCakeData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case defold.PhysicsMessages.ray_cast_response:
				if (message.request_id == RCTABLE_FLOOR) {
					self.c0.notOnGround = false;
					self.c0.changeFlag = true;
				}
			case PhysicsMessages.ray_cast_missed:
				// trace('message_id $message_id message $message');
				if (message.request_id == RCTABLE_FLOOR) {
					self.c0.notOnGround = true;
					self.c0.changeFlag = true;
				}
			case defold.PhysicsMessages.collision_response:
				if (message.other_group == hash('pepper')) {
					Msg.post("#collision", GoMessages.disable);
					self.isMoving = false;
					Timer.delay(6.0, false, callback_peppered);
					set_animation_pepper();
				}
			case CrabCakeMessage.msg_init:
				trace('msg_init');
			case CrabCakeMessage.msg_die:
				trace('die');
			case CrabCakeMessage.msg_spawn:
				trace('spawn');
		}
	}

	override function final_(self:CrabCakeData):Void {}

	override function on_reload(self:CrabCakeData):Void {}

	private function set_animation_back():Void {
	  //Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-back")});
	}

	private function set_animation_left():Void {
	  //		Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-left")});
		}

	private function set_animation_right():Void {
	  //			Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-right")});
	       }

	private function set_animation_dead():Void {
	  //				Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-dead")});
		}

	private function set_animation_pepper():Void {
	  //			Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-peppered")});
	       }

	private function set_animation_front():Void {
	  //			Msg.post("#sprite", SpriteMessages.play_animation, {id: hash("hotdog-front")});
	       }

	private function callback_peppered(self, _, _):Void {
		Msg.post("#collision", GoMessages.enable);
		self.isMoving = true;
		set_animation_front();
		// TODO SWEN SCAN ?
	}
}
