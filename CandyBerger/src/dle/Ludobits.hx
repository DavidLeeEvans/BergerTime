package dle;

import defold.support.ScriptOnInputAction;

import defold.types.*;

import defold.types.Hash;

import lua.Table;

@:build(defold.support.MessageBuilder.build())
class GestureMessage {
	var on_gesture:GestureTypeResults;
}

/**
	Functions, messages and properties used to manipulate ludobits Bezier Points, Broadcast components.

**/
typedef LudoBitsCP = {
	var x:Float;
	var y:Float;
}

/**
	Create a bezier curve
	@param cp
	@param points
**/
@:native("bezier")
extern class LudobitsBezier {
	static function create<T>(cp:Array<LudoBitsCP>, points:Int):Array<Vector3>;
}

@:native("broadcast")
extern class BroadCast {
	/**
		Register the current script as a receiver for a specific message

		@param message_id 
		@param callback_function  Optional message handler function to call when a message is received. The function will receive the message and sender as it's arguments. You must call on_message for this to work
		 message_id 
		 sender
	**/
	static function register<T>(message_id:HashOrStringOrUrl, ?callback_function:(self:T, message_id:Hash, sender:Url) -> Void):Void;

	/**
		Unregister the current script from receiving a previously registered message
		@param message_id 
	**/
	static function unregister<T>(message_id:HashOrStringOrUrl):Void;

	/**
		on_message Forward received messages in scripts where the broadcast module is used and where registered messages have also provide a message handler function. If no message handler functions are used then there is no need to call this function.
		@param message_id 
		@param message
		@param sender 
		@return true if the message was handled
	**/
	static function on_message<T>(message_id:HashOrStringOrUrl, message:lua.AnyTable, sender:Url):Bool;

	/**
		send (message_id, message)
		Send a message to all registered receivers
		@param message_id 
		@param message
	**/
	static function send<T>(message_id:HashOrStringOrUrl, message:lua.AnyTable):Void;
}

typedef GestureTypeResults = {
	tap:Bool,
	double_tap:Bool,
	swipe_right:Bool,
	two_finger:{
		swipe_right:Bool, swipe_up:Bool, swipe_down:Bool, repeated:Bool, tap:Bool, double_tap:Bool, long_press:Bool, swipe_left:Bool
	},
	swipe_down:Bool,
	repeated:Bool,
	swipe_up:Bool,
	long_press:{
		position:Vector3, time:Float
	},
	swipe_left:Bool
}

/*
	typedef GestureTypeResults = {
	tap:Bool,
	double_tap:Bool,
	long_press:Bool,
	swipe_left:Bool,
	swipe_right:Bool,
	swipe_up:Bool,
	swipe_down:Bool,
	swipe:{from:Float, to:Float, time:Float},
	?two_finger:AnyTable,
	//  Two-finger geatures (tap, double_tap, long_press, repeated, swipe_* and pinch)
	// function M.on_input(self, action_id, action)
	}
 */
/**

	* ```action_id``` - (hash) The action_id to use when detecting gestures (default: "touch")
	* ```double_tap_interval``` - (number) Maximum time in seconds between two taps to consider it as a double tap (default: 0.5)
	* ```long_press_time``` - (number) Minimum time in seconds before a tap is considered a long press (default: 0.5)
	* ```swipe_threshold``` - (number) Minimum distance in pixels before considering it a swipe (default: 100)
	* ```tap_threshold``` - (number) Maximum distance in pixels between a press and release action to consider it a tap (default: 20)
	* ```multi_touch``` - (boolean) If multi touch gestures should be handled or not (default: true)

**/
typedef GestureSetting = {
	action_id:Hash,
	double_tap_interval:Float,
	long_press_time:Float,
	swipe_threshold:Int,
	tap_threshold:Int,
	multi_touch:Bool,
}

@:native("gesture")
extern class Gesture {
	/**
		Forward calls to on_input to this function to detect supported gestures
		@param self
		@param action_id
		@param action
		@return  A table containing detected gestures. Can contain the following values: * tap [boolean] * double_tap [boolean] * long_press [boolean] * swipe_left [boolean] * swipe_right [boolean] * swipe_up [boolean] * swipe_down [boolean] * swipe - table with values from, to and time
	**/
	static function on_input<T>(action_id:Hash, action:ScriptOnInputAction):GestureTypeResults;

	// static function on_input<T>(action_id:Hash, action:ScriptOnInputAction):Dynamic;

	/**
	**/
	static function create<T>(setting:GestureSetting):Dynamic;
}
