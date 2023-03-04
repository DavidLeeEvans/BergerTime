package hud;

import defold.Gui;

import defold.support.GuiScript;

import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

@:build(defold.support.MessageBuilder.build())
class GHudMessage {
	var sleft;
	var sdown;
	var sup;
	var sright;
	var sup_left;
	var sup_right;
	var sdown_left;
	var sdown_right;
	var idle;
	var sstap;
}

@:build(defold.support.HashBuilder.build())
class GHudHash {
	var down;
	var up;
	var up_turn_left;
	var up_turn_right;
	var down_turn_left;
	var down_turn_right;
	var left;
	var right;
	var idle;
}

private typedef GHudData = {
	var sindex:Bool; // true current, false next
	var current_display:Hash;
	var dnode:GuiNode;
}

class GHud extends GuiScript<GHudData> {
	override function init(self:GHudData) {
		self.sindex = true;
		self.dnode = Gui.get_node("display");
		self.current_display = GHudHash.idle;
	}

	override function update(self:GHudData, dt:Float):Void {}

	override function on_message<T>(self:GHudData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case GHudMessage.sright:
				Gui.play_flipbook(self.dnode, GHudHash.right);

			case GHudMessage.sdown:
				Gui.play_flipbook(self.dnode, GHudHash.down);

			case GHudMessage.sleft:
				Gui.play_flipbook(self.dnode, GHudHash.left);

			case GHudMessage.sup:
				Gui.play_flipbook(self.dnode, GHudHash.up);

			case GHudMessage.sdown_left:
				Gui.play_flipbook(self.dnode, GHudHash.down_turn_left);

			case GHudMessage.sdown_right:
				Gui.play_flipbook(self.dnode, GHudHash.down_turn_right);

			case GHudMessage.sup_left:
				Gui.play_flipbook(self.dnode, GHudHash.up_turn_left);

			case GHudMessage.sup_right:
				Gui.play_flipbook(self.dnode, GHudHash.up_turn_right);

			case GHudMessage.idle:
				Gui.play_flipbook(self.dnode, GHudHash.idle);
		}
	}

	override function final_(self:GHudData):Void {}

	override function on_reload(self:GHudData):Void {}
}
