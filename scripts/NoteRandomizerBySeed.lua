-- VERY WARNING: USES PSYCH ENGINE 0.6.1 AND LATER
-- WARNING: if script enabled, edits from chart editor not saves! (chart will always be overwritten to "song_placeholder".json)

-- Author: TheLeerName
-- Source: https://gamebanana.com/tools/10192
-- Description: script does randomizing notes by current seed
-- Version: 5 - Fixed normal difficulty
local NR_currentSeed = '0303'
local NR_createText = false
local NR_cutTextOn = -1
local NR_colorText = "008000"
local NR_enabled = true
function onCreate()
	--luaDebugMode = true
	NR_enabled = parseBool(getOption('NR_enabled'))
	if NR_enabled then
		NR_createText = parseBool(getOption('NR_createText'))
		NR_cutTextOn = tonumber(getOption('NR_cutTextOn'))
		NR_colorText = getOption('NR_colorText')
		if getOption('NR_currentSeed') == '0' then
			NR_currentSeed = ''..os.time()
			print('[Note Randomizer] Seed: '..NR_currentSeed..' (system time)')
		else
			NR_currentSeed = getOption('NR_currentSeed')
			print('[Note Randomizer] Seed: '..NR_currentSeed)
		end

		addHaxeLibrary('FlxRandom', 'flixel.math')
		addHaxeLibrary('String')
		addHaxeLibrary('Sys')
		addHaxeLibrary('Song')
		addHaxeLibrary('Paths')
		addHaxeLibrary('CoolUtil')
		-- rewritten from js to haxe https://stackoverflow.com/a/8076436
		runHaxeCode([[
			var song = Paths.formatToSongPath(PlayState.SONG.song);
			var folder = song;
			if (Paths.formatToSongPath(CoolUtil.difficulties[PlayState.storyDifficulty]) != 'normal')
				song += '-' + Paths.formatToSongPath(CoolUtil.difficulties[PlayState.storyDifficulty]);
			PlayState.SONG = Song.loadFromJson(song, folder);
			//trace('loaded: data/' + folder + '/' + song + '.json');
			var seed_pr = "]]..NR_currentSeed..[[";
			var seed = 0;
	
			for (i in 0...seed_pr.length)
			{
				var code = seed_pr.charCodeAt(i);
				seed += (seed << 5) + code;
				//trace(code + ' -> ' + seed_pr.charAt(i) + ' = ' + seed);
			}
			//Sys.println('[Note Randomizer] Seed: ' + seed_pr);
			Sys.println('[Note Randomizer] Hash: ' + seed);
			var noterandomizer = new FlxRandom(seed);

			for (section in PlayState.SONG.notes)
				for (songNotes in section.sectionNotes)
				{
					if (songNotes[1] >= 0 && songNotes[1] <= 3)
						songNotes[1] = noterandomizer.int(1, 4) - 1;
					else if (songNotes[1] >= 4 && songNotes[1] <= 7)
						songNotes[1] = noterandomizer.int(5, 8) - 1;
				}
			var overlaps = 0;
			var or = false;
			while (or == false)
			{
				or = true;
				for (i in 0...PlayState.SONG.notes.length)
				{
					PlayState.SONG.notes[i].sectionNotes.sort((a, b) -> a[0] - b[0]);
					PlayState.SONG.notes[i].sectionNotes.sort((a, b) -> a[1] - b[1]);
					for (i1 in 0...PlayState.SONG.notes[i].sectionNotes.length)
					{
						if (i1 > 0)
						{
							//trace(PlayState.SONG.notes[i].sectionNotes[i1][0] + ' | ' + PlayState.SONG.notes[i].sectionNotes[i1][1]);
							if ((PlayState.SONG.notes[i].sectionNotes[i1 - 1][0] == PlayState.SONG.notes[i].sectionNotes[i1][0]) && (PlayState.SONG.notes[i].sectionNotes[i1 - 1][1] == PlayState.SONG.notes[i].sectionNotes[i1][1]))
							{
								if (PlayState.SONG.notes[i].sectionNotes[i1][1] >= 0 && PlayState.SONG.notes[i].sectionNotes[i1][1] <= 3)
									PlayState.SONG.notes[i].sectionNotes[i1][1] = noterandomizer.int(1, 4, [ PlayState.SONG.notes[i].sectionNotes[i1][1] + 1 ]) - 1;
								else if (PlayState.SONG.notes[i].sectionNotes[i1][1] >= 4 && PlayState.SONG.notes[i].sectionNotes[i1][1] <= 7)
									PlayState.SONG.notes[i].sectionNotes[i1][1] = noterandomizer.int(5, 8, [ PlayState.SONG.notes[i].sectionNotes[i1][1] + 1 ]) - 1;
								overlaps++;
								or = false;
							}
						}
					}
				}
			}
			if (overlaps > 0)
				Sys.println('[Note Randomizer] Fixed ' + overlaps + ' overlapped notes!')
		]])
	end
end

function onCreatePost()
	if NR_createText and NR_enabled then
		local text = ''
			if NR_cutTextOn > -1 and #NR_currentSeed > NR_cutTextOn then
				text = 'Note Randomizer ON\nSeed: '..string.sub(NR_currentSeed, 0, NR_cutTextOn)..'...'
			else
				text = 'Note Randomizer ON\nSeed: '..NR_currentSeed
			end
		makeLuaText('NR_text', text, screenWidth, screenWidth * -0.01, screenHeight * 0.94)
		setObjectCamera('NR_text', 'camHUD')
		setTextAlignment('NR_text', 'right')
		setTextColor('NR_text', NR_colorText)
		setTextBorder('NR_text', 1, '000000')
		addLuaText('NR_text')
	end
end


local optionFile = nil
function getOption(option)
	if optionFile == nil then
		if not checkFileExists('mods/seed.txt', true) then
			createOptions()
		end
		local options = getText('mods/seed.txt')
		optionFile = split(options, '\n')
		if not endsWith(optionFile[1], 'v4') then
			print('[Note Randomizer] Updated seed.txt!')
			createOptions()
			options = getText('mods/seed.txt')
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
	saveFile('mods/seed.txt', 'note randomizer file format v4\n\n// enables Note Randomizer system\nNR_enabled = true\n\n// enter your seed there, if 0 then uses system time\nNR_currentSeed = 0\n\n// creates a bottom right text with seed in song\nNR_createText = true\n\n// color in hex value of bottom right text\nNR_colorText = 008000\n\n// cuts seed in text if it longer than that value, if -1 then not cuts\nNR_cutTextOn = 25', true)
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