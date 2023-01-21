package gui.panel;

import defold.Go;
import defold.Gui;
import defold.Msg;
import defold.Sound;

import defold.support.ScriptOnInputAction;

import defold.types.Hash;

import dex.util.Rand;

import haxe.ds.Map;

@:build(defold.support.MessageBuilder.build())
class PanelGUIMessage {
	var slide_on;
	var slide_off;
	var remove;
	var add_item:{item:ItemEnumSelection};
	var picked_item:{item:ItemEnumSelection};
}

typedef PanelGUIData = {
	var itemArray:Array<ItemEnumSelection>;
	var itemSelected:ItemEnumSelection;
	var nextPosition:Int;
	var pickedPosition:Int;
}

enum abstract ItemEnumSelection(Int) {
	var Bathleth = 0;
	var Boxcutter = 1;
	var Crossbow = 2;
	var Jetpack = 3;
	var Jetski = 4;
	var Net0 = 5;
	var Net1 = 6;
	var Net2 = 7;
	var ColdFusionBomb = 8;
	var Wmd0 = 9;
	var Wmd1 = 10;
	var Wmd2 = 11;
	var Bee_hive = 12;
	var Catnip = 13;
	var Motorcycle = 14;
	var Transporter = 15;
	var Bombs = 16;
	var Ied0 = 17;
	var Ray_gun0 = 18;
	var Xray_glasses = 19;
	var candle = 20;
	var gem2 = 21;
	var mirror = 22;
	var seekerpumpkin = 23;
	var wand1 = 24;
	var wand3 = 25;
	var gem1 = 26;
	var mirror2 = 27;
	var pumpkin = 28;
	var wand0 = 29;
	var wand2 = 30;
	var wings = 31;
	var Removed = 32;
}

class PanelGUI extends defold.support.GuiScript<PanelGUIData> {
	static final Items:Map<ItemEnumSelection, String> = [
		Bathleth => "bathleth",
		Boxcutter => "boxcutter",
		Crossbow => "crossbow",
		Jetpack => "jetpack",
		Jetski => "jetski",
		Net0 => "net0",
		Net1 => "net1",
		Net2 => "net2",
		ColdFusionBomb => "coldfusionbomb",
		Wmd0 => "wmd0",
		Wmd1 => "wmd1",
		Wmd2 => "wmd2",
		Bee_hive => "bee_hive",
		Catnip => "catnip",
		Motorcycle => "motorcycle",
		Transporter => "transport",
		Bombs => "bombs",
		Ied0 => "ied0",
		Ray_gun0 => "ray_gun0",
		Xray_glasses => "xray_glasses",
		candle => 'candle',
		gem2 => 'gem2',
		mirror => 'mirror',
		seekerpumpkin => 'seekerpumkin',
		wand1 => 'wand1',
		wand3 => 'wand3',
		gem1 => 'gem1',
		mirror2 => 'mirror2',
		pumpkin => 'pumpkin',
		wand0 => 'wand0',
		wand2 => 'wand2',
		wings => 'wings',
		Removed => "glassPanel_corners"
	];

	// Buton Animations
	// final spineButtonOn:String = "run";
	// final spineButtonOff:String = "walk";
	// Slide Animations
	final slideIn:Float = 1.7;
	final slideOut:Float = 0.5;

	var onOff:Bool;

	final textureOn:String = "on_panel";
	final textureOff:String = "off_panel";
	//
	final buttonTextureOn:String = "red_button12";
	final buttonTextureOff:String = "button_NO";

	// Init
	override function init(self:PanelGUIData) {
		self.nextPosition = 0;
		self.itemSelected = ItemEnumSelection.Removed;
		self.itemArray = [
			ItemEnumSelection.Removed,
			ItemEnumSelection.Removed,
			ItemEnumSelection.Removed,
			ItemEnumSelection.Removed,
			ItemEnumSelection.Removed,
			ItemEnumSelection.Removed,
			ItemEnumSelection.Removed,
			ItemEnumSelection.Removed
		];

		onOff = false;
		// End of Init
		Msg.post(".", GoMessages.acquire_input_focus);
		Msg.post(".", PanelGUIMessage.slide_off);
	}

