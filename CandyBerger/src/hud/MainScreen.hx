/**
 * File: MainScreen.hx
 * For: 
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

package hud;

import Defold.hash;
import defold.Go.GoMessages;
import defold.Gui;
import defold.Msg;
import defold.Sound;
import defold.Vmath;
import defold.Window;
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef MainScreenData = {
	var panel:GuiNode;
	//
	var bplay:GuiNode;
	var bscore:GuiNode;
	var boptions:GuiNode;
	// Text labels
	var play:GuiNode;
	var score:GuiNode;
	var options:GuiNode;
	//
	var bquit:GuiNode;
}

class MainScreen extends GuiScript<MainScreenData> {
	override function init(self:MainScreenData):Void {
		Msg.post(".", GoMessages.acquire_input_focus);
		self.panel = Gui.get_node("panel");
		final WS:WindowSize = Window.get_size();
		// Defold.pprint(WS);
		Gui.set_scale(self.panel, Vmath.vector3(WS.width / 600, WS.height / 460, 0)); // 1.7, 1.4
		// Defold.pprint('xscale = ${WS.width / 600} yscale = ${WS.height / 460}');

		final lang = SaveLoad.get_all_saved_data().lang;
		self.bplay = Gui.get_node('bplay');
		self.bscore = Gui.get_node('bscore');
		self.boptions = Gui.get_node('boptions');
		// Text labels
		self.play = Gui.get_node('play');
		self.score = Gui.get_node('score');
		self.options = Gui.get_node('options');
		Gui.set_text(self.play, Tools.translate_text(lang, Gui.get_text(self.play)));
		Gui.set_text(self.score, Tools.translate_text(lang, Gui.get_text(self.score)));
		Gui.set_text(self.options, Tools.translate_text(lang, Gui.get_text(self.options)));
		self.bquit = Gui.get_node('bquit');
	}

	override function on_input(self:MainScreenData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch") && action.pressed) {
			if (Gui.pick_node(self.bplay, action.x, action.y)) {
				// trace('Play');
				Sound.play('/sounds#click');
				final t_url = Msg.url("default", "/go", "Main");
				final i_level:Int = SaveLoad.get_all_saved_data().game_level;
				final s_level:String = Tools.level_int_to_string(i_level, "/go#fac_l");
				Msg.post(t_url, MainMessages.remote_new_screen, {next: s_level, current: "/go#mainscreen"});
			} else if (Gui.pick_node(self.bscore, action.x, action.y)) {
				trace('Score');
				Sound.play('/sounds#click');
			} else if (Gui.pick_node(self.boptions, action.x, action.y)) {
				trace('Options');
				Sound.play('/sounds#click');
				final t_url = Msg.url("default", "/go", "Main");
				Msg.post(t_url, MainMessages.remote_new_screen, {next: "/go#optionmenu", current: "/go#mainscreen"});
			} else if (Gui.pick_node(self.bquit, action.x, action.y)) {
				Sound.play('/sounds#click');
				defold.Sys.exit(0);
			}
		}
		return false;
	}

	override function update(self:MainScreenData, dt:Float):Void {}

	override function on_message<T>(self:MainScreenData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(_):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	override function on_reload(self:MainScreenData):Void {
		trace("MainScreen reloaded!!!");
		final WS:WindowSize = Window.get_size();
		Defold.pprint(WS);
		Gui.set_scale(self.panel, Vmath.vector3(WS.width / 600, WS.height / 460, 0)); // 1.7, 1.4
		// Gui.set_scale(self.panel, Vmath.vector3(1.7, 1.4, 0)); // 1.7, 1.4
		Defold.pprint('xscale = ${WS.width / 600} yscale = ${WS.height / 460}');
	}
}
