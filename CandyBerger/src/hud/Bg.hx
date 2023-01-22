/**
 * File: Bg.hx
 * For:
 * By: David Lee Evans
 * Created:
 * Modified:
 *
 */

package hud;

import Defold.hash;
import defold.Msg;
import defold.Sprite.SpriteMessages;
import defold.support.Script;
import dex.util.Rand;

private typedef BgData = {}

class Bg extends Script<BgData> {
	final f:Array<String> = [
		'decoA001', 'decoA002', 'decoA003', 'decoA004', 'decoA005', 'decoA006', 'decoA007', 'decoA008', 'decoA009', 'decoA010', 'decoA011', 'decoA012',
		'decoA013', 'decoA014', 'decoA015', 'decoA016', 'decoA017', 'decoA018', 'decoA019', 'decoA020', 'decoA021', 'decoA022', 'decoA023', 'decoA024'
	];

	override function init(self:BgData) {
		Msg.post('#rnd0', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd1', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd2', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd3', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd4', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd5', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd6', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd7', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
		Msg.post('#rnd8', SpriteMessages.play_animation, {id: hash(f[Rand.int(0, f.length)])});
	}
}
