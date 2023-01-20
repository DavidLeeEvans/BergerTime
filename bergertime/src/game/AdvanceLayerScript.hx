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
	var _scrap_reg_vector3:Vector3;
	//
	var tableFloor:lua.Table<Int, Hash>;
}

class AdvanceLayerScript extends Script<AdvanceLayerData> {
	final _layerArray = [
		["top-bun0", "top-bun1", "top-bun2", "top-bun3", "top-bun"],
		["redstuff0", "redstuff1", "redstuff2", "redstuff3", "redstuff"],
		["meat0", "meat1", "meat2", "meat3", "meat"],
		["lettuce0", "lettuce1", "lettuce2", "lettuce3", "lettuce"],
		["yellowstuff0", "yellowstuff1", "yellowstuff2", "yellowstuff3", "yellowstuff"],
		["bottom-bun0", "bottom-bun1", "bottom-bun2", "bottom-bun3", "bottom-bun"],
	];
	final hFloor:Hash = hash('fixture'); // TODO research

	override function on_reload(self:AdvanceLayerData) {
		trace('Layer Type');
		super.on_reload(self);
	}

	//
	override function init(self:AdvanceLayerData) {
		lua.Lua.assert(self.type >= 0, "Unitialized Layer");
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
		enable_segments(self);
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
				Msg.post("#coll0", GoMessages.enable);
				Sprite.play_flipbook("#seg0", hash(_layerArray[self.type][0]));
				Msg.post("#coll1", GoMessages.enable);
				Sprite.play_flipbook("#seg1", hash(_layerArray[self.type][1]));
				Msg.post("#coll2", GoMessages.enable);
				Sprite.play_flipbook("#seg2", hash(_layerArray[self.type][2]));
				Msg.post("#coll3", GoMessages.enable);
				Sprite.play_flipbook("#seg3", hash(_layerArray[self.type][3]));
			case AdvanceLayerMessage.catch_plate_trans:
				trace('catch plate trans');
			case PhysicsMessages.collision_response:
				if (message.other_group == self.hchef) {
					if (message.own_group == self.hcollisionGroup0) {
						Msg.post("#coll0", GoMessages.disable);
						Sprite.play_flipbook("#seg0", hash("t" + _layerArray[self.type][0]));
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup1) {
						Msg.post("#coll1", GoMessages.disable);
						Sprite.play_flipbook("#seg1", hash("t" + _layerArray[self.type][1]));
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup2) {
						Msg.post("#coll2", GoMessages.disable);
						Sprite.play_flipbook("#seg2", hash("t" + _layerArray[self.type][2]));
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
						}
					} else if (message.own_group == self.hcollisionGroup3) {
						Msg.post("#coll3", GoMessages.disable);
						Sprite.play_flipbook("#seg3", hash("t" + _layerArray[self.type][3]));
						self.count++;
						if (self.count == 4) {
							transition_tofull(self);
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
		Sprite.play_flipbook("#segf", hash(_layerArray[self.type][4]));
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
		Sprite.play_flipbook("#seg0", hash(_layerArray[self.type][0]));
		Sprite.play_flipbook("#seg1", hash(_layerArray[self.type][1]));
		Sprite.play_flipbook("#seg2", hash(_layerArray[self.type][2]));
		Sprite.play_flipbook("#seg3", hash(_layerArray[self.type][3]));
	}

	private function transition_tofull(self:AdvanceLayerData):Void {
		trace('transitioning to full');
		enable_full_layer(self);
		disable_segments(self);
		// Topbun      = 0
		// RedStuff    = 1
		// Pattie      = 2
		// Lettuce     = 3
		// YellowStuff = 4
		// Bottumbun   = 5

		final cBouncingDuration = 6.0;
		final bounceDisplacements = 32.0;
		final p = Go.get_position();
		self._scrap_reg_vector3 = p;
		final to = p - Vmath.vector3(0, -bounceDisplacements, 0);
		Go.animate(".", "position", GoPlayback.PLAYBACK_LOOP_PINGPONG, to, GoEasing.EASING_INBOUNCE, cBouncingDuration, 0);
		Timer.delay(3.0, false, stop_spin_callback);
	}

	private function stop_spin_callback(self:AdvanceLayerData, handle:TimerHandle, time_elapsed:Float) {
		Go.cancel_animations(".", "position");
		Go.set(".", "position", self._scrap_reg_vector3);
	}

	private function reset_layer(self:AdvanceLayerData):Void {
		trace('reset_layer');
		disable_full_layer(self);
		enable_segments(self);
	}
}
