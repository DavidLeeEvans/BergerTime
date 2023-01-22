package hud;

import defold.types.Hash;

@:build(defold.support.MessageBuilder.build())
class LanguageMessage {
	var have_lang:{lang:String};
	var get_lang:{lang:String, id:Hash};
	var set_lang:{lang:String};
}
