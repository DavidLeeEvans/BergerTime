package gui;

using defold.Gui; // also apply gui methods as static extension to GuiNode

@:build(defold.support.MessageBuilder.build())
class SettingMessages {
	var off;
	var on;
}

class Settings extends defold.support.GuiScript<{}> {
	override function on_message<T>(_, message_id:Message<T>, message:T, _) {
		switch (message_id) {
			case SettingMessages.off:
				Msg.post("#", GoMessages.disable);
				Msg.post(".", GoMessages.release_input_focus);
			case SettingMessages.on:
				Msg.post("#", GoMessages.enable);
				Msg.post(".", GoMessages.acquire_input_focus);
		}
	}

	override function on_input(_, action_id:Hash, action:ScriptOnInputAction) {
		if (action_id == hash("touch") && action.pressed) {
			var yes = Gui.get_node("yes");
			var no = Gui.get_node("no");
			var quit = Gui.get_node("quit");

			if (no.pick_node(action.x, action.y)) {
				Msg.post("#", SettingMessages.off);
			} else if (yes.pick_node(action.x, action.y)) {
				Msg.post("board:/board#script", Messages.restart_level);
				Msg.post("#", SettingMessages.off);
			} else if (quit.pick_node(action.x, action.y)) {
				Msg.post("main:/main#script", Messages.to_main_menu);
			}
		}
		return true; // Consume all input until we're gone.
	}
}
