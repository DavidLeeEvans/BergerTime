/**
 * File: WidgetChallenge.hx
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

private typedef WidgetChallengeData = {}

class WidgetChallenge extends GuiScript<WidgetChallengeData> {
	override function init(self:WidgetChallengeData) {}

	override function update(self:WidgetChallengeData, dt:Float):Void {}

	override function on_message<T>(self:WidgetChallengeData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:WidgetChallengeData):Void {}

	override function on_reload(self:WidgetChallengeData):Void {}
}
