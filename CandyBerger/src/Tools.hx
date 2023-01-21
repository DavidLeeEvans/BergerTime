import defold.types.Vector4;
import defold.types.Vector3;

import defold.Msg;

import defold.Render.RenderMessages;

// Some more Assembly needed.
class Tools {
	public static function draw_line(from:Vector3, to:Vector3, ?color:Vector4):Void {
		Msg.post("@render:", RenderMessages.draw_line, {start_point: from, end_point: to, color: defold.Vmath.vector4(1, 0, 0, 1)});
	}
}
