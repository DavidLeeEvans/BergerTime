package entities;

import Defold.hash;

import defold.Factory;
import defold.Go;
import defold.Msg;
import defold.Physics;

import defold.Sprite.SpriteMessages;

import defold.Timer;
import defold.Vmath;

import defold.support.Script;

import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;

import game.BergerGameScript.BergerGameMessage;

import hud.GHud;

import hud.HudGUI.HudGUIMessage;

import lua.Table;

@:build(defold.support.HashBuilder.build())
private class ChefEntityHash {
	var treat;
	var treats_coffee;
	var treats_fries;
	var treats_icecream;
	var treats_candy;
	var border;
	var chef;
	var die;
	var enemy;
	//
	var move_up;
	var move_down;
	var move_left;
	var move_right;
	//
	var move_pepper;
	//
	var anime_chef_die;
	var anime_chef_idle;
	var anime_chef_front;
	var anime_chef_back;
	var anime_chef_left;
	var anime_chef_right;
	//
}

private typedef ChefData = {
	var chefSpeed:Float;
	var faceDir:Int;
	var numPepperShots:Int;
	// Direction flags
	var _movement_counter:Float;
	//
	var bNorthEnable:Bool;
	var bEastEnable:Bool;
	var bSouthEnable:Bool;
	var bWestEnable:Bool;
	//
}

class ChefEntity extends Script<ChefData> {
	static final RC_ONGROUND:Int = 1;
	static final RC_BORDER_NORTH:Int = 2;
	static final RC_BORDER_EAST:Int = 3;
	static final RC_BORDER_SOUTH:Int = 4;
	static final RC_BORDER_WEST:Int = 5;
	static final RC_ON_LADDER:Int = 6;
	static final CHEF_SPEED:Float = 0.6;
	static final CHEF_SPEED_COFFEE:Float = 1.2;

	final hmovement:Hash = hash('movement');
	final hFloor:Hash = hash('fixture');
	final hBorder:Hash = hash('border');
	var counter:Float = 0;
	var gravity_counter:Float = 0;
	//
	final sPepperFactory = '/chef#pepper_factory';
	final sHud = '/go#hud';
	//
	final FALL_RATE = -1.0;

	override function init(self:ChefData) {
		self.bNorthEnable = false;
		self.bEastEnable = false;
		self.bSouthEnable = false;
		self.bWestEnable = false;

		self._movement_counter = 0;

		self.chefSpeed = CHEF_SPEED;
		self.numPepperShots = 6;
		Msg.post(sHud, HudGUIMessage.set_pepper, {num: self.numPepperShots});
		self.faceDir = 0; // 0 Up, 1, Left, 2 Down, 3 Right, 4 Idle
	}

	override function update(self:ChefData, dt:Float):Void {
		movement(self, dt);
		counter = counter + 1.0;
		if (counter > 15.0) {
			counter = 0.0;
		}
	}

	override function on_message<T>(self:ChefData, message_id:Message<T>, message:T, _):Void {
		switch (message_id) {
			case GHudMessage.tap:
				Defold.pprint("Chef tap");
				final PEPPER_SPEED = 3.2;
				var v:Vector3 = Vmath.vector3(0, 0, 0);
				if (self.numPepperShots > 0) {
					switch (self.faceDir) {
						case 0: // N
							v = Vmath.vector3(0, PEPPER_SPEED, 0);
						case 1: // W
							v = Vmath.vector3(-PEPPER_SPEED, 0, 0);
						case 2: // S
							v = Vmath.vector3(0, -PEPPER_SPEED, 0);
						case 3: // E
							v = Vmath.vector3(PEPPER_SPEED, 0, 0);
					}
					Factory.create("#pepper_factory", Go.get_world_position(), null, Table.create({direction: v}));
				}

				if (self.faceDir != 4) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_idle});
					self.faceDir = 4;
				}

			case SpriteMessages.animation_done:
				if (message.id == ChefEntityHash.anime_chef_die) {
					Globals.total_num_lives--;
					if (Globals.total_num_lives <= 0)
						Msg.post("/BergerGameScript", BergerGameMessage.game_over); // TODO NOT RIGHT
					Msg.post(sHud, HudGUIMessage.set_lives, {lives: Globals.total_num_lives});
					Go.delete();
				}
			case PhysicsMessages.collision_response:
				if (message.other_group == ChefEntityHash.enemy) {
					var enemy_script:Url = defold.Msg.url(null, message.other_id, "Entity");
					var not_peppered:Bool = Go.get(enemy_script, "not_peppered");
					if (not_peppered) {
						self.chefSpeed = 0; // Set Russian Chef Speed to Zero
						Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_die});
					}
				}

			case PhysicsMessages.trigger_response:
				if (message.own_group == ChefEntityHash.chef) {
					if (message.other_group == ChefEntityHash.treat) {
						if (message.other_id == ChefEntityHash.treats_coffee) {
							Msg.post("/go#hud", HudGUIMessage.add_score, {num: 11});
							self.chefSpeed = CHEF_SPEED_COFFEE;
							Timer.delay(11.0, false, treat_callback); // 11 seconds boost
						} else if (message.other_id == ChefEntityHash.treats_fries) {
							Msg.post("/go#hud", HudGUIMessage.add_score, {num: 61});
						} else if (message.other_id == ChefEntityHash.treats_icecream) {
							Msg.post("/go#hud", HudGUIMessage.add_score, {num: 4114});
						} else if (message.other_id == ChefEntityHash.treats_candy) {
							Msg.post("/go#hud", HudGUIMessage.add_score, {num: 27});
						}
					}
					if (message.other_group == ChefEntityHash.border) {
						// TODO test this dle
					}
				}
		}
	}

	override function on_reload(self:ChefData):Void {}

	override function final_(self:ChefData):Void {}

	private function treat_callback(self:ChefData, _, _):Void {
		self.chefSpeed = CHEF_SPEED;
	}

	private function movement(self:ChefData, dt:Float):Void {
		var p:Vector3;
		self._movement_counter += dt;
		if (self._movement_counter < .020)
			return;
		self._movement_counter = 0;
		p = Go.get_world_position();
		// 0 Up, 1, Left, 2 Down, 3 Right, 4 Idle
		switch (self.faceDir) {
			case 0:
				if (self.bNorthEnable)
					Go.set_position(p + Vmath.vector3(0, 1, 0));
			case 1:
				if (self.bWestEnable)
					Go.set_position(p + Vmath.vector3(-1, 0, 0));
			case 2:
				if (self.bSouthEnable)
					Go.set_position(p + Vmath.vector3(0, -1, 0));
			case 3:
				if (self.bEastEnable)
					Go.set_position(p + Vmath.vector3(1, 0, 0));
			case 4:
		}
	}
}
