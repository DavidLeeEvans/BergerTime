package ecs.s;

import eskimo.views.BufferView;
import eskimo.views.EventView;
import eskimo.views.View;

import eskimo.Context;

import eskimo.systems.System;
import eskimo.systems.SystemManager;

import ecs.c.MovementComponent;

using Lambda;

class SystemMovement extends System {
	var _c:Context;
	var _bv:BufferView;
	var _ev:EventView;
	var _v:View;

	public static var SystemTag = "movement_family";

	public function new(c:Context) {
		super();
		_c = c;
		_bv = new BufferView([MovementComponent], null, _c.entities);
		_ev = new EventView([MovementComponent], _c.entities);
		_v = new View([MovementComponent], null, _c.entities);
	}

	override public function onActivate(systems:SystemManager):Void {
		trace('$SystemTag is being added.');
	}

	override public function onUpdate(dt:Float):Void {
		if (_ev.added.length == 0)
			return;
		trace('$SystemTag is being updated.');
		// Example var gc = ev.get(GravityComponent); //
	}

	override public function onDeactivate(systems:SystemManager):Void {
		trace('$SystemTag is being removed.');
	}
}
