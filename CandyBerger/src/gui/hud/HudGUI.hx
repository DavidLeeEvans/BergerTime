package gui.hud;

import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.Sound;
import defold.Timer;

@:build(defold.support.MessageBuilder.build())
class HudGUIMessage {
	var slide_up;
	var slide_down:{wait:Float};
	var receive_data:{
		?mes0:String,
		?mes1:String,
		?mes2:String,
		?mes3:String
	};
}

typedef HudGUIData = {}

class HudGUI extends defold.support.GuiScript<HudGUIData> {
	final slideUp:Float = 1.7;
	final slideDown:Float = 0.11;
	var wait_time:Float = 3.0;

	var onOff:Bool;

	override function init(_) {
		onOff = false;
		// End of Init
		Msg.post(".", GoMessages.acquire_input_focus);
		Msg.post(".", HudGUIMessage.slide_up);
	}

	override function on_message<T>(self:HudGUIData, message_id:Message<T>, message:T, sender:Url) {
		switch (message_id) {
			case HudGUIMessage.slide_down:
				//				trace("Slide On");
				wait_time = message.wait;
				func_slide_down();
			case HudGUIMessage.slide_up:
				//				trace("Slide Off");
				Timer.delay(wait_time, false, func_slide_up_callback);
			case HudGUIMessage.receive_data:
				var t0 = Gui.get_node('text0');
				var t1 = Gui.get_node('text1');
				var t2 = Gui.get_node('text2');
				var t3 = Gui.get_node('text3');
				Gui.set_text(t0, "");
				Gui.set_text(t1, "");
				Gui.set_text(t2, "");
				Gui.set_text(t3, "");
				Gui.set_text(t0, message.mes0);
				Gui.set_text(t1, message.mes1);
				Gui.set_text(t2, message.mes2);
				Gui.set_text(t3, message.mes3);
		}
	}

	public function func_slide_up_callback(self:HudGUIData, handle:TimerHandle, time_elapsed:Float):Void {
		//		trace('func_slide_up');
		Msg.post("/go#master_sound_bus", SoundMessages.play_sound, {});
		onOff = true;
		Gui.animate(Gui.get_node('box'), GuiAnimateProprty.PROP_POSITION, Vmath.vector3(0, 1200.0, 0), GuiEasing.EASING_INEXPO, slideDown, 0.1);
	}

	public function func_slide_down():Void {
		trace('func_slide_off');
		Msg.post("/go#master_sound_bus", SoundMessages.play_sound, {});
		onOff = false;
		Gui.animate(Gui.get_node('box'), GuiAnimateProprty.PROP_POSITION, Vmath.vector3(0, 700.0, 0), GuiEasing.EASING_INEXPO, slideUp, 0.0);
	}
}
