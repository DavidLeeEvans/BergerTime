#!/bin/sh
rm -fr ./scripts
haxe build build.hxml
mv main.lua main_temp
echo 'local broadcast = require "ludobits.m.broadcast"' >> main.lua
echo 'local bezier = require "ludobits.m.bezier"' >> main.lua
echo 'local gesture = require "in.gesture"' >> main.lua
cat main_temp >>main.lua
rm -f main_temp
