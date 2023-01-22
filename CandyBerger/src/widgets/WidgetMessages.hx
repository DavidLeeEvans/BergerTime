package widgets;

@:build(defold.support.MessageBuilder.build())
class WidgetMessages {
	var on_screen;
	var off_screen;
	//
	var set_title:{info:String};
	var set_on:{info:String};
	var set_off:{info:String};
	//
	var receiver_reply:{result:Bool};
}
