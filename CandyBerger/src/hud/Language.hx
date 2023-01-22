/**
 * File: Language.hx
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
import defold.Timer;
import defold.Vmath;
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef LanguageData = {
	var ben:GuiNode;
	var bfr:GuiNode;
	var bml:GuiNode;
	var bch:GuiNode;
	var bru:GuiNode;
	var buk:GuiNode;
	var bsv:GuiNode;
	var breturn:GuiNode;
}

class Language extends GuiScript<LanguageData> {
	override function init(self:LanguageData):Void {
		Msg.post(".", GoMessages.acquire_input_focus);
		self.ben = Gui.get_node('ben');
		self.bfr = Gui.get_node('bfr');
		self.bml = Gui.get_node('bml');
		self.bch = Gui.get_node('bch');
		self.bru = Gui.get_node('bru');
		self.buk = Gui.get_node('buk');
		self.bsv = Gui.get_node('bsv');
		self.breturn = Gui.get_node('breturn');
	}

	override function on_input(self:LanguageData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch") && action.pressed) {
			if (Gui.pick_node(self.ben, action.x, action.y)) {
				Sound.play('/sounds#click');
				set_display_isabella(self, "en");
			} else if (Gui.pick_node(self.bfr, action.x, action.y)) {
				Sound.play('/sounds#click');
				set_display_isabella(self, "fr");
			} else if (Gui.pick_node(self.bml, action.x, action.y)) {
				Sound.play('/sounds#click');
				set_display_isabella(self, "ml");
			} else if (Gui.pick_node(self.bch, action.x, action.y)) {
				Sound.play('/sounds#click');
				set_display_isabella(self, "ch");
			} else if (Gui.pick_node(self.bru, action.x, action.y)) {
				Sound.play('/sounds#click');
				set_display_isabella(self, "ru");
			} else if (Gui.pick_node(self.buk, action.x, action.y)) {
				Sound.play('/sounds#click');
				set_display_isabella(self, "uk");
			} else if (Gui.pick_node(self.bsv, action.x, action.y)) {
				Sound.play('/sounds#click');
				set_display_isabella(self, "sv");
			} else if (Gui.pick_node(self.breturn, action.x, action.y)) {
				Sound.play('/sounds#click');
				final t_url = Msg.url("default", "/go", "Main");
				Msg.post(t_url, MainMessages.remote_new_screen, {next: "/go#optionmenu", current: "/go#language"});
			}
		}
		return false;
	}

	override function update(self:LanguageData, dt:Float):Void {}

	override function on_message<T>(self:LanguageData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case LanguageMessage.have_lang:
				// if (message.lang == "")
		}
	}

	override function final_(_):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	override function on_reload(self:LanguageData):Void {}

	private function set_display_isabella(self:LanguageData, hud:String):Void {
		Gui.set_color(Gui.get_node(hud), Vmath.vector3(1, 0, 0));
		Timer.delay(1.8, false, function(_, _, _) {
			final t_url = Msg.url("default", "/go", "Main");
			Msg.post(t_url, LanguageMessage.set_lang, {lang: hud});
			Msg.post(t_url, MainMessages.remote_new_screen, {next: "/go#optionmenu", current: "/go#language"});
		});
	}
}
