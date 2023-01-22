/**
 * File: WidgetRUSure.hx
 * For: Widget
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

package widgets;

import Defold.hash;
import defold.Go.GoMessages;
import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.Sound;
import defold.Sys.SysSysInfo;
import defold.Vmath;
import defold.Window;
import defold.support.GuiScript;
import defold.support.ScriptOnInputAction;
import defold.types.Hash;
import defold.types.Message;
import defold.types.Url;
import defold.types.Vector3;
import widgets.WidgetMessages;

private typedef WidgetRUSureData = {
	var panel:GuiNode;
	var title:GuiNode;
	var no:GuiNode;
	var yes:GuiNode;
	var bno:GuiNode;
	var byes:GuiNode;
	var panel_width:Int;
	var panel_height:Int;
}

class WidgetRUSure extends GuiScript<WidgetRUSureData> {
	override function init(self:WidgetRUSureData) {
		self.panel = Gui.get_node("panel");
		self.title = Gui.get_node("title");
		self.no = Gui.get_node("no");
		self.yes = Gui.get_node("yes");
		self.bno = Gui.get_node("bno");
		self.byes = Gui.get_node("byes");
		self.panel_width = Window.get_size().width;
		self.panel_height = Window.get_size().height;
		Gui.set_position(self.panel, Vmath.vector3(-self.panel_width, 0, 0));
	}

	override function update(self:WidgetRUSureData, dt:Float):Void {}

	override function on_input(self:WidgetRUSureData, action_id:Hash, action:ScriptOnInputAction):Bool {
		if (action_id == hash("touch") && action.pressed) {
			if (Gui.pick_node(self.bno, action.x, action.y)) {
				Sound.play('/sounds#click');
				Msg.post("#", WidgetMessages.off_screen);
			} else if (Gui.pick_node(self.byes, action.x, action.y)) {
				Sound.play('/sounds#click');
				SaveLoad.reset_data();
				Msg.post("#", WidgetMessages.off_screen);
			}
		}
		return true;
	}

	override function on_message<T>(self:WidgetRUSureData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {
			case WidgetMessages.set_title:
				Gui.set_text(self.title, message.info);
			case WidgetMessages.set_on:
				Gui.set_text(self.yes, message.info);
			case WidgetMessages.set_off:
				Gui.set_text(self.no, message.info);
			case WidgetMessages.on_screen:
				Gui.set_position(self.panel, Vmath.vector3(self.panel_width / 2, self.panel_height / 2, 0));
			case WidgetMessages.off_screen:
				Gui.set_position(self.panel, Vmath.vector3(-self.panel_width, 0, 0));
		}
	}

	override function final_(self:WidgetRUSureData):Void {}

	override function on_reload(self:WidgetRUSureData):Void {}
}
