import lua.Table;

class SaveLoad {
	static final APP_NAME:String = "candy_berger";
	static final FILE_NAME:String = "candy.dat";

	public static function get_all_saved_data():lua.AnyTable {
		var fn:String = defold.Sys.get_save_file(APP_NAME, FILE_NAME);
		var r:AnyTable = defold.Sys.load(fn);
		if (r.sound == null) {
			var fn = defold.Sys.get_save_file(APP_NAME, FILE_NAME);
			var t = lua.Table.create({
				sound: 0,
				music: 0,
				lang: "en",
				game_level: 0,
				helper: 0,
				mount: 0,
				slot0:0,
				slot1:0,
				slot2:0,
				slot3:0,
				slot4:0,
				slot5:0,
				slot6:0,
				slot7:0,
				clothe_hat:0,
				clothe_boots:0,
				clothe_shirt:0,				
				clothe_whip:0,				
				high_score: 0,
				num_boot: 0,				
			});
			defold.Sys.save(fn, t);
			r = defold.Sys.load(fn);
		}
		return r;
	}

	public static function reset_data():Void {
		trace('SaveLoad Drive');
		var fn = defold.Sys.get_save_file(APP_NAME, FILE_NAME);
		defold.Sys.save(fn, lua.Table.create({}));
	}

	public static function save_all_data(t:lua.AnyTable):Void {
		var fn = defold.Sys.get_save_file(APP_NAME, FILE_NAME);
		defold.Sys.save(fn, t);
	}
}
