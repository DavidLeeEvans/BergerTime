package game;

import Defold.hash;

import defold.Factory;
import defold.Go;
import defold.Msg;
import defold.Profiler;
import defold.Timer;

import defold.support.Script;
import defold.support.ScriptOnInputAction;

import defold.types.*;

import defold.types.Hash;

import dex.util.Rand;

import dle.AdmobMsg;
import dle.Delayer;

import dle.Ludobits.GestureMessage;

import haxe.Log.trace as ltrace;

import hud.GHud.GHudMessage;

import hud.HudGUI.HudGUIMessage;

import lua.Table;

import lua.lib.luasocket.Socket;

//
//
//

@:build(defold.support.MessageBuilder.build())
class BergerGameMessage {
	var game_start;
	var game_load:{level:Int};
	var game_over;
	var game_paused;
	var game_restart;
}

typedef BergerGameData = {
	var gameLevel:Int;
	@property(4) var num_hamburgers:Int;
	@property(6) var num_monsters:Int;
	@property(true) var spawn_monsters:Bool;
	@property(true) var spawn_treats:Bool;

	var finish_hamburger:Int;
	var spawn_position:Vector3;
	//
	var handleTimerTreats:TimerHandle;
	//
	var _scratchPad:Float;
	//
	var delayer:Delayer;
	var run_game:Bool;
	var level:Int;
	//
	var admob_banner_ad:String;
	var admob_interstitial_ad:String;
	var admob_rewardvideo_ad:String;
	//
	var _loaded:Bool;
}

class BergerGameScript extends Script<BergerGameData> {
	static final TREAT_SPAWNDELAY_UPPER:Float = 61.0;
	static final TREAT_SPAWNDELAY_LOWER:Float = 31.0;

	override function on_reload(self:BergerGameData) {
		trace('Game Script Reloaded started!! !');
		super.on_reload(self);
	}

	//
	override function init(self:BergerGameData) {
		// Ads
		var fps = 30;
		self.delayer = new Delayer(fps);

		self.admob_banner_ad = "ca-app-pub-8289938137729980/4461795085";
		self.admob_interstitial_ad = "ca-app-pub-8289938137729980/9851475726";
		self.admob_rewardvideo_ad = "ca-app-pub-8289938137729980/2631461250";
		Msg.post("/go#ads", AdmobMsg.load_banner, {ad_id: self.admob_banner_ad});
		Msg.post("/go#ads", AdmobMsg.load_interstitial, {ad_id: self.admob_interstitial_ad});
		Msg.post("/go#ads", AdmobMsg.load_reward_video, {ad_id: self.admob_rewardvideo_ad});

		self._loaded = false;
		ads_runner(self);

		self._scratchPad = lua.Math.random(20, 60);

		lua.Math.randomseed(1000000 * (Socket.gettime() % 1));
		lua.Math.randomseed(1000000 * (Socket.gettime() % 1));
		self.handleTimerTreats = Timer.delay(lua.Math.random(TREAT_SPAWNDELAY_LOWER, TREAT_SPAWNDELAY_UPPER), false, treate_create);
		//
		if (self.handleTimerTreats == Timer.INVALID_TIMER_HANDLE)
			ltrace("Invalide Timer Handle");
		lua.Lua.assert(self.handleTimerTreats != Timer.INVALID_TIMER_HANDLE, "Invalid Timer Handle");
		self.finish_hamburger = 0;
		Globals.total_num_current_monsters = 0;
		Globals.total_num_lives = 3;
		Msg.post('/go#hud', HudGUIMessage.set_lives, {lives: Globals.total_num_lives});
		//
		Msg.post(".", GoMessages.acquire_input_focus);
	}

	override function update(self:BergerGameData, dt:Float) {
		self.delayer.update(1.0);
		self._scratchPad--;
		if (Globals.total_num_current_monsters <= self.num_monsters && self._scratchPad < 0) {
			if (self.spawn_monsters)
				spawn_monster(self);
		}
	}

