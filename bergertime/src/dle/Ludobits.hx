package dle;

import defold.types.*;
import lua.Table.AnyTable;

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
extern class LudobitsBroadCast {
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
