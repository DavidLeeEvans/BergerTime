/**
 * File: WidgetMusicSound.hx
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

private typedef WidgetMusicSoundData = {}

class WidgetMusicSound extends GuiScript<WidgetMusicSoundData> {
	override function init(self:WidgetMusicSoundData) {}

	override function update(self:WidgetMusicSoundData, dt:Float):Void {}

	override function on_message<T>(self:WidgetMusicSoundData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(self:WidgetMusicSoundData):Void {}

	override function on_reload(self:WidgetMusicSoundData):Void {}
}
