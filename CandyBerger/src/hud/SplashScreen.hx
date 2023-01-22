package hud;

import defold.Go;
import defold.Msg;
import defold.Render.RenderMessages;
import defold.Vmath;
import defold.support.Script;

private typedef SplashScreenData = {}

class SplashScreen extends Script<SplashScreenData> {
	override function update(self:SplashScreenData, dt:Float):Void {
		Msg.post("@render:", RenderMessages.clear_color, {color: Vmath.vector4(61 / 256, 56 / 256, 261 / 256, 1)});
	}

	override function init(self:SplashScreenData) {
		Go.animate(".", "position.x", GoPlayback.PLAYBACK_ONCE_FORWARD, 0, GoEasing.EASING_INBACK, 2, 0, spin_animate);
	}

	private function spin_animate(_, url:defold.types.Url, gap:GoAnimatedProperty):Void {
		Go.animate(".", "euler.z", GoPlayback.PLAYBACK_ONCE_FORWARD, 360, GoEasing.EASING_INBACK, 2, 0, off_animate);
	}

	private function off_animate(_, url:defold.types.Url, gap:GoAnimatedProperty):Void {
		Go.animate(".", "position.x", GoPlayback.PLAYBACK_ONCE_FORWARD, 600, GoEasing.EASING_INBACK, 2, 0, post_finish);
	}

	private function post_finish(_, url:defold.types.Url, gap:GoAnimatedProperty):Void {
		final u = Msg.url("default", "/go", "Main");
		Msg.post(u, MainMessages.remote_new_screen, {next: "/go#mainscreen", current: "/go#splash_screen"});
	}
}
