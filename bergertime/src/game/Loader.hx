package game;

import Globals;

import defold.Collectionproxy.CollectionproxyMessages;

import defold.Go.GoMessages;

import defold.Msg;
import defold.Timer;
import defold.Window;

import defold.support.Script;

import defold.types.Message;
import defold.types.Url;

import dex.util.Rand;

import eskimo.ComponentManager;
import eskimo.Context;
import eskimo.EntityManager;

import eskimo.systems.SystemManager;

//

@:build(defold.support.MessageBuilder.build())
class LoaderMessage {
	var enable_collection;
	var disable_collection;
	var cut_screen:{
		which_cut:Int,
		next_screen:Int,
		mesg:String,
		duration:Float
	};
}

typedef LoaderData = {}

class LoaderScript extends Script<LoaderData> {
	override function init(self:LoaderData) {
		Globals.window_size = Window.get_size();

		// Msg.post("loader_coll:/loader#cutscene_proxy", CollectionproxyMessages.load);
		// Msg.post("loader_coll:/loader#cutscene_proxy", CollectionproxyMessages.enable);

		// Msg.post("#go/cutscene_proxy", CutScenesMessage.set_cutscene, {
		// 	ri: "ri0",
		// 	li: "li0",
		// 	bg: "bg0",
		// 	text: "61 Isabella",
		// 	delay: 11.11,
		// 	next_collection: 1
		// });

		// End of Testing
		// Lets initialize the ecs system
		Globals.context = new Context();
		lua.Lua.assert(Globals.context != null);
		Globals.components = new ComponentManager();
		lua.Lua.assert(Globals.components != null);
		Globals.entities = new EntityManager(Globals.components);
		lua.Lua.assert(Globals.entities != null);
		Globals.systems = new SystemManager(Globals.entities);
		lua.Lua.assert(Globals.systems != null);
		//
		Msg.post(".", GoMessages.acquire_input_focus);
		trace('Loader.hx func init');
		Globals.set_game_level(-1);
		Globals.set_prev_game_level(-1);
		load_splash_menu(self);
		Globals.set_prev_game_level(0);
		Globals.set_game_level(0);
		Timer.delay(3.0, false, next_menu_callback);
	}

	override function update(self:LoaderData, dt:Float):Void {}

	override function on_message<TMessage>(self:LoaderData, message_id:Message<TMessage>, message:TMessage, sender:Url) {
		//		trace('Loader.hx func on_message');

		switch message_id {
			case LoaderMessage.enable_collection:
				Msg.post(Globals.collectionProxyUrl[Globals.get_game_level()], CollectionproxyMessages.load);
				Msg.post(Globals.collectionProxyUrl[Globals.get_game_level()], CollectionproxyMessages.enable);
			case LoaderMessage.disable_collection:
				Msg.post(Globals.collectionProxyUrl[Globals.get_prev_game_level()], CollectionproxyMessages.disable);
			case LoaderMessage.cut_screen:
				/*
					Msg.post('#cutscene_proxy', CutScenesMessage.set_cutscene, {
						ri: "ri" + message.which_cut,
						li: "li" + message.which_cut,
						bg: "bg" + message.which_cut,
						text: message.mesg,
						next_collection: message.next_screen,
						delay: message.duration
					});
				 */
				// Msg.post('#/go/Cutscene', CutScenesMessage.display_cutscene);
		}
	}

	override function final_(self:LoaderData) {
		Msg.post(".", GoMessages.release_input_focus);
	}

	function load_splash_menu(self:LoaderData):Void {
		trace('Loader.hx func load_splash_menu');
		Globals.set_prev_game_level(0);
		Globals.set_game_level(0);
		Msg.post(".", LoaderMessage.enable_collection);
		Timer.delay(3.0, false, load_menu_callback);
	}

	private function load_menu_callback(self, _, _) {
		load_level_menu(self);
	}

	function load_level_menu(self:LoaderData):Void {
		trace('Loader.hx func load_level_menu');
		Globals.set_game_level(1);
		Msg.post(".", LoaderMessage.disable_collection);
		Msg.post(".", LoaderMessage.enable_collection);

		Msg.post("/loader#splashroom_proxy", CollectionproxyMessages.disable);
		Msg.post("/loader#splashroom_proxy", CollectionproxyMessages.final_);
		Msg.post("/loader#splashroom_proxy", CollectionproxyMessages.unload);
		trace("Dynamic Splash Screen Unload Only ???");
	}

	function load_settings(self:LoaderData):Void {
		trace('Loader.hx func load_settings');
		Globals.set_prev_game_level(Globals.get_game_level());
		Globals.set_game_level(2);
		Msg.post(".", LoaderMessage.disable_collection);
		Msg.post(".", LoaderMessage.enable_collection);
	}

	function load_any_random(self:LoaderData):Void {
		trace('Loader.hx func load_any_random');
		var l = Rand.int(3, Globals.MaximunLevels);
		Globals.set_prev_game_level(Globals.get_game_level());
		Globals.set_game_level(l);
		Msg.post(".", LoaderMessage.disable_collection);
		Msg.post(".", LoaderMessage.enable_collection);
	}

	function load_level_explicite(level:Int, self:LoaderData):Void {
		trace('Loader.hxfunc load_level_explicite');
		trace(Globals.collectionProxyUrl[level]);
		if (level < 0 || level > Globals.MaximunLevels)
			return;
		Globals.set_prev_game_level(Globals.get_game_level());
		Globals.set_game_level(level);
		Msg.post(".", LoaderMessage.disable_collection);
		Msg.post(".", LoaderMessage.enable_collection);
	}

	function next_menu_callback(self:LoaderData, handle:TimerHandle, time_elapsed:Float):Void {
		Globals.set_prev_game_level(0);
		Globals.set_game_level(1);
		Msg.post(".", LoaderMessage.disable_collection);
		Msg.post(".", LoaderMessage.enable_collection);
	}
}
