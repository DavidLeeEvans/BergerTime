package splash;

import defold.Timer;

import defold.Collectionproxy.CollectionproxyMessages;

import defold.support.Script;

import defold.Msg;

import defold.types.Message;
import defold.types.Url;

import Globals;

typedef SplashData = {}

class SplashScript extends Script<SplashData> {


	override function update(self:SplashData, dt:Float):Void {}

	override function on_message<TMessage>(self:SplashData, message_id:Message<TMessage>, message:TMessage, sender:Url) {}

	override function final_(self:SplashData) {
	  //		Msg.post(".", GoMessages.release_input_focus);
	}

}
