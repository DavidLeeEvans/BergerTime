import defold.Msg;
import defold.Render.RenderMessages;
import defold.types.Vector3;
import defold.types.Vector4;

class Tools {
	public static function draw_line(from:Vector3, to:Vector3, ?color:Vector4):Void {
		Msg.post("@render:", RenderMessages.draw_line, {start_point: from, end_point: to, color: defold.Vmath.vector4(1, 0, 0, 1)});
	}

	public static function level_int_to_string(level:Int, ?prefix:String):String {
		var r:String = "";
		if (prefix == null) {
			prefix = "";
		}
		if (level >= 0 && level <= 9) {
			r = prefix + '0' + Std.string(level);
		} else {
			r = prefix + Std.string(level);
		}
		return r;
	}

	public static function translate_text(lang:String, text:String):String {
		var r:String = text;

		return r;
	}
}
