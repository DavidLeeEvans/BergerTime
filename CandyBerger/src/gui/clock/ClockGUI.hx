package gui.clock;

import defold.Gui;
import defold.Go;
import defold.Msg;
import defold.Sound;
import defold.Timer;

@:build(defold.support.MessageBuilder.build())
class ClockGUIMessage {
	var clock_reset;
	var clock_start;
	var clock_stop;
	var clock_set:{
		h1:Int,
		h2:Int,
		s1:Int,
		s2:Int
	};
}

typedef ClockGUIData = {
	start_on:Bool,
	data_h1:Int,
	data_h2:Int,
	data_s1:Int,
	data_s2:Int
}

class ClockGUI extends defold.support.GuiScript<ClockGUIData> {
	override function init(_) {
		Msg.post(".", GoMessages.acquire_input_focus);
		Msg.post(".", ClockGUIMessage.clock_reset);
		Msg.post(".", ClockGUIMessage.clock_stop);
	}

	override function on_message<T>(self:ClockGUIData, message_id:Message<T>, message:T, sender:Url) {
		switch (message_id) {
			case ClockGUIMessage.clock_reset:
				//				trace("clock reset");
				self.data_s1 = self.data_s2 = self.data_h1 = self.data_h2 = 0;
			// set_image("h1",self.data_h1);
			// set_image("h2",self.data_h2);
			// set_image("s1",self.data_s1);
			// set_image("s2",self.data_s2);

			case ClockGUIMessage.clock_start:
				trace("clock start");
				self.start_on = true;
			case ClockGUIMessage.clock_stop:
				//				trace("clock stop");
				self.start_on = false;
			case ClockGUIMessage.clock_set:
				trace("clock set");
				self.data_h1 = message.h1;
				self.data_h2 = message.h2;
				self.data_s1 = message.s1;
				self.data_s2 = message.s2;
				// set_image("h1", self.data_h1);
				// set_image("h2",self.data_h2);
				// set_image("s1",self.data_s1);
				// set_image("s2",self.data_s2);
		}
	}

	override function update(self:ClockGUIData, dt:Float) {}

	function set_image(s:String, i:Int) {
		var n = Gui.get_node(s);
		switch (i) {
			case 0:
			// 		n.set_texture("hud/0");
			case 1:

			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
		}
	};
}
