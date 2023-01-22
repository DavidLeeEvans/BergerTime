/**
 * File: WidgetQuestion.hx
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

private typedef WidgetQuestionData = {}

class WidgetQuestion extends GuiScript<WidgetQuestionData> {
	override function init(self:WidgetQuestionData) {}

	override function update(self:WidgetQuestionData, dt:Float):Void {}

	override function on_message<T>(self:WidgetQuestionData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:WidgetQuestionData):Void {}

	override function on_reload(self:WidgetQuestionData):Void {}
}
