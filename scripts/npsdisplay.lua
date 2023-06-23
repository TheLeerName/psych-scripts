-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: nps display in score txt like how in Kade Engine
-- How to use:
--   1. Put this script in mods/scripts
--   2. Now you have NPS display <3

local NPS = 0
local maxNPS = 0

local notesTable = {}
function goodNoteHit(id, data, type, sus)
	table.insert(notesTable, getPropertyFromGroup("notes", id, "strumTime"))
end
function onUpdate(elapsed)
	for i = 1, #notesTable do
		if getSongPosition() - 1000 > notesTable[i] then
			table.remove(notesTable, i)
			i = i - 1
		end
	end
	NPS = #notesTable
	if NPS > maxNPS then maxNPS = NPS end
	setProperty("scoreTxt.text", 
		"Score: "..getProperty('songScore')..
		' | Misses: '..getProperty('songMisses')..
		' | Rating: '..getProperty('ratingName')..(getProperty('ratingName') ~= '?' and ' ('..(math.floor(getProperty('ratingPercent') * 10000) / 100)..'%) - '..getProperty('ratingFC') or '')..
		' | NPS: '..NPS
	)
end
