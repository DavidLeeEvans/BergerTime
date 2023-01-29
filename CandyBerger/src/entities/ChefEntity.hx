package entities;

import Defold.hash;

import defold.Factory;
import defold.Go;
import defold.Msg;
import defold.Physics;

import defold.Sprite.SpriteMessages;

import defold.Timer;

import defold.Vmath.vector3;

import defold.Vmath;

import defold.support.Script;
import defold.support.ScriptOnInputAction;

import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;

import entities.PepperEntity.PepperMessage;

import game.BergerGameScript.BergerGameMessage;

import hud.GHud;

import hud.HudGUI.HudGUIMessage;

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
	var pepper;
	//
	var chef_die;
	var chef_idle;
	var chef_front;
	var chef_back;
	var chef_left;
	var chef_right;
	//
}

private typedef ChefData = {
	var chefSpeed:Float;
	var faceDir:Int;
	//
	//
	var tableFloor:lua.Table<Int, Hash>;
	var tableBorder:lua.Table<Int, Hash>;
	var tableMovement:lua.Table<Int, Hash>;

	//
	var numPepperShots:Int;
	// Direction flags
	// Gravity
	var bGravity:Bool;
	var bNorthEnable:Bool;
	var bEastEnable:Bool;
	var bSouthEnable:Bool;
	var bWestEnable:Bool;
	//
	var _movement_counter:Float;
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
		self.bGravity = false;
		self._movement_counter = 0;

		self.chefSpeed = CHEF_SPEED;
		self.numPepperShots = 6;
		Msg.post(sHud, HudGUIMessage.set_pepper, {num: self.numPepperShots});

		//
		self.faceDir = 0; // 0 Up, 1, Left, 2 Down, 3 Right, 4 Idle
		//
		self.tableFloor = lua.Table.create();
		self.tableBorder = lua.Table.create();
		self.tableMovement = lua.Table.create();

		// On the Floor, Collision Detection
		// lua.Table.insert(self.tableFloor, hPlate);
		lua.Table.insert(self.tableFloor, hFloor);
		lua.Table.insert(self.tableMovement, hmovement);
		lua.Table.insert(self.tableBorder, hBorder);
		//
		Msg.post(".", GoMessages.acquire_input_focus);
	}

	override function update(self:ChefData, dt:Float):Void {
		counter = counter + 1.0;
		gravity_counter = gravity_counter + 1.0;
		if (gravity_counter > 2.0) {
			gravity_counter = 0;
			final p = Go.get_position();
			var lenght:Vector3 = vector3(0, -6.0, 0);
			var efrom = p + vector3(0, -10, 0);
			var to:Vector3 = vector3(efrom + lenght);
			Physics.raycast_async(efrom, to, self.tableFloor, RC_ONGROUND);
			if (self.bGravity) {
				trace("Gravity Firing True");
				Tools.draw_line(efrom, to, Vmath.vector4(0, 256, 256, 256));
				Go.set_position(p + Vmath.vector3(0, FALL_RATE, 0));
			}
		}

		if (counter > 15.0) {
			// trace('counter fired');
			counter = 0.0;
			final p = Go.get_position();
			var lenght:Vector3 = vector3(0, -6.0, 0); // TODO get image size and adjust
			var efrom = p + vector3(0, -10, 0); // TODO get image size and adjust
			var to:Vector3 = vector3(efrom + lenght);
			// Physics.raycast_async(efrom, to, self.tableFloor, RC_ONGROUND);
			//
			final weray = 32.0;
			// **North**
			Physics.raycast_async(p, p + vector3(0, weray, 0), self.tableMovement, RC_BORDER_NORTH);
			Tools.draw_line(p, p + vector3(0, -weray, 0));
			// East
			Physics.raycast_async(p, p + vector3(weray / 2.0, 0.0, 0), self.tableBorder, RC_BORDER_EAST);
			Tools.draw_line(p, p + vector3(weray, 0, 0));
			// **South**
			Physics.raycast_async(p, p + vector3(0, -weray, 0), self.tableMovement, RC_BORDER_SOUTH);
			Tools.draw_line(p, p + vector3(0, weray, 0));
			// West
			Physics.raycast_async(p, p + vector3(-weray / 2.0, 0.0, 0), self.tableBorder, RC_BORDER_WEST);
			Tools.draw_line(p, p + vector3(-weray, 0, 0));
		}
		movement(self, dt);
	}

	override function on_message<T>(self:ChefData, message_id:Message<T>, message:T, _):Void {
		switch (message_id) {
			case GHudMessage.double_tap:
				Defold.pprint("Chef double_tap");
			// TODO Spawn Pepper

			case GHudMessage.tap:
				Defold.pprint("Chef tap");
				if (self.faceDir != 4) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_idle});
					self.faceDir = 4;
				}

			case GHudMessage.sdown:
				Defold.pprint("Chef sdown");
				if (self.faceDir != 2) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_back});
					self.faceDir = 2;
				}

			case GHudMessage.sup:
				Defold.pprint("Chef sup");
				if (self.faceDir != 0) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_front});
					self.faceDir = 0;
				}

			case GHudMessage.sleft:
				Defold.pprint("Chef seleft");
				if (self.faceDir != 1) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_left});
					self.faceDir = 1;
				}

			case GHudMessage.sright:
				Defold.pprint("Chef sright");
				if (self.faceDir != 3) {
					Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_right});
					self.faceDir = 3;
				}

			case PhysicsMessages.ray_cast_response:
				// trace('message_id $message_id message $message');
				// TODO try to get script property message.id For Future Use?? ?
				if (message.request_id == RC_ONGROUND) {
					self.bGravity = false;
				}
				if (message.request_id == RC_BORDER_NORTH) {
					self.bNorthEnable = false;
				}
				if (message.request_id == RC_BORDER_EAST) {
					self.bEastEnable = false;
				}
				if (message.request_id == RC_BORDER_SOUTH) {
					self.bSouthEnable = false;
				}
				if (message.request_id == RC_BORDER_WEST) {
					trace('Hit Left Border');
					self.bWestEnable = false;
				}

			case PhysicsMessages.ray_cast_missed:
				// trace('message_id $message_id message $message');
				if (message.request_id == RC_ONGROUND) {
					self.bGravity = true;
				}
				if (message.request_id == RC_BORDER_NORTH) {
					self.bNorthEnable = true;
				}
				if (message.request_id == RC_BORDER_EAST) {
					self.bEastEnable = true;
				}
				if (message.request_id == RC_BORDER_SOUTH) {
					self.bSouthEnable = true;
				}
				if (message.request_id == RC_BORDER_WEST) {
					self.bWestEnable = true;
				}
			case SpriteMessages.animation_done:
				if (message.id == ChefEntityHash.chef_die) {
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
						Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_die});
					}
				}

			case PhysicsMessages.trigger_response:
				// trace('TRIGGER message_id $message_id message $message');
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

	override function on_input(self:ChefData, action_id:Hash, action:ScriptOnInputAction) {
		final p = Go.get(".", "position"); // TODO WHY ??????
		// North
		if (action_id == ChefEntityHash.move_up && !self.bNorthEnable) {
			Go.set(".", "position", p + vector3(0, self.chefSpeed, 0)); // TODO WHY ?????? For Enemies:
			if (self.faceDir != 0)
				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_front});
			self.faceDir = 0;
		} else if (action_id == ChefEntityHash.move_down && !self.bSouthEnable) {
			Go.set(".", "position", p + vector3(0, -self.chefSpeed, 0));
			if (self.faceDir != 2)
				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_back});
			self.faceDir = 2;
		} else if (action_id == ChefEntityHash.move_left && self.bWestEnable) {
			Go.set(".", "position", p + vector3(-self.chefSpeed, 0, 0));
			if (self.faceDir != 3)
				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_left});
			self.faceDir = 3;
		} else if (action_id == ChefEntityHash.move_right && self.bEastEnable) {
			Go.set(".", "position", p + vector3(self.chefSpeed, 0, 0));
			if (self.faceDir != 1)
				Msg.post("#sprite", SpriteMessages.play_animation, {id: ChefEntityHash.chef_right});
			self.faceDir = 1;
		} else if (action_id == ChefEntityHash.pepper && action.released) {
			trace('pepper');
			var collision_object:Vector3 = vector3(0, 0, 0);
			switch (self.faceDir) {
				case 0:
					collision_object = vector3(0, 1, 0);
				case 1:
					collision_object = vector3(1, 0, 0);
				case 2:
					collision_object = vector3(0, -1, 0);
				case 3:
					collision_object = vector3(-1, 0, 0);
			}
			if (self.numPepperShots > 0) {
				var p = Factory.create(sPepperFactory, Go.get(".", "position"));
				// Assertion.assert(p != null);
				Msg.post(p, PepperMessage.flight_path, {flight_direction: collision_object});
				self.numPepperShots--;
				Msg.post(sHud, HudGUIMessage.set_pepper, {num: self.numPepperShots});
			}
		}
		return false;
	}

	override function on_reload(self:ChefData):Void {}

	override function final_(self:ChefData):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

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
				Go.set_position(p + Vmath.vector3(0, 1, 0));
			case 1:
				Go.set_position(p + Vmath.vector3(-1, 0, 0));
			case 2:
				Go.set_position(p + Vmath.vector3(0, -1, 0));
			case 3:
				Go.set_position(p + Vmath.vector3(1, 0, 0));
			case 4:
				// Left empty idle
		}
	}
}
