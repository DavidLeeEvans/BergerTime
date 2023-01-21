/**
 * File: Main.hx
 * For: Main Boot Screen
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

import defold.Collectionproxy.CollectionproxyMessages;
import defold.Go.GoMessages;
import defold.Msg;
import defold.Sys.SysSysInfo;
import defold.types.Message;
import defold.types.Url;
import hud.LanguageMessage;
import lua.Table.AnyTable;

typedef MainData = {
	var next_level:String;
	var last_level:String;
	// Settings And Configurations
	var lang:String;
	var data_beam:lua.AnyTable;
}

class Main extends defold.support.Script<MainData> {
	override function init(self:MainData):Void {
		Msg.post(".", GoMessages.acquire_input_focus);
		// Begining of System Inits
		final sysSysInfo:SysSysInfo = defold.Sys.get_sys_info();
		if (sysSysInfo.system_name == "Linux")
		//	DefOS.set_always_on_top(true);
		self.lang = sysSysInfo.device_language;
		self.data_beam = SaveLoad.get_all_saved_data(); // TODO Some Y2k like testing needed!!!
		self.lang = self.data_beam.lang;
		Defold.pprint(self.data_beam); // Recycle data_beam to advoid race lock condition Facebook.
		// End of System Inits
		self.next_level = "/go#splash_screen";
		Msg.post(self.next_level, CollectionproxyMessages.load);
	}

	override function on_message<TMessage>(self:MainData, message_id:Message<TMessage>, message:TMessage, sender:Url):Void {
		switch (message_id) {
			case CollectionproxyMessages.proxy_loaded:
				Msg.post(self.next_level, CollectionproxyMessages.enable);
				if (self.last_level != null) {
					Msg.post(self.last_level, CollectionproxyMessages.unload);
				}
			case MainMessages.remote_new_screen:
				self.last_level = message.current;
				self.next_level = message.next;
				Msg.post(self.next_level, CollectionproxyMessages.load);
			case LanguageMessage.set_lang:
				trace('Received lang ${message.lang}');
				self.lang = message.lang;
				self.data_beam.lang = self.lang;
				SaveLoad.save_all_data(self.data_beam);

			case LanguageMessage.get_lang:
				Msg.post(message.id, LanguageMessage.have_lang, {lang: self.lang});
		}
	}

	override function final_(_):Void {
		Msg.post(".", GoMessages.release_input_focus);
	}
}
