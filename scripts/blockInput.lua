-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: just a function for block inputs
-- How to use:
--   1. Put these functions in your script <3

function onCreatePost()
	luaDebugMode = true
	blockInput(true)
end

function onBeatHit()
	if curBeat == 4 then
		blockInput(false)
	end
end

local keysArray = {}
function blockInput(block)
	if #keysArray == 0 then
		keysArray = getProperty("keysArray")
	end
	addHaxeLibrary("TitleState")
	local controlsArray = {"ui_up", "ui_left", "ui_right", "ui_down", "note_up", "note_left", "note_right", "note_down", "accept", "back", "pause", "reset"}
	if block then
		for i = 1, #controlsArray do
			runHaxeCode("game.controls._"..controlsArray[i]..".removeAll();")
			if stringStartsWith(controlsArray[i], "ui_") or stringStartsWith(controlsArray[i], "note_") then
				runHaxeCode("game.controls._"..controlsArray[i].."P.removeAll();")
				runHaxeCode("game.controls._"..controlsArray[i].."R.removeAll();")
			end
		end
		runHaxeCode([[
			FlxG.sound.muteKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.volumeUpKeys = [];
		]])
		setProperty("keysArray", {-1, -1, -1, -1})
	else
		for i = 1, #controlsArray do
			local things = runHaxeCode("return ClientPrefs.keyBinds.get('"..controlsArray[i].."');")
			for i1 = 1, #things do
				if things[i1] ~= -1 then
					if stringStartsWith(controlsArray[i], "ui_") or stringStartsWith(controlsArray[i], "note_") then
						print(controlsArray[i], things[i1])
						runHaxeCode("game.controls._"..controlsArray[i]..".addKey("..things[i1]..", 1);")
						runHaxeCode("game.controls._"..controlsArray[i].."P.addKey("..things[i1]..", 2);")
						runHaxeCode("game.controls._"..controlsArray[i].."R.addKey("..things[i1]..", -1);")
					else
						runHaxeCode("game.controls._"..controlsArray[i]..".addKey("..things[i1]..", 2);")
					end
				end
			end
		end
		runHaxeCode([[
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
		]])

		setProperty("keysArray", keysArray)
	end
end