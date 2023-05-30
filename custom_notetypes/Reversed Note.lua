-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: reversed note type like in gamebreaker (idk what is it)
-- How to use:
--   1. Put this script in mods/custom_notetypes
--   2. Now go to chart editor and make notes with this type <3

function onCreatePost()
	for i, noteGroup in ipairs({"unspawnNotes", "notes"}) do
		for i = 0, getProperty(noteGroup..".length") - 1 do
			if getPropertyFromGroup(noteGroup, i, 'noteType') == "Reversed Note" then
				setFromExtraData(noteGroup, i, 'initialStrumTime', getPropertyFromGroup(noteGroup, i, 'strumTime'))
				setPropertyFromGroup(noteGroup, i, "strumTime", getFromExtraData(noteGroup, i, 'initialStrumTime') + getProperty("spawnTime"))
				setPropertyFromGroup(noteGroup, i, "noAnimation", true)
				setPropertyFromGroup(noteGroup, i, "ignoreNote", true)
				setPropertyFromGroup(noteGroup, i, "copyY", false)
				if getPropertyFromGroup(noteGroup, i, "isSustainNote") then
					setPropertyFromGroup(noteGroup, i, "flipY", not getPropertyFromClass("ClientPrefs", "downScroll"))
				end
			end
		end
	end
	setPropertyFromClass("ClientPrefs", "downScroll", true)
end

function setFromExtraData(noteGroup, id, varName, value)
	if noteGroup ~= "unspawnNotes" then noteGroup = noteGroup..".members" end
	if type(value) == "string" then value = '"'..value..'"' end
	runHaxeCode("game."..noteGroup.."["..id.."].extraData.set('"..varName.."', "..value..");")
end
function getFromExtraData(noteGroup, id, varName)
	if noteGroup ~= "unspawnNotes" then noteGroup = noteGroup..".members" end
	return runHaxeCode("return game."..noteGroup.."["..id.."].extraData.get('"..varName.."');")
end
function existsFromExtraData(noteGroup, id, varName)
	if noteGroup ~= "unspawnNotes" then noteGroup = noteGroup..".members" end
	return runHaxeCode("return game."..noteGroup.."["..id.."].extraData.exists('"..varName.."');")
end

function onSpawnNote(id, noteData, noteType, isSustainNote)
	if getPropertyFromGroup("notes", id, "noteType") == "Reversed Note" then
		local idiot = 'dad'
		if getPropertyFromGroup("notes", id, "mustPress") then idiot = "boyfriend" end
		playAnim(idiot, getProperty('singAnimations')[noteData + 1], true)
		setProperty(idiot..'.holdTimer', 0)
	end
end

function onUpdatePost()
	--setProperty("camHUD.zoom", 0.2) -- just for check of notes out of screen
	for i = 0, getProperty("notes.length") - 1 do
		if getPropertyFromGroup("notes", i, "noteType") == "Reversed Note" then
			local noteGroup = 'opponentStrums'
			if getPropertyFromGroup("notes", i, "mustPress") then noteGroup = "playerStrums" end

			local angleDir = getPropertyFromGroup(noteGroup, getPropertyFromGroup("notes", i, "noteData"), "direction") * math.pi / 180

			local noteDistance = (getPropertyFromClass("Conductor", "songPosition") - getPropertyFromGroup("notes", i, "strumTime")) * getProperty("songSpeed") * getPropertyFromGroup("notes", i, "multSpeed")
			if getPropertyFromClass("ClientPrefs", "downScroll") then
				noteDistance = (noteDistance * -0.45) - (getProperty('spawnTime') * (getProperty('songSpeed') / 2.3))
			else
				noteDistance = (noteDistance * 0.45) + (getProperty('spawnTime') * (getProperty('songSpeed') / 2.3))
			end

			setPropertyFromGroup("notes", i, "y", 1 * (getPropertyFromGroup(noteGroup, getPropertyFromGroup("notes", i, "noteData"), "y") + math.sin(angleDir) * noteDistance))
		end
	end
end