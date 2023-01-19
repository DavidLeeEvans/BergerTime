package game;

import Defold.hash;

import defold.Go;
import defold.Msg;
import defold.Physics;
import defold.Sprite;
import defold.Timer;
import defold.Vmath;

import defold.support.Script;

import defold.types.*;

import defold.types.Hash;
import defold.types.Vector3;

@:build(defold.support.MessageBuilder.build())
class AdvanceLayerMessage {
	var reset;
	var test;
	var catch_plate_trans;
}

typedef AdvanceLayerData = {
	// UNINITILIZED = -1
	// Topbun      = 0
	// RedStuff    = 1
	// Pattie      = 2
	// Lettuce     = 3
	// YellowStuff = 4
	// Bottumbun   = 5
	// FixedPlate  = 6
	@property(-1) var type:Int; // The type of bun
	var count:Int;
	var bounce:Bool;
	var isMultiple:Bool;
	var hchef:Hash;
	//
	var hcollisionGroup0:Hash;
	var hcollisionGroup1:Hash;
	var hcollisionGroup2:Hash;
	var hcollisionGroup3:Hash;
	//
	var bfallingOnOff:Bool;
	var _scrap_reg_string:String;
	var _scrap_reg_vector3:Vector3;
	//
	var tableFloor:lua.Table<Int, Hash>;
}

class AdvanceLayerScript extends Script<AdvanceLayerData> {
	final hFloor:Hash = hash('fixture'); // TODO research

	override function on_reload(self:AdvanceLayerData) {
		trace('Layer Type');
		super.on_reload(self);
	}

	//
	override function init(self:AdvanceLayerData) {
		//
		self.tableFloor = lua.Table.create();
		lua.Table.insert(self.tableFloor, hFloor);
		//
		self.bfallingOnOff = true;
		// Hashes
		self.hcollisionGroup0 = hash('trigcoll0');
		self.hcollisionGroup1 = hash('trigcoll1');
		self.hcollisionGroup2 = hash('trigcoll2');
		self.hcollisionGroup3 = hash('trigcoll3');

		self.hchef = hash('chef');
		//
		self.count = 0;
		self.bounce = false;
		self.isMultiple = true;
		lua.Lua.assert(self.type < 0, "Unitialized Layer");
		disable_full_layer(self);
	}

	override function update(self:AdvanceLayerData, dt:Float) {
		if (self.bfallingOnOff) {
			// TODO dle Stop Testing Here!!
			// final p = Go.get("/coll_advance_lettuce", "position");
			// Go.set("/coll_advance_lettuce", "position", p + vector3(0, -0.1, 0));
			// Raytracing
		}
	}

	override function on_message<T>(self:AdvanceLayerData, message_id:Message<T>, message:T, url:Url) {
		switch (message_id) {
			case AdvanceLayerMessage.test:
				trace('test called NOP');
			case AdvanceLayerMessage.reset:
				disable_full_layer(self);
				self.count = 0;
				//
				Msg.post("#coll0", GoMessages.enable);
				// Go.set_scale(Vmath.vector3(1, 0.5, 1), "#seg0");
				Msg.post("", SpriteProperties.scale, {message: Vmath.vector3(1, 1, 1)});
				Go.set("#seg1", "scale", Vmath.vectdor3(1, 1, 1));
				//
				Msg.post("#coll2", GoMessages.enable);
				Go.set("#seg2", "scale", Vmath.vector3(1, 1, 1));
				//
				Msg.post("#coll3", GoMessages.enable);
				Go.set("#seg3", "scale", Vmath.vector3(1, 1, 1));

			case AdvanceLayerMessage.catch_plate_trans:
				trace('catch plate trans');
			case PhysicsMessages.collision_response:
				if (message.other_group == self.hchef) {
					if (message.own_group == self.hcollisionGroup0) {
						Msg.post("#coll0", GoMessages.disable);
						Go.set_scale(Vmath.vector3(1, 0.5, 1), "#seg0");
						self.count++;
						if (self.count == 4) {
							// transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup1) {
						Msg.post("#coll1", GoMessages.disable);
						Go.set_scale(Vmath.vector3(1, 0.5, 1), "#seg1");
						self.count++;
						if (self.count == 4) {
							// transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup2) {
						Msg.post("#coll2", GoMessages.disable);
						Go.set_scale(Vmath.vector3(1, 0.5, 1), "#seg2");
						self.count++;
						if (self.count == 4) {
							// transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup3) {
						Msg.post("#coll3", GoMessages.disable);
						Go.set_scale(Vmath.vector3(1, 0.5, 1), "#seg3");
						self.count++;
						if (self.count == 4) {
							// transition_tofull(self);
						}
					}
				}
		}
	}

	function disable_full_layer(self:AdvanceLayerData):Void {
		Msg.post("#collf", GoMessages.disable);
		Msg.post("#segf", GoMessages.disable);
	}

	function enable_full_layer(self:AdvanceLayerData):Void {
		Msg.post("#collf", GoMessages.enable);
		Msg.post("#segf", GoMessages.enable);
	}

	function disable_segments(self:AdvanceLayerData):Void {
		//		trace('disable_segments');
		Msg.post("#coll0", GoMessages.disable);
		Msg.post("#coll1", GoMessages.disable);
		Msg.post("#coll2", GoMessages.disable);
		Msg.post("#coll3", GoMessages.disable);

		Msg.post("#seg0", GoMessages.disable);
		Msg.post("#seg1", GoMessages.disable);
		Msg.post("#seg2", GoMessages.disable);
		Msg.post("#seg3", GoMessages.disable);
	}

	function enable_segments(self:AdvanceLayerData):Void {
		trace('enable_segments');
		Msg.post("#coll0", GoMessages.enable);
		Msg.post("#coll1", GoMessages.enable);
		Msg.post("#coll2", GoMessages.enable);
		Msg.post("#coll3", GoMessages.enable);
	}

	private function transition_tofull(self:AdvanceLayerData):Void {
		// trace('transitioning to full');
		// enable_full_layer(self);
		// disable_segments(self);
		// /*
		// Topbun      = 0
		// RedStuff    = 1
		// Pattie      = 2
		// Lettuce     = 3
		// YellowStuff = 4
		// Bottumbun   = 5
		// final cBouncingDuration = 6.0;
		// final bounceDisplacements = 32.0;
		// final p = Go.get(COLSTRING0, "position");
		// self._scrap_reg_vector3 = p;
		// final to = p - vector3(0, -bounceDisplacements, 0);
		// Go.animate(COLSTRING0, "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
		// self._scrap_reg_string = COLSTRING0;
		// Timer.delay(3.0, false, stop_spin_callback);
	}

	private function stop_spin_callback(self:AdvanceLayerData, handle:TimerHandle, time_elapsed:Float) {
		// Go.animate("","","")
		trace("Security Collision advoidance completed Y3K"); // TODO dle testing callback functions in Defold.
		Go.cancel_animations(self._scrap_reg_string, "position");
		Go.set(self._scrap_reg_string, "position", self._scrap_reg_vector3);
	}

	private function reset_layer(self:AdvanceLayerData):Void {
		trace('reset_layer');
		disable_full_layer(self);
		enable_segments(self);
	}
}
