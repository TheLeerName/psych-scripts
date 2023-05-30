-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: keybinds of certain notes or keyboard mechanic
-- Source (you need be on Psych Engine discord server): https://discord.com/channels/922849922175340586/1104949534041309206/1104949534041309206
-- If you want use it in your mod, just credit me <3

------------------------------------- config started -------------------------------------

-- script is enabled?
local enabled = true

-- if true, labels of keybind not shown, idk why
local noLabels = false

-- if true, script affects on opponent side too
local affectOpponentSide = false

-- random (keybinds randomized), shift (keybind shifted by 1 each note), default (Q = left, W = down, E = up, R = right)
local mode = "random"

-- index of difficulty in `keys` variable below
local currentDifficulty = 3

-- all difficulty modes
local keys = {
	"QW", -- 1
	"QWER", -- 2
	"QWERTY", -- 3
	"QWERTYUIOP", -- 4
	"QWERTYUIOPASDFGHJKLZXCVBNM" -- 5 - all letters of keyboard :trollface:
}

-- size of font in labels
local labelSize = 48

-------------------------------------- config ended --------------------------------------
------------ change everything you want in bottom if you know what you doing -------------

function onCreatePost()
	if enabled then
		generateLabels()
	end
end

function generateLabels()
	-- idk game.add not adding it properly, using game.insert
	runHaxeCode("game.notes.memberAdded.add(function (member) { if (member.extraData.exists('label')) game.insert(game.length - 1, member.extraData.get('label')); });")
	runHaxeCode("game.notes.memberRemoved.add(function (member) { if (member.extraData.exists('label')) member.extraData.get('label').destroy(); });")

	addHaxeLibrary('ModchartText')
	local keystable = stringSplit(keys[currentDifficulty], "")
	local index = 1
	for i = 0, getProperty("unspawnNotes.length") - 1 do
		if not getProperty("unspawnNotes["..i.."].isSustainNote") and (affectOpponentSide or getProperty("unspawnNotes["..i.."].mustPress")) then
			--local curKey = keystable[getProperty("unspawnNotes["..i.."].noteData") + 1]
			local curKey = "Q"
			if mode == "random" then curKey = keystable[getRandomInt(1, #keystable)] end
			if mode == "default" then curKey = stringSplit(keys[2], "")[getProperty("unspawnNotes["..i.."].noteData") + 1] end
			if mode == "shift" then
				curKey = keystable[index]
				index = index + 1
				if index > #keystable then index = 1 end
			end

			if not noLabels then
				setPropertyFromExtraData("unspawnNotes["..i.."]", "label", "new ModchartText(game.unspawnNotes[ "..i.." ].x, game.unspawnNotes[ "..i.." ].y, '"..curKey.."', game.unspawnNotes[ "..i.." ].width)", true)
				setPropertyFromLabel("unspawnNotes["..i.."]", "size", labelSize)
			end
			setPropertyFromExtraData("unspawnNotes["..i.."]", "key", curKey)
		end
	end
	for i = 0, getProperty("unspawnNotes.length") - 1 do
		if getProperty("unspawnNotes["..i.."].isSustainNote") and runHaxeCode("return game.unspawnNotes["..i.."].parent.extraData.exists('key');") then
			setPropertyFromExtraData("unspawnNotes["..i.."]", "key", getPropertyFromExtraData("unspawnNotes["..i.."].parent", "key"))
		end
	end
end

function onUpdate(elapsed)
	if enabled then
		runHaxeCode("game.keysArray = [[-1], [-1], [-1], [-1]];")
		for i = 0, getProperty("notes.length") - 1 do
			if runHaxeCode("return game.notes.members["..i.."].extraData.exists('label');") then
				setPropertyFromLabel("notes.members["..i.."]", "x", getPropertyFromGroup("notes", i, "x"))
				setPropertyFromLabel("notes.members["..i.."]", "y", getPropertyFromGroup("notes", i, "y") + (getPropertyFromGroup("notes", i, "height") / 4))
				setPropertyFromLabel("notes.members["..i.."]", "fieldWidth", getPropertyFromGroup("notes", i, "width"))
			end

			if getProperty("keysArray["..getPropertyFromGroup("notes", i, "noteData").."][0]") == -1 and
				getPropertyFromGroup('notes', i, 'canBeHit') and not getPropertyFromGroup('notes', i, 'wasGoodHit')
				and getPropertyFromGroup('notes', i, 'mustPress') and not getPropertyFromGroup('notes', i, 'tooLate') then 
					setProperty("keysArray["..getPropertyFromGroup("notes", i, "noteData").."]", {getKeyFromName(getPropertyFromExtraData("notes.members["..i.."]", "key"))})
			end 
		end

		for i = 0, getProperty("notes.length") - 1 do
			-- copied from extra keys hscript lololol
			--need to check if holding sustains because psych dumb and still uses shitty controls.hx
			if runHaxeCode('return FlxG.keys.anyPressed(game.keysArray['..getPropertyFromGroup("notes", i, "noteData")..']);') then
				if getPropertyFromGroup('notes', i, 'isSustainNote') and getPropertyFromGroup('notes', i, 'canBeHit') and not getPropertyFromGroup('notes', i, 'wasGoodHit')
				and getPropertyFromGroup('notes', i, 'mustPress') and not getPropertyFromGroup('notes', i, 'tooLate') then 
					runHaxeCode("game.goodNoteHit(game.notes.members["..i.."]);")
				end
			end
		end
	end
end

-- like in botplay, idk how do key release properly
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if enabled then
		setProperty("playerStrums.members["..noteData.."].resetAnim", 0.3)
	end
end

function findInTable(table, find)
	for i, key in ipairs(table) do
		if key == find then return true end
	end
	return false
end


function getPropertyFromLabel(variable, property)
	addHaxeLibrary("Reflect")
	return runHaxeCode("Reflect.getProperty(game."..variable..".extraData.get('label'), '"..property.."');")
end
-- raw : boolean - if true, not adds brackets in value, allows do this: setPropertyFromLabel("unspawnNotes[0]", "txtObject", "new FlxText()", true)
function setPropertyFromLabel(variable, property, value, raw)
	if type(value) == "string" and not raw then value = "'"..value.."'" else value = tostring(value) end
	addHaxeLibrary("Reflect")
	runHaxeCode("Reflect.setProperty(game."..variable..".extraData.get('label'), '"..property.."', "..value..");")
end


function getPropertyFromExtraData(variable, property)
	return runHaxeCode("game."..variable..".extraData.get('"..property.."');")
end
-- raw : boolean - if true, not adds brackets in value, allows do this: setPropertyFromExtraData("unspawnNotes[0]", "txtObject", "new FlxText()", true)
function setPropertyFromExtraData(variable, property, value, raw)
	if type(value) == "string" and not raw then value = "'"..value.."'" else value = tostring(value) end
	runHaxeCode("game."..variable..".extraData.set('"..property.."', "..value..");")
end


function getKeyFromName(name)
	return runHaxeCode([[
		var keyMap = [
			"A" => 65,
			"ALT" => 18,
			"ANY" => -2,
			"B" => 66,
			"BACKSLASH" => 220,
			"BACKSPACE" => 8,
			"BREAK" => 19,
			"C" => 67,
			"CAPSLOCK" => 20,
			"COMMA" => 188,
			"CONTROL" => 17,
			"D" => 68,
			"DELETE" => 46,
			"DOWN" => 40,
			"E" => 69,
			"EIGHT" => 56,
			"END" => 35,
			"ENTER" => 13,
			"ESCAPE" => 27,
			"F" => 70,
			"F1" => 112,
			"F10" => 121,
			"F11" => 122,
			"F12" => 123,
			"F2" => 113,
			"F3" => 114,
			"F4" => 115,
			"F5" => 116,
			"F6" => 117,
			"F7" => 118,
			"F8" => 119,
			"F9" => 120,
			"FIVE" => 53,
			"FOUR" => 52,
			"G" => 71,
			"GRAVEACCENT" => 192,
			"H" => 72,
			"HOME" => 36,
			"I" => 73,
			"INSERT" => 45,
			"J" => 74,
			"K" => 75,
			"L" => 76,
			"LBRACKET" => 219,
			"LEFT" => 37,
			"M" => 77,
			"MENU" => 302,
			"MINUS" => 189,
			"N" => 78,
			"NINE" => 57,
			"NONE" => -1,
			"NUMLOCK" => 144,
			"NUMPADEIGHT" => 104,
			"NUMPADFIVE" => 101,
			"NUMPADFOUR" => 100,
			"NUMPADMINUS" => 109,
			"NUMPADMULTIPLY" => 106,
			"NUMPADNINE" => 105,
			"NUMPADONE" => 97,
			"NUMPADPERIOD" => 110,
			"NUMPADPLUS" => 107,
			"NUMPADSEVEN" => 103,
			"NUMPADSIX" => 102,
			"NUMPADSLASH" => 111,
			"NUMPADTHREE" => 99,
			"NUMPADTWO" => 98,
			"NUMPADZERO" => 96,
			"O" => 79,
			"ONE" => 49,
			"P" => 80,
			"PAGEDOWN" => 34,
			"PAGEUP" => 33,
			"PERIOD" => 190,
			"PLUS" => 187,
			"PRINTSCREEN" => 301,
			"Q" => 81,
			"QUOTE" => 222,
			"R" => 82,
			"RBRACKET" => 221,
			"RIGHT" => 39,
			"S" => 83,
			"SCROLL_LOCK" => 145,
			"SEMICOLON" => 186,
			"SEVEN" => 55,
			"SHIFT" => 16,
			"SIX" => 54,
			"SLASH" => 191,
			"SPACE" => 32,
			"T" => 84,
			"TAB" => 9,
			"THREE" => 51,
			"TWO" => 50,
			"U" => 85,
			"UP" => 38,
			"V" => 86,
			"W" => 87,
			"WINDOWS" => 15,
			"X" => 88,
			"Y" => 89,
			"Z" => 90,
			"ZERO" => 48,
		];
		return keyMap.get(']]..string.upper(name)..[[');
	]]) or -1
end