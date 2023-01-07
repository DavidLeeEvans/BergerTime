package gui;

import game.Loader.LoaderMessage;

using defold.Gui;

typedef ButtonGUIData = {}

class ButtonGUI extends defold.support.GuiScript<ButtonGUIData> {
	override function init(_) {
		Msg.post(".", GoMessages.acquire_input_focus);
		Gui.get_node("play").animate(GuiAnimateProprty.PROP_COLOR,1,EASING_INOUTSINE,1,0,null,PLAYBACK_LOOP_PINGPONG);
		Gui.get_node("settings").animate(GuiAnimateProprty.PROP_COLOR,1,EASING_INOUTSINE,1,0,null,PLAYBACK_LOOP_PINGPONG);
		Gui.get_node("exit").animate(GuiAnimateProprty.PROP_COLOR,1,EASING_INOUTSINE,1,0,null,PLAYBACK_LOOP_PINGPONG);
	}

	override function on_input<T>(_, action_id:Hash, action:ScriptOnInputAction) {
		if (action_id == hash("touch") && action.released) {
			var play_button = Gui.get_node("play");
			var setting_button = Gui.get_node("settings");
			var exit_button = Gui.get_node("exit");

			if (Gui.pick_node(play_button, action.x, action.y)) {
				//				trace('ButtonGUI.hx play_button');
				// Globals.random_game_level();
				Globals.set_game_level(5); // !!!!!! TODO remove only for testing dle
				Globals.set_prev_game_level(1); // FIX FOR CRASHES
				Msg.post("loader_coll:/loader#LoaderScript", LoaderMessage.disable_collection);
				Msg.post("loader_coll:/loader#LoaderScript", LoaderMessage.enable_collection);
			} else if (Gui.pick_node(setting_button, action.x, action.y)) {
				trace('ButtonGUI.hx setting_button');
				Globals.set_game_level(2); // TODO remove only for testing dle
				Globals.set_prev_game_level(1); // FIX FOR CRASHES
				Msg.post("loader_coll:/loader#LoaderScript", LoaderMessage.disable_collection);
				Msg.post("loader_coll:/loader#LoaderScript", LoaderMessage.enable_collection);
			} else if (Gui.pick_node(exit_button, action.x, action.y)) {
				trace('ButtonGUI.hx exit_button');
				Sys.exit(0);
			}
		}
		return true;
	}

	override function on_message<T>(self:ButtonGUIData, message_id:Message<T>, message:T, sender:Url) {
		switch (message_id) {
			case CollectionproxyMessages.proxy_loaded:
				trace("Collection loaded");
				Msg.post("menu#settings_proxy", CollectionproxyMessages.init);
				Msg.post("menu#settings_proxy", CollectionproxyMessages.enable);
		}
	}
}
