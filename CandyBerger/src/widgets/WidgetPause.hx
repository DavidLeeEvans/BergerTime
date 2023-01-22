/**
 * File: WidgetPause.hx
 * For: Widget
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

package widgets;

import defold.Go.GoMessages;
import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.support.GuiScript;
import defold.types.Message;
import defold.types.Url;

private typedef WidgetPauseData = {}

class WidgetPause extends GuiScript<WidgetPauseData> {
	override function init(self:WidgetPauseData) {}

	override function update(self:WidgetPauseData, dt:Float):Void {}

	override function on_message<T>(self:WidgetPauseData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:WidgetPauseData):Void {}

	override function on_reload(self:WidgetPauseData):Void {}
}
