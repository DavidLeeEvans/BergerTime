package game;

import hud.HudGUI.HudGUIMessage;
import entities.EnemyEntity.EnemyMessage;

import lua.lib.luasocket.Socket;

import defold.Factory;
import defold.Timer;

import ecs.s.SystemGravity;
import defold.Profiler;

import haxe.Log.trace as ltrace;

//
import defold.Vmath.vector3;

//
import defold.types.*;

import defold.support.Script;
import defold.support.ScriptOnInputAction;

import Defold.hash;

import defold.Go.GoMessages;

import defold.Msg;

import defold.types.Hash;

import Assertion;

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

	var finish_hamburger:Int;
	var spawn_position:Vector3;
	//
	var handleTimerTreats:TimerHandle;
	//
	var _scratchPad:Float;
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
		self._scratchPad = lua.Math.random(20, 60);

		lua.Math.randomseed(1000000 * (Socket.gettime() % 1));
		self.handleTimerTreats = Timer.delay(lua.Math.random(TREAT_SPAWNDELAY_LOWER, TREAT_SPAWNDELAY_UPPER), false, treate_create);
		//
		if (self.handleTimerTreats == Timer.INVALID_TIMER_HANDLE)
			ltrace("Invalide Timer Handle");
		Assertion.assert(self.handleTimerTreats != Timer.INVALID_TIMER_HANDLE);
		self.finish_hamburger = 0;
		Globals.total_num_current_monsters = 0;
		Globals.total_num_lives = 3;
		Msg.post('/go#hud', HudGUIMessage.set_lives, {lives: Globals.total_num_lives});
		//
		final sgrav = new SystemGravity(Globals.context);
		Globals.systems.add(sgrav);
		Msg.post(".", GoMessages.acquire_input_focus);
	}

	override function update(self:BergerGameData, dt:Float) {
		//
		Globals.systems.update(dt);
		self._scratchPad--;
		if (Globals.total_num_current_monsters <= self.num_monsters && self._scratchPad < 0) {
			// Timer.delay(3.0, false, spawn_monster);
			spawn_monster(self);
		}
	}

	override function on_message<T>(self:BergerGameData, message_id:Message<T>, message:T, _) {
		switch (message_id) {
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
				Assertion.assert(self.handleTimerTreats != Timer.INVALID_TIMER_HANDLE);
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

	private function treate_create(self:BergerGameData, _, _):Void {
		final treat:Int = lua.Math.floor(lua.Math.random(1, 4));
		final p = vector3(99, 61, 0);
		switch (treat) {
			case 1:
				Factory.create('#factory_treats_candy', p);
			case 2:
				Factory.create('#factory_treats_coffee', p);
			case 3:
				Factory.create('#factory_treats_icecream', p);
			case 4:
				Factory.create('#factory_treats_fries', p);
		}
		// trace('treate_create Timer Fired type $treat created');
		self.handleTimerTreats = Timer.delay(lua.Math.random(TREAT_SPAWNDELAY_LOWER, TREAT_SPAWNDELAY_UPPER), false, treate_create);
		if (self.handleTimerTreats == Timer.INVALID_TIMER_HANDLE)
			ltrace("Invalide Timer Handle");
		Assertion.assert(self.handleTimerTreats != Timer.INVALID_TIMER_HANDLE);
	}

	private function spawn_monster(self:BergerGameData):Void {
		// trace('Spawning Monsters monster count is ${self.current_monsters} ${self.num_monsters}');
		Globals.total_num_current_monsters++;
		final start_number:Int = 1;
		final end_number:Int = 3;
		self._scratchPad = lua.Math.random(20, 60);
		var mtype:Int = lua.Math.floor(lua.Math.random(start_number, end_number));
		var p:Vector3;
		if (lua.Math.random(0, 1) > 0.5)
			p = vector3(161, 640, 0) // LEFT
		else
			p = vector3(161, 640, 0); // RIGHT
		switch (mtype) {
			case 1:
				Msg.post(Factory.create('#factory_eggs', p), EnemyMessage.msg_init, {type: 0});
			case 2:
				Msg.post(Factory.create('#factory_pickle', p), EnemyMessage.msg_init, {type: 1});
			case 3:
				Msg.post(Factory.create('#factory_sausages', p), EnemyMessage.msg_init, {type: 2});
		}
	}
}