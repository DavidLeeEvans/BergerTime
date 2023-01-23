package hud;

import defold.Go.GoMessages;

import defold.support.GuiScript;

import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

@:build(defold.support.HashBuilder.build())
class GHudHash {
	var down;
	var up;
	var turn_up;
	var turn_down;
	var left;
	var right;
	var idle;
}

private typedef GHudData = {
	var current_display:Hash;
}

class GHud extends GuiScript<GHudData> {
	override function init(self:GHudData) {}

	override function update(self:GHudData, dt:Float):Void {}

	override function on_message<T>(self:GHudData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:GHudData):Void {}

	override function on_reload(self:GHudData):Void {}
}
