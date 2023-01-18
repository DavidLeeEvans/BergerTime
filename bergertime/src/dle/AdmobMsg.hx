package dle;

import defold.types.Hash;

enum abstract ADMOB_TYPE(Int) {
	var ADAPTIVE_BANNER = 1;
	var BANNER = 2;
	var FLUID = 3;
	var LARGE_BANNER = 4;
	var LEADER_BOARD = 5;
	var MEDIUM_RECTANGLE = 6;
	var SEARCH = 7;
	var SKYSCRAPER = 8;
	var SMART_BANNER = 9;
}

enum abstract ADMOB_POSITION(Int) {
	var POS_NONE = 1;
	var POS_TOP_LEFT = 2;
	var POS_TOP_CENTER = 3;
	var POS_TOP_RIGHT = 4;
	var POS_BOTTOM_LEFT = 5;
	var POS_BOTTOM_CENTER = 6;
	var POS_BOTTOM_RIGHT = 7;
	var POS_CENTER = 8;
}

@:build(defold.support.MessageBuilder.build())
class AdmobMsg {
	var admob_init;
	var admob_request_idfa;
	var set_privacy_settings:{name:Bool};

	// banner
	var load_banner:{ad_id:String, ?size:ADMOB_TYPE};
	var destroy_banner;
	var show_banner:{?position:ADMOB_POSITION};
	var hide_banner;
	var is_banner_loaded:{o:Hash};
	var have_is_banner_loaded:{name:Bool};

	// reward_video
	var load_reward_video:{ad_id:String};
	var show_reward_video;
	var hide_reward_video;
	var is_reward_video_loaded:{o:Hash};
	var have_is_reward_video_loaded:{name:Bool};

	// interstitial NA
	var load_interstitial:{ad_id:String, ?placement:Int};
	var destroy_interstitial;
	var show_interstitial;
	var hide_interstitial_video;
	var is_interstitial_loaded:{o:Hash};
	var have_is_interstitial_loaded:{name:Bool};
}