	// TODO Left here
	override function on_message<T>(self:BergerGameData, message_id:Message<T>, message:T, _) {
		switch (message_id) {
			case AdmobMsg.have_is_banner_loaded:
				Defold.pprint('have_banner_called_back MSG actionable ${message.name}');
				self._loaded = message.name;
			case GestureMessage.on_gesture:
				if (message.swipe_up) {
					Defold.pprint('message.swipe_up');
					Msg.post("/go#ghud", GHudMessage.sup);
					Msg.post("/chef#ChefEntity", GHudMessage.sup);
				} else if (message.swipe_left) {
					Defold.pprint('message.swipe_left');
					Msg.post("/go#ghud", GHudMessage.sleft);
					Msg.post("/chef#ChefEntity", GHudMessage.sleft);
				} else if (message.swipe_down) {
					Defold.pprint('message.swipe_down');
					Msg.post("/go#ghud", GHudMessage.sdown);
					Msg.post("/chef#ChefEntity", GHudMessage.sdown);
				} else if (message.swipe_right) {
					Defold.pprint('message.swipe_right');
					Msg.post("/go#ghud", GHudMessage.sright);
					Msg.post("/chef#ChefEntity", GHudMessage.sright);
				} else if (message.double_tap) {
					Defold.pprint('message double tap');
					Msg.post("/go#ghud", GHudMessage.double_tap);
					Msg.post("/chef#ChefEntity", GHudMessage.double_tap);
				} else if (message.tap) {
					Defold.pprint('message tap');
					Msg.post("/go#ghud", GHudMessage.tap);
					Msg.post("/chef#ChefEntity", GHudMessage.tap);
				}

			case BergerGameMessage.game_load:
				Globals.set_game_level(message.level);
			// spawn_entities(); TODO rework this into a global spawner.
			case BergerGameMessage.game_start:
				trace('game start');
			// TODO enable Systems
			case BergerGameMessage.game_paused:
				trace('game paused');
				Timer.cancel(self.handleTimerTreats);
			// TODO disable Systems
			case BergerGameMessage.game_restart:
				trace('game restart');
				self.handleTimerTreats = Timer.delay(lua.Math.random(TREAT_SPAWNDELAY_LOWER, TREAT_SPAWNDELAY_UPPER), false, treate_create);
				if (self.handleTimerTreats == Timer.INVALID_TIMER_HANDLE)
					ltrace("Invalide Timer Handle");
				lua.Lua.assert(self.handleTimerTreats != Timer.INVALID_TIMER_HANDLE, "Invalid Treat Handle");
			case BergerGameMessage.game_over:
				trace('game over');
				Timer.cancel(self.handleTimerTreats);
		}
	}

	override function on_input(self:BergerGameData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("debug_toggle") && action.released) {
			Globals.debug = !Globals.debug;
			if (Globals.debug) {
				Profiler.enable_ui(true);
			} else {
				Profiler.enable_ui(false);
			}
		}
		return false;
	}

	override function final_(self:BergerGameData):Void {
		Msg.post(".", GoMessages.release_input_focus);
		self.delayer.cancelEverything();
		Msg.post('/go#ads', AdmobMsg.destroy_banner);
	}

	private function treate_create(self:BergerGameData, _, _):Void {
		if (!self.spawn_treats)
			return;
		final treat:Int = lua.Math.floor(lua.Math.random(1, 4));
		final n = Rand.int(0, 3);
		var p = Go.get_world_position("/go#" + "spawn" + n);
		switch (treat) {
			case 1:
				Factory.create('#factory_treats_candy', p);
			case 2:
				Factory.create('#factory_treats_coffee', p);
			case 3:
				Factory.create('#factory_treats_icecream', p);
			case 4:
				// TODO	Factory.create('#factory_treats_fries', p);
		}
		// trace('treate_create Timer Fired type $treat created');
		self.handleTimerTreats = Timer.delay(lua.Math.random(TREAT_SPAWNDELAY_LOWER, TREAT_SPAWNDELAY_UPPER), false, treate_create);
		if (self.handleTimerTreats == Timer.INVALID_TIMER_HANDLE)
			ltrace("Invalide Timer Handle");
		lua.Lua.assert(self.handleTimerTreats != Timer.INVALID_TIMER_HANDLE, "Invalid Timer Handle");
	}

	private function spawn_monster(self:BergerGameData):Void {
		// trace('Spawning Monsters monster count is ${self.current_monsters} ${self.num_monsters}');
		Globals.total_num_current_monsters++;
		final start_number:Int = 1;
		final end_number:Int = 3;
		self._scratchPad = lua.Math.random(20, 60);
		var mtype:Int = lua.Math.floor(lua.Math.random(start_number, end_number));
		var p:Vector3;
		final n = Rand.int(0, 3);
		var p = Go.get_world_position("/spawn" + Std.string(n));
		switch (mtype) {
			case 1:
				Factory.create('#factory_eggs', p, null, Table.create({type: 0}));
			case 2:
				Factory.create('#factory_pickle', p, null, Table.create({type: 1}));
			case 3:
				Factory.create('#factory_sausages', p, null, Table.create({type: 2}));
		}
	}

	private function ads_runner(self:BergerGameData):Void {
		self.delayer.addS("load_ads", function() Msg.post('/go#ads', AdmobMsg.load_banner, {ad_id: self.admob_banner_ad}), 0);
		self.delayer.addS("show_ads", function() Msg.post('/go#ads', AdmobMsg.show_banner, {position: ADMOB_POSITION.POS_TOP_CENTER}), 10);
		self.delayer.addS("turnoff_ads", function() Msg.post('/go#ads', AdmobMsg.hide_banner), 60);
		self.delayer.addS("destroy_ads", function() Msg.post('/go#ads', AdmobMsg.destroy_banner), 61);
		self.delayer.addS("cancel_ads", function() self.delayer.cancelEverything, 62);
		self.delayer.addS("reset_ads", function() ads_runner(self), 63);
	}
}
