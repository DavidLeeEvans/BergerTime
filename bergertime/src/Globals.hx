import defold.Window.WindowSize;

import dex.util.Rand;

@:build(defold.support.MessageBuilder.build())
class GlobalMessage {
	var can_pepper;
	var cannot_pepper;
	var end_of_lives;
}

class Globals {
	//
	public static final version:String = "3.61.11"; // Y3K testing, not the real version number - will be set on publishing
	//
	public static var gameplates:Array<Int> = [1, 2, 4, 4, 4, 6, 6];

	//
	public static var soundIsOn:Bool = true;
	public static var musicIsOn:Bool = true;
	//
	public static var window_size:WindowSize;
	// Game Running State
	public static var total_num_lives:Int;
	public static var total_num_current_monsters:Int;

	//
	public static final collectionProxyUrl:Array<String> = [
		'#splashroom_proxy',
		'#menu_proxy',
		'#settings_proxy',
		'#cutscence_proxy',
		// Start of Game proxies
		'#level00_proxy',
		'#level01_proxy',
		'#level02_proxy',
		'#level03_proxy',
		'#level04_proxy',
		'#level05_proxy',
		'#level06_proxy'
	];

	public static final collectionProxyJson:Array<String> = [
		'splashroom_proxy.json',
		'menu_proxy.json',
		'settings_proxy.json',
		'cutscene_proxy.json',
		// Start of Game proxies
		'level00_proxy.json',
		'level01_proxy.json',
		'level02_proxy.json',
		'level03_proxy.json',
		'level04_proxy.json',
		'level05_proxy.json',
		'level06_proxy.json',
	];

	public static final MaximunLevels:Int = collectionProxyUrl.length - 1;
	public static var debug:Bool = false;
	static var level:Int;
	static var prev_level:Int;

	public static function get_game_level():Int {
		return level;
	}

	public static function get_prev_game_level():Int {
		return prev_level;
	}

	public static function set_game_level(s:Int):Void {
		level = s;
	}

	public static function set_prev_game_level(s:Int):Void {
		prev_level = s;
	}

	public static function random_game_level():Void {
		set_game_level(Rand.int(4, MaximunLevels));
	}
}
