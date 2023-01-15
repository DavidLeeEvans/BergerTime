package ecs.s;

import defold.Go;
import defold.Msg;
import defold.Render;

import ecs.c.StatisticsComponent;

import eskimo.Context;

import eskimo.systems.System;
import eskimo.systems.SystemManager;

import eskimo.views.BufferView;
import eskimo.views.EventView;
import eskimo.views.View;

using Lambda;

class SystemStatistic extends System {
	var _c:Context;
	var _bv:BufferView;
	var _ev:EventView;
	var _v:View;

	public static var SystemTag = "statistic_family";

	public function new(c:Context) {
		super();
		_c = c;
		_bv = new BufferView([StatisticsComponent], null, _c.entities);
		_ev = new EventView([StatisticsComponent], _c.entities);
		_v = new View([StatisticsComponent], null, _c.entities);
	}

	override public function onActivate(systems:SystemManager):Void {
		trace('$SystemTag is being added.');
	}

	override public function onUpdate(dt:Float):Void {
		if (_ev.added.length == 0)
			return;
		for (ev in _ev.entities) {
			var s = ev.get(StatisticsComponent);
			var wp = Go.get_world_position(s.id);
			lua.Lua.assert(wp != null, "wp is null");
			// Example var gc = ev.get(GravityComponent); //
			//			trace('world position ');pprint(wp);
			var lp = Go.get_position(s.id);
			lua.Lua.assert(lp != null, "lp is null");
			//			trace('local position ');pprint(lp);
			Msg.post("@render:", RenderMessages.draw_text, {text: Std.string(s.id), position: lp});
		}
	}

	override public function onDeactivate(systems:SystemManager):Void {
		trace('$SystemTag is being removed.');
	}
}
