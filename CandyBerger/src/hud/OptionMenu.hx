/**
 * File: OptionMenu.hx
 * For: mainscreen
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
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Url;
import widgets.WidgetMessages;

@:build(defold.support.HashBuilder.build())
class OptionMenuHash {
	var blank;
	var no_sign;
}

private typedef OptionMenuData = {
	var bmusic:GuiNode;
	var bsound:GuiNode;
	var blanguage:GuiNode;
	var breturn:GuiNode;
	var brecycle:GuiNode;
	//
	var no_music:GuiNode;
	var no_sound:GuiNode;
	var bno_music:Bool;
	var bno_sound:Bool;
}

class OptionMenu extends GuiScript<OptionMenuData> {
	override function init(self:OptionMenuData) {
		Msg.post(".", GoMessages.acquire_input_focus);
		final lang = SaveLoad.get_all_saved_data().lang;
		self.no_music = Gui.get_node("no_music");
		self.no_sound = Gui.get_node("no_sound");
		self.bsound = Gui.get_node("bsound");
		self.bmusic = Gui.get_node("bmusic");
		self.blanguage = Gui.get_node("blanguage");
		self.breturn = Gui.get_node("breturn");
		self.brecycle = Gui.get_node("brecycle");
		//
		final data_beam = SaveLoad.get_all_saved_data();
		if (data_beam.music == 0) {
			self.bno_music = false;
		} else {
			self.bno_music = true;
		}
		if (self.bno_music) {
			Gui.play_flipbook(self.no_music, OptionMenuHash.no_sign);
		} else {
			Gui.play_flipbook(self.no_music, OptionMenuHash.blank);
		}
		if (data_beam.sound == 0) {
			self.bno_sound = false;
		} else {
			self.bno_sound = true;
		}
		if (self.bno_sound) {
			Gui.play_flipbook(self.no_sound, OptionMenuHash.no_sign);
		} else {
			Gui.play_flipbook(self.no_sound, OptionMenuHash.blank);
		}
	}

	// TODO set icons and booleans to correct representation use init
	override function update(self:OptionMenuData, dt:Float):Void {}

	override function on_input(self:OptionMenuData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch") && action.pressed) {
			final config = SaveLoad.get_all_saved_data();
			if (Gui.pick_node(self.bmusic, action.x, action.y)) {
				Sound.play('/sounds#click');
				self.bno_music = !self.bno_music;
				if (self.bno_music) {
					config.music = 0;
					SaveLoad.save_all_data(config);
					Gui.play_flipbook(self.no_music, OptionMenuHash.blank);
				} else {
					config.music = 5;
					SaveLoad.save_all_data(config);
					Gui.play_flipbook(self.no_music, OptionMenuHash.no_sign);
				}
			} else if (Gui.pick_node(self.bsound, action.x, action.y)) {
				self.bno_sound = !self.bno_sound;
				if (self.bno_sound) {
					config.sound = 0;
					SaveLoad.save_all_data(config);
					Gui.play_flipbook(self.no_sound, OptionMenuHash.blank);
				} else {
					config.sound = 5;
					SaveLoad.save_all_data(config);
					Gui.play_flipbook(self.no_sound, OptionMenuHash.no_sign);
				}
				Sound.play('/sounds#click');
			} else if (Gui.pick_node(self.blanguage, action.x, action.y)) {
				Sound.play('/sounds#click');
				final t_url = Msg.url("default", "/go", "Main");
				Msg.post(t_url, MainMessages.remote_new_screen, {next: "/go#language", current: "/go#optionmenu"});
			} else if (Gui.pick_node(self.breturn, action.x, action.y)) {
				Sound.play('/sounds#click');
				final t_url:Url = Msg.url("default", "/go", "Main");
				Msg.post(t_url, MainMessages.remote_new_screen, {next: "/go#mainscreen", current: "/go#optionmenu"});
			} else if (Gui.pick_node(self.brecycle, action.x, action.y)) {
				Sound.play('/sounds#click');
				Msg.post("/go#WidgetRUSure", WidgetMessages.on_screen);
			}
		}
		return false;
	}

	override function final_(_) {
		Msg.post(".", GoMessages.release_input_focus);
	}
}
