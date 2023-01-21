package gui.banner;

import defold.Gui;
import defold.Go;
import defold.Msg;
import defold.Sound;
import defold.Timer;

@:build(defold.support.MessageBuilder.build())
class BannerMessage {
	var banner_display;
	var banner_set:{
		mesg:String,
		duration:Float,
		loc_x:Float,
		loc_y:Float
	};
}

typedef BannerData = {
	start_on:Bool,
	mesg:String,
	duration:Float,
	loc_x:Float,
	loc_y:Float
}

class BannerRender extends defold.support.RenderScript<BannerData> {
	override function init(self:BannerData) {
		self.start_on = false;
	}

	override function on_message<T>(self:BannerData, message_id:Message<T>, message:T, sender:Url) {
		switch (message_id) {
			case BannerMessage.banner_set:
				trace("banner set");
				var n = Gui.get_node("text");
				self.loc_x = message.loc_x;
				self.loc_y = message.loc_y;
				self.mesg = message.mesg;
				self.duration = message.duration;
				Gui.set_enabled(n, false);
				Gui.set_text(n, self.mesg);

			case BannerMessage.banner_display:
				trace("banner display");
				var n = Gui.get_node("text");
				var p = Gui.get_particlefx(Gui.get_node("particles"));
				Gui.set_enabled(n, true);
				self.start_on = true;
				Timer.delay(self.duration, false, banner_callback);
		}
	}

	override function update(self:BannerData, dt:Float) {}

	function banner_callback(self:BannerData, handle:TimerHandle, time_elapsed:Float):Void {
		var n = Gui.get_node("text");
		Gui.set_enabled(n, false);
		self.start_on = false;
	}
}
