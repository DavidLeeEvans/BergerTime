package ecs.s;

import defold.types.Url;

import defold.Render;
import defold.Msg;
import defold.Go;

import eskimo.views.BufferView;
import eskimo.views.EventView;
import eskimo.views.View;

import eskimo.Context;

import eskimo.systems.System;
import eskimo.systems.SystemManager;

import ecs.c.StatisticsComponent;

import defold.Vmath;

import Defold.pprint;

import Assertion;

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
			Assertion.assert(wp != null);
			// Example var gc = ev.get(GravityComponent); //
			//			trace('world position ');pprint(wp);
			var lp = Go.get_position(s.id);
			Assertion.assert(lp != null);
			//			trace('local position ');pprint(lp);
			Msg.post("@render:", RenderMessages.draw_text, {text: Std.string(s.id), position: lp});
		}
	}

	override public function onDeactivate(systems:SystemManager):Void {
		trace('$SystemTag is being removed.');
	}
}
