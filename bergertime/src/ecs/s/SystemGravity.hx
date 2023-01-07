package ecs.s;


import defold.Go;

import eskimo.views.BufferView;
import eskimo.views.EventView;
import eskimo.views.View;

import eskimo.Context;

import ecs.c.GravityComponent;

import eskimo.systems.System;
import eskimo.systems.SystemManager;

import Defold.pprint;

using Lambda;

class SystemGravity extends System {
	var _c:Context;
	var _bv:BufferView;
	var _ev:EventView;
	var _v:View;

	public static var SystemTag = "gravity_family";

	public function new(c:Context) {
		super();
		_c = c;
		_bv = new BufferView([GravityComponent], null, _c.entities);
		_ev = new EventView([GravityComponent], _c.entities);
		_v = new View([GravityComponent], null, _c.entities);
	}

	override public function onActivate(systems:SystemManager):Void {
		trace('$SystemTag is being added.');
	}

	override public function onUpdate(dt:Float):Void {
		if (_ev.added.length == 0)
			return;
		// trace('$SystemTag is being updated.');
		for (ev in _ev.entities) {
			final gc:GravityComponent = ev.get(GravityComponent); //
			if (gc.notOnGround) {
				var p = Go.get_position(gc.id);
				Go.set_position(p + gc.gravity, gc.id);
			}
		}
	}

	override public function onDeactivate(systems:SystemManager):Void {
		trace('$SystemTag is being removed.');
	}
}
