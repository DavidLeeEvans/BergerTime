import defold.Go.GoMessages;

import defold.support.GuiScript;

import defold.types.Message;
import defold.types.Url;

private typedef ReferGUIData = {}

class ReferGUI extends GuiScript<ReferGUIData> {
	override function init(self:ReferGUIData) {}

	override function update(self:ReferGUIData, dt:Float):Void {}

	override function on_message<T>(self:ReferGUIData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:ReferGUIData):Void {}

	override function on_reload(self:ReferGUIData):Void {}
}
