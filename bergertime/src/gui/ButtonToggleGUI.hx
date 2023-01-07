package gui;

import game.Loader.LoaderMessage;

import defold.Sound;

using defold.Gui; // also apply gui methods as static extension to GuiNode

class ButtonToggleGUI extends defold.support.GuiScript<{}> {
	var ctextMusicOn = "Music On";
	var ctextMusicOff = "Music Off";
	var ctextSoundOn = "Sound On";
	var ctextSoundOff = "Sound Off";

	override function init(_) {
		Msg.post(".", GoMessages.acquire_input_focus);
		music_set();
		sound_set();
	}

	override function on_input<T>(_, action_id:Hash, action:ScriptOnInputAction) {
		if (action_id == hash("touch") && action.released) {
			final music_button = Gui.get_node("music_button");
			final sound_button = Gui.get_node("sound_button");
			final abort_button = Gui.get_node("abort_button");

			if (Gui.pick_node(music_button, action.x, action.y)) {
				Globals.musicIsOn = !Globals.musicIsOn;
				music_set();
			} else if (Gui.pick_node(sound_button, action.x, action.y)) {
				Globals.soundIsOn = !Globals.soundIsOn;
				sound_set();
			} else if (Gui.pick_node(abort_button, action.x, action.y)) {
				Globals.set_game_level(1);
				Globals.set_prev_game_level(2);
				Msg.post("loader_coll:/loader#sound", SoundMessages.play_sound, {});
				Msg.post("loader_coll:/loader#LoaderScript", LoaderMessage.disable_collection);
				Msg.post("loader_coll:/loader#LoaderScript", LoaderMessage.enable_collection);
			}
		}
		return true;
	}

	private function music_set() {
		var music_text = Gui.get_node("music_text");
		Msg.post("loader_coll:/loader#sound", SoundMessages.play_sound, {});
		if (Globals.musicIsOn) {
			music_text.set_text(ctextMusicOn);
		} else {
			music_text.set_text(ctextMusicOff);
		}
		// TODO save music state
	}

	private function sound_set() {
		Msg.post("loader_coll:/loader#sound", SoundMessages.play_sound, {});

		var sound_text = Gui.get_node("sound_text");
		if (Globals.soundIsOn) {
			sound_text.set_text(ctextSoundOn);
		} else {
			sound_text.set_text(ctextSoundOff);
		}
		// TODO save sound state
	}
}
