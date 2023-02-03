package hud;

import defold.Gui;
import defold.Go;
import defold.Msg;
import defold.Sound;
import defold.Timer;

import defold.types.Url;
import defold.types.Message;

@:build(defold.support.MessageBuilder.build())
class HudGUIMessage {
	var inc_sb_coffee;
	var inc_sb_icecream;
	var inc_sb_fries;
	var inc_sb_candy;
	var set_lives:{lives:Int};
	var set_pepper:{num:Int};
	var add_score:{num:Int};
	var clear_score;
	var clear_highscore;
	var clear_sidebar;
	
	// external messages
}

typedef HudGUIData = {
	var score:Int;
	var high_score:Int;
	var sb_icecream:Int;
	var sb_fries:Int;
	var sb_coffee:Int;
	var sb_candy:Int;
};

class HudGUI extends defold.support.GuiScript<HudGUIData> {
	override function init(self:HudGUIData) {
		self.score = 0;
		self.high_score = get_highscore();
		// Get HighScore
		// Msg.post(".", GoMessages.acquire_input_focus);
		// Msg.post(".", HudGUIMessage.set_lives, {lives: self.lives});
		// Msg.post(".", HudGUIMessage.clear_score);
	}

	override function on_message<T>(self:HudGUIData, message_id:Message<T>, message:T, sender:Url) {
		switch (message_id) {
			case HudGUIMessage.clear_sidebar:
				self.sb_coffee = 0;
				self.sb_fries = 0;
				self.sb_icecream = 0;
				self.sb_candy = 0;
			case HudGUIMessage.inc_sb_coffee: 
				self.sb_coffee++;
			case HudGUIMessage.inc_sb_fries: 
				self.sb_fries++;
			case HudGUIMessage.inc_sb_icecream: 
				self.sb_icecream++;
			case HudGUIMessage.inc_sb_candy: 
				self.sb_candy++;
			case HudGUIMessage.set_pepper:
				trace("set_pepper");
				var n = Gui.get_node("amount_pepper");
				Gui.set_text(n, Std.string(message.num));
			case HudGUIMessage.add_score:
				trace("add score");
				self.score = self.score + message.num;
				var n = Gui.get_node("amount_player_score");
				Gui.set_text(n, Std.string(self.score));
				if (self.score > self.high_score) {
					self.high_score = self.score;
					var hs = Gui.get_node("amount_highscore");
					Gui.set_text(hs, Std.string(self.high_score));
				}
			case HudGUIMessage.clear_score:
				trace("clear score");
				self.score = 0;
				var n = Gui.get_node("amount_player_score");
				Gui.set_text(n, Std.string(self.score));
			case HudGUIMessage.clear_highscore:
				trace("clear score");
				self.high_score = 0;
				var n = Gui.get_node("amount_highscore");
				Gui.set_text(n, Std.string(self.high_score));
			case HudGUIMessage.set_lives:
//				trace("set lives");
				var n = Gui.get_node("amount_lives");
				Gui.set_text(n, Std.string(message.lives));
		}
	}

	function get_highscore():Int {
		// TODO storage
		return 42; // Testing Meaning Of Life
	}
}
