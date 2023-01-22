import defold.types.Hash;

@:build(defold.support.MessageBuilder.build())
class MainMessages {
	var load_collection:{level:Int}; // Loads and Starts game level
	var pause_game;
	var resume_game;
	var exit_game;
	var load_settings;
	//
	var rate_game:{app_id:String};
	var send_invite:{person:String};
	//
	var remote_new_screen:{next:String, current:String};
}
