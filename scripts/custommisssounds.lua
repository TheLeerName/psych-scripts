-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: custom miss sounds
-- How to use:
--   1. Put this script in mods/scripts
--   2. Change missSoundsName table for ur custom miss sounds

local missSoundsName = {
	"bruh1",
	"bruh2"
}
function onCreatePost()
	addHaxeLibrary("Sound", "openfl.media")
	runHaxeCode([[
		Paths.currentTrackedSounds.set("missnote1", new Sound());
		Paths.currentTrackedSounds.set("missnote2", new Sound());
		Paths.currentTrackedSounds.set("missnote3", new Sound());
	]])
	for i = 1, #missSoundsName do
		precacheSound(missSoundsName[i])
	end
end
function noteMissPress(direction)
	if not getProperty("boyfriend.stunned") then
		playSound(missSoundsName[getRandomInt(1, #missSoundsName)], getRandomFloat(0.1, 0.2))
	end
end