	override function on_input<T>(self:PanelGUIData, action_id:Hash, action:ScriptOnInputAction) {
		if (action_id == hash("touch") && action.released) {
			var play_button = Gui.get_node("on_off");
			var box0 = Gui.get_node("box0");
			var box1 = Gui.get_node("box1");
			var box2 = Gui.get_node("box2");
			var box3 = Gui.get_node("box3");
			var box4 = Gui.get_node("box4");
			var box5 = Gui.get_node("box5");
			var box6 = Gui.get_node("box6");
			var box7 = Gui.get_node("box7");

			if (Gui.pick_node(play_button, action.x, action.y)) {
				if (onOff) {
					Msg.post(".", PanelGUIMessage.slide_off);
					return true;
				} else
					Msg.post(".", PanelGUIMessage.slide_on);
				return true;
			} else if (Gui.pick_node(box0, action.x, action.y)) {
				if (self.itemArray[0] == ItemEnumSelection.Removed)
					return true;
				self.itemSelected = self.itemArray[0];
				self.pickedPosition = 0;
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
			} else if (Gui.pick_node(box1, action.x, action.y)) {
				if (self.itemArray[1] == ItemEnumSelection.Removed)
					return false;
				self.itemSelected = self.itemArray[1];
				self.pickedPosition = 1;
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
			} else if (Gui.pick_node(box2, action.x, action.y)) {
				if (self.itemArray[2] == ItemEnumSelection.Removed)
					return false;
				self.itemSelected = self.itemArray[2];
				self.pickedPosition = 2;
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
			} else if (Gui.pick_node(box3, action.x, action.y)) {
				if (self.itemArray[3] == ItemEnumSelection.Removed)
					return false;
				self.itemSelected = self.itemArray[3];
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
				self.pickedPosition = 3;
			} else if (Gui.pick_node(box4, action.x, action.y)) {
				if (self.itemArray[4] == ItemEnumSelection.Removed)
					return false;
				self.itemSelected = self.itemArray[4];
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
				self.pickedPosition = 4;
			} else if (Gui.pick_node(box5, action.x, action.y)) {
				if (self.itemArray[5] == ItemEnumSelection.Removed)
					return false;
				self.itemSelected = self.itemArray[5];
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
				self.pickedPosition = 5;
			} else if (Gui.pick_node(box6, action.x, action.y)) {
				if (self.itemArray[6] == ItemEnumSelection.Removed)
					return false;
				self.itemSelected = self.itemArray[6];
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
				self.pickedPosition = 6;
			} else if (Gui.pick_node(box7, action.x, action.y)) {
				if (self.itemArray[7] == ItemEnumSelection.Removed)
					return false;
				self.itemSelected = self.itemArray[7];
				self.pickedPosition = 7;
				Msg.post(".", PanelGUIMessage.picked_item, {item: Removed});
			}
		}
		if (action_id == hash("test_panel") && action.released) {
			//			trace("61 Isabella Ave, Stolen passport? Report date");
			Msg.post(".", PanelGUIMessage.add_item, {item: Boxcutter}); // TODO Remove later testing y3k
		}

		return true;
	}

	// override function final_(self:PanelGUIData) {}

