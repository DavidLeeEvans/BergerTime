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
	//
	var border;
	var chefcoll;
	var die;
	var enemy;
	//
	// var move_up;
	// var move_down;
	// var move_left;
	// var move_right;
	// var move_pepper;
	//
	var anime_chef_die;
	var anime_chef_idle;
	var anime_chef_front;
	var anime_chef_back;
	var anime_chef_left;
	var anime_chef_right;
	//
	var hor_trig;
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
	static final CHEF_SPEED:Float = 0.6;
	static final CHEF_SPEED_COFFEE:Float = 1.2;

	final h_movement:Hash = hash('movement');
	final h_Floor:Hash = hash('fixture');
	final h_Border:Hash = hash('border');
	var counter:Float = 0;
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
		self.faceDir = 0; // 0 Up, 1, Left, 2 Down, 3 Right, 4 Idle ///
	}

	override function update(self:ChefData, dt:Float):Void {
		movement(self, dt);
		counter = counter + 1.0;
		if (counter > 15.0) {
			counter = 0.0;
		}
	}

	/**
		// Left here TODO
		// -1 = NONE
		//  0 = North
		//  1 = East
		//  2 = South
		//  3 = West
		///
		//  4 = North-West
		//  5 = North-East
		//  6 = South-West
		//  7 = South-East
		//  8 = UNKNOWN
	**/
	override function on_message<T>(self:ChefData, message_id:Message<T>, message:T, _):Void {
		switch (message_id) {
			case GHudMessage.sstap:
				Defold.pprint("Chef tap");
				self.faceDir = -1;
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

				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_idle});
				self.faceDir = -1;

			case GHudMessage.idle:
				self.faceDir = -1;
				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_idle});
			case GHudMessage.sup:
				self.faceDir = 0;
				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_front});
			case GHudMessage.sdown:
				self.faceDir = 2;
				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_back});
			case GHudMessage.sright:
				self.faceDir = 1;
			case GHudMessage.sleft:
				self.faceDir = 3;
			//
			case GHudMessage.sup_left:
				self.faceDir = 4;
			case GHudMessage.sup_right:
				self.faceDir = 5;
			case GHudMessage.sdown_left:
				self.faceDir = 6;
			case GHudMessage.sdown_right:
				self.faceDir = 7;

			case SpriteMessages.animation_done:
				if (message.id == ChefEntityHash.anime_chef_die) {
					Globals.total_num_lives--;
					if (Globals.total_num_lives <= 0)
						Msg.post("/BergerGameScript", BergerGameMessage.game_over); // TODO NOT RIGHT
					Msg.post(sHud, HudGUIMessage.set_lives, {lives: Globals.total_num_lives});
					Go.delete();
				}
			case PhysicsMessages.collision_response:
				// trace(message.other_group, message.other_id);
				if (message.own_group == ChefEntityHash.chefcoll) {
					if (message.other_group == ChefEntityHash.enemy) {
						var enemy_script:Url = defold.Msg.url(null, message.other_id, "Entity");
						var not_peppered:Bool = Go.get(enemy_script, "not_peppered");
						if (not_peppered) {
							self.chefSpeed = 0; // Set Russian Chef Speed to Zero
							Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.anime_chef_die});
						}
					}
					if (message.other_group == ChefEntityHash.hor_trig) {
						final u:Url = Msg.url(null, message.other_id, "fixture");
						var ft:Int = Std.int(Go.get(u, hash("fixture_type")));
						switch (ft) {
							case 0:
								trace(' ft == 0 ');
								self.bNorthEnable = true;
								self.bSouthEnable = true;
								self.bEastEnable = false;
								self.bWestEnable = false;
							case 1:
								trace(' ft == 1 ');
								self.bNorthEnable = false;
								self.bSouthEnable = false;
								self.bEastEnable = true;
								self.bWestEnable = true;
							case 8:
								trace(' ft == 8 ');
								self.bNorthEnable = false;
								self.bSouthEnable = false;
								self.bEastEnable = true;
								self.bWestEnable = false;
							case 9:
								trace(' ft == 9 ');
								self.bNorthEnable = false;
								self.bSouthEnable = false;
								self.bEastEnable = false;
								self.bWestEnable = true;
						}
					}
				}

			case PhysicsMessages.trigger_response:
				if (message.own_group == ChefEntityHash.chefcoll) {
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
		if (self._movement_counter < .020) {
			return;
		} else {
			self._movement_counter = 0;
			p = Go.get_world_position();
			// 0 Up, 1, Left, 2 Down, 3 Right, 4 Idle
			switch (self.faceDir) {
				case 0:
					if (self.bNorthEnable)
						Go.set_position(p + Vmath.vector3(0, 1, 0));
				case 1:
					if (self.bWestEnable)
						Go.set_position(p + Vmath.vector3(1, 0, 0));
				case 2:
					if (self.bSouthEnable)
						Go.set_position(p + Vmath.vector3(0, -1, 0));
				case 3:
					if (self.bEastEnable)
						Go.set_position(p + Vmath.vector3(-1, 0, 0));
				case 4:
			}
		}
	}
}
