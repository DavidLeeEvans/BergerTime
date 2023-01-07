package gui;

import game.Loader.LoaderMessage;

using defold.Gui; // also apply gui methods as static extension to GuiNode

class MenuGUI extends defold.support.GuiScript<{}> {
	override function init(_) {
		trace('MenuGU.hx init func called');
		Msg.post(".", GoMessages.acquire_input_focus);
		Gui.get_node("play").animate(GuiAnimateProprty.PROP_COLOR, 1, EASING_INOUTSINE, 1, 0, null, PLAYBACK_LOOP_PINGPONG);
		Gui.get_node("settings").animate(GuiAnimateProprty.PROP_COLOR, 1, EASING_INOUTSINE, 1, 0, null, PLAYBACK_LOOP_PINGPONG);
		Gui.get_node("exit").animate(GuiAnimateProprty.PROP_COLOR, 1, EASING_INOUTSINE, 1, 0, null, PLAYBACK_LOOP_PINGPONG);
	}

	override function on_input<T>(_, action_id:Hash, action:ScriptOnInputAction) {
		if (action_id == hash("touch") && action.pressed) {
			trace('MenuGU.hx init func on_input');
			var play = Gui.get_node("play");
			var settings = Gui.get_node("settings");
			var exit_var = Gui.get_node("exit");
			if (play.pick_node(action.x, action.y)) {
				trace("MenuGUI.hx Play Game is started.");
				// Globals.random_game_level();
				// Msg.post("#LoaderScript",LoaderMessage.load_collection);
			} else if (settings.pick_node(action.x, action.y)) {
				trace('MenuGUI.hx settings');
			} else if (exit_var.pick_node(action.x, action.y)) {
				trace("MenuGUI.hx exit().");
				Sys.exit(0);
			}
		}
		// Consume all input until we're gone.
		return false;
	}
}