	override function on_message<T>(self:PanelGUIData, message_id:Message<T>, message:T, sender:Url) {
		switch (message_id) {
			case PanelGUIMessage.slide_on:
				trace("Slide On");
				func_slide_on();
			case PanelGUIMessage.slide_off:
				//				trace("Slide Off");
				func_slide_off();
			case PanelGUIMessage.picked_item:
				switch (self.pickedPosition) {
					case 0:
						Gui.set_texture(Gui.get_node("box0"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box0'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[0];
						self.itemArray[0] = ItemEnumSelection.Removed;
					case 1:
						Gui.set_texture(Gui.get_node("box1"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box1'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[1];
						self.itemArray[1] = ItemEnumSelection.Removed;
					case 2:
						Gui.set_texture(Gui.get_node("box2"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box2'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[2];
						self.itemArray[2] = ItemEnumSelection.Removed;
					case 3:
						Gui.set_texture(Gui.get_node("box3"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box3'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[3];
						self.itemArray[3] = ItemEnumSelection.Removed;
					case 4:
						Gui.set_texture(Gui.get_node("box4"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box4'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[4];
						self.itemArray[4] = ItemEnumSelection.Removed;
					case 5:
						Gui.set_texture(Gui.get_node("box5"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box5'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[5];
						self.itemArray[5] = ItemEnumSelection.Removed;
					case 6:
						Gui.set_texture(Gui.get_node("box6"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box6'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[6];
						self.itemArray[6] = ItemEnumSelection.Removed;
					case 7:
						Gui.set_texture(Gui.get_node("box7"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box7'), hash(Items.get(Removed)));
						self.itemSelected = self.itemArray[7];
						self.itemArray[7] = ItemEnumSelection.Removed;
				}
			case PanelGUIMessage.add_item:
				trace('Item Added ${Items.get(message.item)}');
				self.nextPosition = 0;
				var hasSlotsflag = false;
				for (i in 0...8) // Number of slots
					if (self.itemArray[i] == ItemEnumSelection.Removed) {
						self.nextPosition = i;
						hasSlotsflag = true;
						trace(i);
						break;
					}

				if (!hasSlotsflag)
					self.nextPosition = Rand.int(0, 7);

				switch (self.nextPosition) {
					case 0:
						Gui.set_texture(Gui.get_node("box0"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box0'), hash(Items.get(message.item)));
						self.itemArray[0] = message.item;
					case 1:
						Gui.set_texture(Gui.get_node("box1"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box1'), hash(Items.get(message.item)));
						self.itemArray[1] = message.item;
					case 2:
						Gui.set_texture(Gui.get_node("box2"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box2'), hash(Items.get(message.item)));
						self.itemArray[2] = message.item;
					case 3:
						Gui.set_texture(Gui.get_node("box3"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box3'), hash(Items.get(message.item)));
						self.itemArray[3] = message.item;
					case 4:
						Gui.set_texture(Gui.get_node("box4"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box4'), hash(Items.get(message.item)));
						self.itemArray[4] = message.item;
					case 5:
						Gui.set_texture(Gui.get_node("box5"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box5'), hash(Items.get(message.item)));
						self.itemArray[5] = message.item;
					case 6:
						Gui.set_texture(Gui.get_node("box6"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box6'), hash(Items.get(message.item)));
						self.itemArray[6] = message.item;
					case 7:
						Gui.set_texture(Gui.get_node("box7"), hash('panel_atlas'));
						Gui.play_flipbook(Gui.get_node('box7'), hash(Items.get(message.item)));
						self.itemArray[7] = message.item;
				}
		}
	}

	public function func_slide_on():Void {
		trace('func_slide_on');
		Msg.post("/go#master_sound_bus", SoundMessages.play_sound, {});
		onOff = true;
		// Gui.animate(Gui.get_node('box'), "position.x", 300.0, GuiEasing.EASING_INEXPO, slideIn, 0.1);
		Gui.animate(Gui.get_node('box'), GuiAnimateProprty.PROP_POSITION, Vmath.vector3(0, 300, 0), GuiEasing.EASING_OUTINEXPO, slideIn, 0.1);
		Gui.set_texture(Gui.get_node('box'), hash('panel_atlas'));
		Gui.play_flipbook(Gui.get_node('box'), hash(textureOn));
		//
		Gui.set_texture(Gui.get_node("on_off"), hash('sprites'));
		Gui.play_flipbook(Gui.get_node('on_off'), hash(buttonTextureOn));
	}

	public function func_slide_off():Void {
		//		trace('func_slide_off');
		Msg.post("/go#master_sound_bus", SoundMessages.play_sound, {});
		onOff = false;
		// Gui.animate(Gui.get_node('box'), "position.x", 700.0, GuiEasing.EASING_INEXPO, slideOut, 0.0);
		Gui.animate(Gui.get_node('box'), GuiAnimateProprty.PROP_POSITION, Vmath.vector3(0, 700, 0), GuiEasing.EASING_OUTINEXPO, slideOut, 0.1);

		Gui.set_texture(Gui.get_node('box'), hash('panel_atlas'));
		Gui.play_flipbook(Gui.get_node('box'), hash(textureOff));
		//
		Gui.set_texture(Gui.get_node("on_off"), hash('sprites'));
		Gui.play_flipbook(Gui.get_node('on_off'), hash(buttonTextureOff));
	}
}
