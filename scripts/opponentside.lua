-- WARNING: USES PSYCH ENGINE 0.6.1 AND LATER

-- Author: TheLeerName
-- Description: script make possible to play opponent side
-- Version: 2 - Fixed all and added option file

local OF_enabled = true
function onCreate()
	--luaDebugMode = true
	OF_enabled = parseBool(getOption('OF_enabled'))
		
	if OF_enabled then
		if not getPropertyFromClass('ClientPrefs', 'opponentStrums') then
			print('[Play as Opponent] Opponent Notes option was disabled, so script will be disabled too.')
			OF_enabled = false
		else
			print('[Play as Opponent] Script enabled')
			addHaxeLibrary('String')
			addHaxeLibrary('Sys')
			addHaxeLibrary('Song')
			addHaxeLibrary('Paths')
			addHaxeLibrary('CoolUtil')
			runHaxeCode([[
				var song = Paths.formatToSongPath(PlayState.SONG.song);
				var folder = song;
				if (Paths.formatToSongPath(CoolUtil.difficulties[PlayState.storyDifficulty]) != 'normal')
					song += '-' + Paths.formatToSongPath(CoolUtil.difficulties[PlayState.storyDifficulty]);
				PlayState.SONG = Song.loadFromJson(song, folder);
				//trace('loaded: data/' + folder + '/' + song + '.json');

				for (section in PlayState.SONG.notes)
				{
					if (section.mustHitSection == true)
						section.mustHitSection = false;
					else
						section.mustHitSection = true;
				}
			]])
		end
	end
end
function onCreatePost()
	if OF_enabled then
		addHaxeLibrary('ClientPrefs')
		runHaxeCode([[
			for (note in game.unspawnNotes)
			{
				note.noAnimation = true;
				note.noMissAnimation = true;
			}

			if (!ClientPrefs.middleScroll)
				for (i in 0...game.playerStrums.length)
				{
					var d1 = [game.playerStrums.members[i].x, game.playerStrums.members[i].y];
					var d2 = [game.opponentStrums.members[i].x, game.opponentStrums.members[i].y];

					game.opponentStrums.members[i].x = d1[0];
					game.opponentStrums.members[i].y = d1[1];

					game.playerStrums.members[i].x = d2[0];
					game.playerStrums.members[i].y = d2[1];
				}
		]])
	end
end
function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if OF_enabled then
		triggerEvent('Play Animation', 'sing'..getNote(noteData), 'bf')
	end
end
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if OF_enabled then
		triggerEvent('Play Animation', 'sing'..getNote(noteData), 'dad')
	end
end
function noteMiss(id, noteData, noteType, isSustainNote)
	if OF_enabled then
		triggerEvent('Play Animation', 'sing'..getNote(noteData)..'miss', 'dad')
	end
end
function getNote(noteData)
	local g = {'LEFT', 'DOWN', 'UP', 'RIGHT'}
	return g[noteData + 1]
end


-- option file things
local optionFilePath = 'mods/opside.txt'
local curVersion = 1
local optionFile = nil
function getOption(option)
	if optionFile == nil then
		if not checkFileExists(optionFilePath, true) then
			createOptions()
		end
		local options = getText(optionFilePath)
		optionFile = split(options, '\n')
		if not endsWith(optionFile[1], 'v'..curVersion) then
			print('[Play as Opponent] Updated '..optionFilePath..'!')
			createOptions()
			options = getText(optionFilePath)
			optionFile = split(options, '\n')
		end
	end
	for i = 1, #optionFile do
		local p = string.gsub(optionFile[i], "%s+", "")
		if startsWith(p, option) then
			return string.sub(p, string.find(p, "=") + 1, #p)
		end
	end
end
-- why the fuck getTextFromFile() gets text only from assets folder?????
function getText(file)
	addHaxeLibrary('File', 'sys.io')
	runHaxeCode([[ PlayState.instance.introSoundsSuffix = File.getContent("]]..file..[["); ]])
	local dat = getProperty('introSoundsSuffix');
	runHaxeCode([[ PlayState.instance.introSoundsSuffix = ''; ]])
	return dat;
end

function createOptions()
	saveFile(optionFilePath, 'play as opponent file format v1\n\n// enables play as opponent script\nOF_enabled = true', true)
end

function parseBool(str)
	if str == 'true' or str == 'on' or str == 'y' or str == 'yes' or str == '1' then
		return true
	else
		return false
	end
end
function startsWith(str, start)
	return string.sub(str, 1, #start) == start
end
function endsWith(str, ending)
    return string.sub(str, -#ending) == ending
end
function split(str, sep)
	local t = {}
	local i = 0
	if sep == nil or sep == ' ' then
		sep = '%s'
	end
	for str1 in string.gmatch(str, "([^"..sep.."]+)") do
			--print(i, str1)
			--str1 = string.sub(str1, #sep)
			table.insert(t, str1)
			i = i + 1
	end
	i = 0
	return t
end