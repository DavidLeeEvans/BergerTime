package game;

import defold.Timer;

import defold.Vmath.vector3;

import defold.Physics;
import defold.types.*;

import defold.support.Script;

import defold.Msg;

import Defold.hash;

import defold.types.Hash;

import defold.Go;

import defold.types.Vector3;

import haxe.Log.trace as ltrace;

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
	var hcollisionGroup0:Hash;
	var hcollisionGroup1:Hash;
	var hcollisionGroup2:Hash;
	var hcollisionGroup3:Hash;
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
		if (self.type < 0)
			ltrace('Uninitialize Layer ');
		// Msg.post(".", AdvanceLayerMessage.test);
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
				var p:Vector3 = Go.get("gseg0", "position");
				p.y = p.y + 20;
				Go.set("gseg0", "position", p);
				//
				Msg.post("#coll1", GoMessages.enable);
				var p:Vector3 = Go.get("gseg1", "position");
				p.y = p.y + 20;
				Go.set("gseg1", "position", p);
				//
				Msg.post("#coll2", GoMessages.enable);
				var p:Vector3 = Go.get("gseg2", "position");
				p.y = p.y + 20;
				Go.set("gseg2", "position", p);
				//
				Msg.post("#coll3", GoMessages.enable);
				var p:Vector3 = Go.get("gseg3", "position");
				p.y = p.y + 20;
				Go.set("gseg3", "position", p);

			case AdvanceLayerMessage.catch_plate_trans:
				trace('catch plate trans');
			case PhysicsMessages.collision_response:
				if (message.other_group == self.hchef) {
					if (message.own_group == self.hcollisionGroup0) {
						Msg.post("#coll0", GoMessages.disable);
						var p:Vector3 = Go.get("gseg0", "position");
						p.y = p.y - 20;
						Go.set("gseg0", "position", p);
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
						}
						// TODO left off here Need to add Go object to sprite for movment
						// TODO need to set the rest of the layers like top bun Group & Mask
						// TODO Add the segments to a collection and see if messaging still works, then add images that move
					} else if (message.own_group == self.hcollisionGroup1) {
						// trace('part 1');
						Msg.post("#coll1", GoMessages.disable);
						var p:Vector3 = Go.get("gseg1", "position");
						p.y = p.y - 20;
						Go.set("gseg1", "position", p);
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup2) {
						// trace('part 2');
						Msg.post("#coll2", GoMessages.disable);
						var p:Vector3 = Go.get("gseg2", "position");
						p.y = p.y - 20;
						Go.set("gseg2", "position", p);
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup3) {
						// trace('part 3');
						Msg.post("#coll3", GoMessages.disable);
						var p:Vector3 = Go.get("gseg3", "position");
						p.y = p.y - 20;
						Go.set("gseg3", "position", p);
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
						}
					}
				}
		}
	}

	function disable_full_layer(self:AdvanceLayerData):Void {
		switch (self.type) {
			case 0:
				Msg.post("/coll_advance_topbun/topbun_full#collisionobject", GoMessages.disable);
				Msg.post("/coll_advance_topbun/topbun_full#sprite", GoMessages.disable);
			case 1:
				Msg.post("/coll_advance_redstuff/tomatoe_full#collisionobject", GoMessages.disable);
				Msg.post("/coll_advance_redstuff/tomatoe_full#sprite", GoMessages.disable);
			case 2:
				Msg.post("/coll_advance_pattie/pattie_full#collisionobject", GoMessages.disable);
				Msg.post("/coll_advance_pattie/pattie_full#sprite", GoMessages.disable);
			case 3:
				Msg.post("/coll_advance_lettuce/lettuce_full#collisionobject", GoMessages.disable);
				Msg.post("/coll_advance_lettuce/lettuce_full#sprite", GoMessages.disable);
			case 4:
				Msg.post("/coll_advance_yellowstuff/yellow_full#collisionobject", GoMessages.disable);
				Msg.post("/coll_advance_yellowstuff/yellow_full#sprite", GoMessages.disable);
			case 5:
				Msg.post("/coll_advance_bottombun/bottombun_full#collisionobject", GoMessages.disable);
				Msg.post("/coll_advance_bottombun/bottombun_full#sprite", GoMessages.disable);
		}
	}

	function enable_full_layer(self:AdvanceLayerData):Void {
		switch (self.type) {
			case 0:
				Msg.post("/coll_advance_topbun/topbun_full#collisionobject", GoMessages.enable);
				Msg.post("/coll_advance_topbun/topbun_full#sprite", GoMessages.enable);
			case 1:
				Msg.post("/coll_advance_redstuff/tomatoe_full#collisionobject", GoMessages.enable);
				Msg.post("/coll_advance_redstuff/tomatoe_full#sprite", GoMessages.enable);
			case 2:
				Msg.post("/coll_advance_pattie/pattie_full#collisionobject", GoMessages.enable);
				Msg.post("/coll_advance_pattie/pattie_full#sprite", GoMessages.enable);
			case 3:
				Msg.post("/coll_advance_lettuce/lettuce_full#collisionobject", GoMessages.enable);
				Msg.post("/coll_advance_lettuce/lettuce_full#sprite", GoMessages.enable);
			case 4:
				Msg.post("/coll_advance_yellowstuff/yellow_full#collisionobject", GoMessages.enable);
				Msg.post("/coll_advance_yellowstuff/yellow_full#sprite", GoMessages.enable);
			case 5:
				Msg.post("/coll_advance_bottombun/bottombun_full#collisionobject", GoMessages.enable);
				Msg.post("/coll_advance_bottombun/bottombun_full#sprite", GoMessages.enable);
		}
	}

	function disable_segments(self:AdvanceLayerData):Void {
		//		trace('disable_segments');
		Msg.post("#coll0", GoMessages.disable);
		Msg.post("#coll1", GoMessages.disable);
		Msg.post("#coll2", GoMessages.disable);
		Msg.post("#coll3", GoMessages.disable);
		var prefix:String = "";
		switch (self.type) {
			case 0:
				prefix = "/coll_advance_topbun";
			case 1:
				prefix = "/coll_advance_redstuff";
			case 2:
				prefix = "/coll_advance_pattie";
			case 3:
				prefix = "/coll_advance_lettuce";
			case 4:
				prefix = "/coll_advance_yellowstuff";
			case 5:
				prefix = "/coll_advance_bottombun";
		}
		Msg.post(prefix + "/gseg0#seg0", GoMessages.disable);
		Msg.post(prefix + "/gseg1#seg1", GoMessages.disable);
		Msg.post(prefix + "/gseg2#seg2", GoMessages.disable);
		Msg.post(prefix + "/gseg3#seg3", GoMessages.disable);
	}

	function enable_segments(self:AdvanceLayerData):Void {
		trace('enable_segments');
		Msg.post("#coll0", GoMessages.enable);
		Msg.post("#coll1", GoMessages.enable);
		Msg.post("#coll2", GoMessages.enable);
		Msg.post("#coll3", GoMessages.enable);
	}

	private function transition_tofull(self:AdvanceLayerData):Void {
		trace('transitioning to full');
		enable_full_layer(self);
		disable_segments(self);
		/*
			// Topbun      = 0
			// RedStuff    = 1
			// Pattie      = 2
			// Lettuce     = 3
			// YellowStuff = 4
			// Bottumbun   = 5
		 */
		final cBouncingDuration = 6.0;
		switch (self.type) {
			case 0:
				final bounceDisplacements = 32.0;
				final COLSTRING0:String = "/coll_advance_topbun/topbun_full";
				final p = Go.get(COLSTRING0, "position");
				self._scrap_reg_vector3 = p;
				final to = p - vector3(0, -bounceDisplacements, 0);
				Go.animate(COLSTRING0, "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
				self._scrap_reg_string = COLSTRING0;
				Timer.delay(3.0, false, stop_spin_callback);

			case 1:
				final bounceDisplacements = 32.0;
				final COLSTRING1:String = "/coll_advance_redstuff/tomatoe_full";
				final p = Go.get(COLSTRING1, "position");
				self._scrap_reg_vector3 = p;
				final to = p - vector3(0, -bounceDisplacements, 0);
				Go.animate(COLSTRING1, "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
				self._scrap_reg_string = COLSTRING1;
				Timer.delay(3.0, false, stop_spin_callback);

			case 2:
				final bounceDisplacements = 32.0;
				final COLSTRING2:String = "/coll_advance_pattie/pattie_full";
				final p = Go.get(COLSTRING2, "position");
				self._scrap_reg_vector3 = p;
				final to = p - vector3(0, -bounceDisplacements, 0);
				Go.animate(COLSTRING2, "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
				self._scrap_reg_string = COLSTRING2;
				Timer.delay(3.0, false, stop_spin_callback);

			case 3:
				final bounceDisplacements = 32.0;
				final COLSTRING3:String = "/coll_advance_lettuce/lettuce_full";
				final p = Go.get(COLSTRING3, "position");
				self._scrap_reg_vector3 = p;
				final to = p - vector3(0, -bounceDisplacements, 0);
				Go.animate(COLSTRING3, "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
				self._scrap_reg_string = COLSTRING3;
				Timer.delay(3.0, false, stop_spin_callback);
			case 4:
				final bounceDisplacements = 32.0;
				final COLSTRING4:String = "/coll_advance_yellowstuff/yellow_full";
				final p = Go.get(COLSTRING4, "position");
				self._scrap_reg_vector3 = p;
				final to = p - vector3(0, -bounceDisplacements, 0);
				Go.animate(COLSTRING4, "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
				self._scrap_reg_string = COLSTRING4;
				Timer.delay(3.0, false, stop_spin_callback);
			case 5:
				final bounceDisplacements = 32.0;
				final COLSTRING5:String = "/coll_advance_bottombun/bottombun_full";
				final p = Go.get(COLSTRING5, "position");
				self._scrap_reg_vector3 = p;
				final to = p - vector3(0, -bounceDisplacements, 0);
				Go.animate(COLSTRING5, "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
				self._scrap_reg_string = COLSTRING5;
				Timer.delay(3.0, false, stop_spin_callback);
		}
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
