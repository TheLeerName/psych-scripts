-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: nps display in score txt like how in Kade Engine
-- How to use:
--   1. Put this script in mods/scripts
--   2. Now you have NPS display <3

local maxTime = 1000 -- milliseconds
local nps = 0

function onCreate()
  if version == '0.7' then
    luaDebugMode = true
    debugPrint('what you know about rollin down in the deep '..version)
  end
end

local notesTable = {}
function goodNoteHit(id, data, type, sus)
	table.insert(notesTable, getPropertyFromGroup("notes", id, "strumTime"))
end
function onUpdate(elapsed)
	for i = 1, #notesTable do
		if getSongPosition() - maxTime > notesTable[i] then
			table.remove(notesTable, i)
			i = i - 1
		end
	end
	nps = #notesTable
	setProperty("scoreTxt.text", "Score: "..getProperty('songScore')..' | Misses: '..getProperty('songMisses')..' | Rating: '..getProperty('ratingName')..(getProperty('ratingName') ~= '?' and ' ('..(math.floor(getProperty('ratingPercent') * 10000) / 100)..'%) - '..getProperty('ratingFC') or '')..' | NPS: '..nps)
end