package hud;

import defold.Gui;
import defold.Msg;

import defold.support.GuiScript;

import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

@:build(defold.support.MessageBuilder.build())
class GHudMessage {
	var sleft;
	var sdown;
	var sright;
	var sup;
	var double_tap;
	var tap;
}

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

// 0 idle
// 1 right
// 2 down
// 3 left
// 4 up
private typedef GHudData = {
	var sindex:Bool; // true current, false next
	var display_current:Int;
	var display_next:Int;
	var current_display:Hash;
	var dnode:GuiNode;
}

class GHud extends GuiScript<GHudData> {
	override function init(self:GHudData) {
		self.sindex = true;
		self.dnode = Gui.get_node("display");
		self.current_display = GHudHash.idle;
		self.display_current = 0;
		Msg.post("#", GHudMessage.tap);
	}

	override function update(self:GHudData, dt:Float):Void {}

	override function on_message<T>(self:GHudData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case GHudMessage.sright:
				Gui.play_flipbook(self.dnode, GHudHash.right);
				self.display_current = 1;

			case GHudMessage.sdown:
				Gui.play_flipbook(self.dnode, GHudHash.down);
				self.display_current = 2;

			case GHudMessage.sleft:
				Gui.play_flipbook(self.dnode, GHudHash.left);
				self.display_current = 3;

			case GHudMessage.sup:
				Gui.play_flipbook(self.dnode, GHudHash.up);
				self.display_current = 4;

			case GHudMessage.tap:
				Gui.play_flipbook(self.dnode, GHudHash.idle);
				self.display_current = 0;

			case GHudMessage.double_tap:
		}
	}

	override function final_(self:GHudData):Void {}

	override function on_reload(self:GHudData):Void {}
}
