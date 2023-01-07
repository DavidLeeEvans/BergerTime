import defold.Go;
import defold.Msg;
import defold.Particlefx;
import defold.Collectionproxy;

import defold.types.Message;
import defold.types.Url;

typedef MainData = {
	var state:MainState;
}

@:enum abstract MainState(String) {
	var MAIN_MENU = "MAIN_MENU";
	var EXIT_MENU = "EXIT_MENU";
	var SETTINGS_MENU = "SETTINGS_MENU";
	var GAME_RUNNING = "GAME_RUNNING";
}

class Main extends defold.support.Script<MainData> {
	override function init(self:MainData) {
		Msg.post("#", Messages.to_main_menu);
		self.state = MAIN_MENU;
		Particlefx.play("#particlefx");
	}

	override function on_message<T>(self:MainData, message_id:Message<T>, message:T, sender:Url) {
		switch (message_id) {
			case Messages.to_main_menu:
				trace("Main Menu");
				if (self.state != MAIN_MENU)
					Msg.post("#boardproxy", CollectionproxyMessages.unload);
				Msg.post("main:/main#menu", GoMessages.enable);
				Msg.post("#background", GoMessages.enable);
				self.state = MAIN_MENU;

			case Messages.start_game:
				trace(" Start Game Message Received ");
				Msg.post("#background", GoMessages.disable);
				// FIXME Examine DLE Msg.post("#boardproxy", CollectionproxyMessages.load);
				Msg.post("#menu", GoMessages.disable);
			case Messages.exit_game:
				trace(" Exit Message Received ");
				self.state = EXIT_MENU;
			// TODO Post Message Exit Game
			case Messages.settings:
				trace(" Settings Message Received ");
				Msg.post("#background", GoMessages.disable);
				Msg.post("#menu", GoMessages.disable);
				self.state = SETTINGS_MENU;
			// TODO Post Message Settings
			case CollectionproxyMessages.proxy_loaded:
				// Board collection has loaded...
				Msg.post(sender, CollectionproxyMessages.init);
				Msg.post("board:/board#script", Messages.start_level, {difficulty: 1});
				Msg.post(sender, GoMessages.enable);
				self.state = GAME_RUNNING;
			case Messages.pause_off:
				trace('Game is Paused');
			case Messages.pause_on:
				trace('Game is UnPaused');
		}
	}
}
