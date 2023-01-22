/**
 * File: Pause.hx
 * For: Pause.gui widget
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

package hud;

import Defold.hash;
import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.Vmath;
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;

private typedef PauseData = {
	var bpause:GuiNode;
	var tpause:GuiNode;
}

class Pause extends GuiScript<PauseData> {
	override function init(self:PauseData) {
		Msg.post(".", GoMessages.acquire_input_focus);
		final lang = SaveLoad.get_all_saved_data().lang;
		self.bpause = Gui.get_node("bpause");
		self.tpause = Gui.get_node("tpause");
		Gui.set_text(self.tpause, Tools.translate_text(lang, Gui.get_text(self.tpause)));
		Gui.set_position(self.bpause, Vmath.vector3(510, 1000, 0));
		Gui.animate(self.bpause, PROP_POSITION, Vmath.vector3(0, 430, 0), EASING_INELASTIC, 2.0);
	}

	override function on_input(self:PauseData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch") && action.pressed) {
			if (Gui.pick_node(self.bpause, action.x, action.y)) {
				// Msg.post("/train_engine#TrainEngine", TrainEngineMesage.start);
				Gui.animate(self.bpause, PROP_POSITION, Vmath.vector3(0, 1000, 0), EASING_INELASTIC, 2.0);
			}
		}
		return false;
	}

	override function update(self:PauseData, dt:Float):Void {}

	override function on_message<T>(self:PauseData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:PauseData):Void {}

	override function on_reload(self:PauseData):Void {}
}
