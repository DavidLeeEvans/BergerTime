/**
 * File: SideBar.hx
 * For:sidebar.gui
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

package hud;

import Defold.hash;
import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.Sound;
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef SideBarData = {
	var r_level:GuiNode;
	var i_level:GuiNode;

	//
	var r_score:GuiNode;
	var i_score:GuiNode;
	//
	var r_option:GuiNode;
	var i_option:GuiNode;
	//
	var engine_live1:GuiNode;
	var engine_live2:GuiNode;
	var engine_live3:GuiNode;
	var breturn:GuiNode;
	//
	var level:Int;
	var score:Int;
	var options:Int;
}

class SideBar extends GuiScript<SideBarData> {
	override function init(self:SideBarData) {
		Msg.post(".", GoMessages.acquire_input_focus);
		final lang = SaveLoad.get_all_saved_data().lang;
		self.r_level = Gui.get_node('r_level');
		self.i_level = Gui.get_node('i_level');
		self.r_score = Gui.get_node('r_score');
		self.i_score = Gui.get_node('i_score');
		self.r_option = Gui.get_node('r_option');
		self.i_option = Gui.get_node('i_option');
		self.i_option = Gui.get_node('i_option');
		self.engine_live1 = Gui.get_node('live1');
		self.engine_live2 = Gui.get_node('live2');
		self.engine_live3 = Gui.get_node('live3');
		self.breturn = Gui.get_node('breturn');
	}

	override function update(self:SideBarData, dt:Float):Void {}

	override function on_input(self:SideBarData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch") && action.pressed) {
			if (Gui.pick_node(self.breturn, action.x, action.y)) {
				Sound.play('/sounds#click');
				final t_url:Url = Msg.url("default", "/go", "Main");
				final t_level = Tools.level_int_to_string(self.level, "/go#level"); // "/go#levelxx";
				Msg.post(t_url, MainMessages.remote_new_screen, {
					next: "/go#mainscreen",
					current: t_level
				});
			}
		}
		return false;
	}

	override function on_message<T>(self:SideBarData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case SideBarMessage.set_level:
				self.level = message.amount;
				Gui.set_text(self.i_level, Std.string(self.level));
			case SideBarMessage.set_lives:
				if (message.amount == 1) {
					Gui.set_enabled(self.engine_live1, true);
					Gui.set_enabled(self.engine_live2, false);
					Gui.set_enabled(self.engine_live3, false);
				} else if (message.amount == 2) {
					Gui.set_enabled(self.engine_live1, true);
					Gui.set_enabled(self.engine_live2, true);
					Gui.set_enabled(self.engine_live3, false);
				} else if (message.amount == 3) {
					Gui.set_enabled(self.engine_live1, true);
					Gui.set_enabled(self.engine_live2, true);
					Gui.set_enabled(self.engine_live3, true);
				}

			case SideBarMessage.set_options:
				self.options = message.amount;
				Gui.set_text(self.i_option, Std.string(self.options));

			case SideBarMessage.set_score:
				self.score = message.amount;
				Gui.set_text(self.i_score, Std.string(self.score));
		}
	}

	override function final_(self:SideBarData):Void {}

	override function on_reload(self:SideBarData):Void {}
}
