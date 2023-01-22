/**
 * File: ScoreMenu.hx
 * For:
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

package hud;

import defold.Go.GoMessages;
import defold.Msg;
import defold.support.GuiScript;
import defold.types.Message;
import defold.types.Url;

private typedef ScoreMenuData = {}

class ScoreMenu extends GuiScript<ScoreMenuData> {
	override function init(self:ScoreMenuData):Void {
		Msg.post(".", GoMessages.acquire_input_focus);
		final lang = SaveLoad.get_all_saved_data().lang;
	}

	override function update(self:ScoreMenuData, dt:Float):Void {}

	override function on_message<T>(self:ScoreMenuData, message_id:Message<T>, message:T, sender:Url):Void {
		switch (message_id) {}
	}

	override function final_(_):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}

	override function on_reload(self:ScoreMenuData):Void {}
}
