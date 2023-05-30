-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: Importing songs from osu to fnf
-- Dependencies:
--   Need much of it, you can find it in source below
-- Source (join to Psych Engine discord server): https://discord.com/channels/922849922175340586/1053260521773740032/1053260521773740032

local logLines = {}
local osu_directory = ""
function onStartCountdown()
	--luaDebugMode = true
	if songName == "Import Osu Songs" then
		addHaxeLibrary("FileSystem", "sys")
		addHaxeLibrary("File", "sys.io")
		addHaxeLibrary("FlxButton", "flixel.ui")
		addHaxeLibrary("FlxText", "flixel.text")
		addHaxeLibrary("FlxRandom", "flixel.math")
		addHaxeLibrary("ColorSwap")
		addHaxeLibrary("Sys")
		addHaxeLibrary("String")
		addHaxeLibrary("Math")
		osu_directory = string.gsub(runHaxeCode([[return Sys.getEnv("UserProfile");]]), "\\", "/").."/AppData/Local/osu!"
		create_func()
		return Function_Stop
	end
end

local direc = ''
function onDestroy()
	local dat = ''
	for i = 1, #logLines do
		dat = dat..logLines[i]..'\n'
	end
	saveFile(direc..'/log.txt', dat, true);
	setPropertyFromClass("flixel.FlxG", "mouse.visible", false)
	setPropertyFromClass("Main", "fpsVar.visible", getPropertyFromClass("ClientPrefs", "showFPS"))
end

function addLog(str, isError)
	print(str)
	local lol = ''
	local redColor = "false"
	if isError then
		lol = ' [ERROR] '
		redColor = "true"
		playSound('missnote'..getRandomInt(1, 3))
	else
		lol = ' [TRACE] '
		redColor = "false"
	end
	runHaxeCode([[
		var curLength:Int = 0;
		for (txt in getVar("import_objects"))
			curLength += txt.height + 10;

		var txta:FlxText = new FlxText(FlxG.width * 0.65 + 10, 35 + curLength, FlxG.width * 0.35 - 20, ']]..fixStr(str)..[[');
		txta.setFormat(Paths.font("vcr.ttf"), 16, "]]..redColor..[[" == "true" ? 0xffff0000 : 0xffffffff, "left");
		txta.scrollFactor.set();
		txta.borderSize = 1;
		txta.cameras = [game.camOther];
		game.add(txta);
		getVar("import_objects").push(txta);
	]])

	table.insert(logLines, os.date()..lol..str)
end

-- ayo text has own color!!!!!!!!!!!!
local currentSeed = 303
function stringToColor(str)
	local rand = runHaxeCode([[
		var rnd = new FlxRandom(]]..currentSeed..[[);
		return rnd.int(0, ]]..#str..[[ - 25);
	]])
	if #str > 25 then
		str = string.sub(str, 1 + rand, 25 + rand)
	end
	local ar = {string.byte(str, 1, -1)}
	local toret = 0
	for i = 1, #ar do
		toret = toret + BitOR(toret, ar[i])
	end
	if toret > 0xffffffff then
		toret = 0xffffffff
	end
	return math.floor(toret)
end

-- https://stackoverflow.com/a/25594410
function BitOR(a,b)--Bitwise or
    local p,c=1,0
    while a+b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>0 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c
end

function create_func()
	runHaxeCode("setVar('import_objects', []);")
	runHaxeCode("setVar('osuparse_objects', []);")
	setPropertyFromClass("flixel.FlxG", "mouse.visible", true)
	setPropertyFromClass("Main", "fpsVar.visible", false)
	setProperty("camGame.alpha", 0)
	setProperty("camHUD.alpha", 0)

	makeLuaSprite("bg", "menuBGBlue", 0, 0)
	setProperty("bg.alpha", 0.4)
	addLuaSprite("bg")
	setObjectCamera("bg", "camother")
	runHaxeCode([[
		setVar("bg_colorSwap", new ColorSwap());
		getVar("bg_colorSwap").hue = 0;
		getVar("bg_colorSwap").saturation = -0.5;
		game.modchartSprites.get('bg').shader = getVar("bg_colorSwap").shader;
	]])

	makeLuaSprite("bg_import", nil, screenWidth * 0.65, 0)
	makeGraphic("bg_import", screenWidth * 0.35, screenHeight, "000000")
	setProperty("bg_import.alpha", 0.2)
	addLuaSprite("bg_import")
	setObjectCamera("bg_import", "camother")

	makeLuaSprite("bg_osuparse", nil, 0, 0)
	makeGraphic("bg_osuparse", screenWidth * 0.35 + 3, screenHeight, "000000")
	setProperty("bg_osuparse.alpha", 0.2)
	addLuaSprite("bg_osuparse")
	setObjectCamera("bg_osuparse", "camother")

	runHaxeCode([[
		var button_exit:FlxButton = new FlxButton(FlxG.width * 0.5, FlxG.height * 0.9, "EXIT MENU");
		button_exit.setGraphicSize(200, 35);
		button_exit.updateHitbox();
		button_exit.labelOffsets.y = 10;
		button_exit.label.setFormat(Paths.font("vcr.ttf"), 24, 0xff000000, "center");
		button_exit.label.fieldWidth = 200;
		button_exit.x -= button_exit.label.textField.width / 2;
		button_exit.color = 0xffff0000;
		button_exit.cameras = [game.camOther];
		game.add(button_exit);
		setVar("button_exit", button_exit);
	]])

	runHaxeCode([[
		var button_clearconv:FlxButton = new FlxButton(FlxG.width * 0.5, 0, "CLEAR CONVERTED SONGS");
		button_clearconv.setGraphicSize(350, 35);
		button_clearconv.updateHitbox();
		button_clearconv.labelOffsets.y = 10;
		button_clearconv.label.setFormat(Paths.font("vcr.ttf"), 24, 0xff000000, "center");
		button_clearconv.label.fieldWidth = 350;
		button_clearconv.x -= button_clearconv.label.textField.width / 2;
		button_clearconv.color = 0xffff0000;
		button_clearconv.cameras = [game.camOther];
		game.add(button_clearconv);
		setVar("button_clearconv", button_clearconv);
	]])

	runHaxeCode([[
		var button_clearcache:FlxButton = new FlxButton(FlxG.width * 0.5, 35, "CLEAR SONG CACHE");
		button_clearcache.setGraphicSize(350, 35);
		button_clearcache.updateHitbox();
		button_clearcache.labelOffsets.y = 10;
		button_clearcache.label.setFormat(Paths.font("vcr.ttf"), 24, 0xff000000, "center");
		button_clearcache.label.fieldWidth = 350;
		button_clearcache.x -= button_clearcache.label.textField.width / 2;
		button_clearcache.color = 0xffff0000;
		button_clearcache.cameras = [game.camOther];
		game.add(button_clearcache);
		setVar("button_clearcache", button_clearcache);
	]])

	runHaxeCode([[
		var button_import:FlxButton = new FlxButton(FlxG.width * 0.65, 0, "START IMPORT");
		button_import.setGraphicSize(450, 35);
		button_import.updateHitbox();
		button_import.labelOffsets.y = 10;
		button_import.label.setFormat(Paths.font("vcr.ttf"), 24, 0xff000000, "center");
		button_import.label.fieldWidth = 450;
		button_import.color = 0xff00ff00;
		button_import.cameras = [game.camOther];
		game.add(button_import);
		setVar("button_import", button_import);
	]])

	runHaxeCode([[
		var button_osuparse:FlxButton = new FlxButton(0, 0, "IMPORT FROM OSU FOLDER");
		button_osuparse.setGraphicSize(450, 35);
		button_osuparse.updateHitbox();
		button_osuparse.labelOffsets.y = 10;
		button_osuparse.label.setFormat(Paths.font("vcr.ttf"), 24, 0xff000000, "center");
		button_osuparse.label.fieldWidth = 450;
		button_osuparse.color = 0xffffc0cb;
		button_osuparse.cameras = [game.camOther];
		game.add(button_osuparse);
		setVar("button_osuparse", button_osuparse);
	]])

	if not exists(direc.."/songcache") then
		createDirectory(direc.."/songcache")
	end
end

local hue = 0
local hueSpeed = 0.5
local osuparse_folders = {}
function onUpdate(elapsed)
	if songName == "Import Osu Songs" then
		if getPropertyFromClass("flixel.FlxG", "keys.justPressed.ESCAPE") or getProperty("button_exit.status") == 2 then
			endSong()
		end
		if getProperty("button_clearconv.status") == 2 then
			clearConvertedSongs()
		end
		if getProperty("button_clearcache.status") == 2 then
			if getProperty("button_clearcache.label.text") == "CLEAR SONG CACHE" then
				setProperty("button_clearcache.label.text", "Are You Sure?")
				setProperty("button_clearcache.y", getProperty("button_clearcache.y") + 35)
				setProperty("button_clearcache.color", 0xda5cd0)
			else
				clearSongCache()
				setProperty("button_clearcache.label.text", "CLEAR SONG CACHE")
				setProperty("button_clearcache.y", getProperty("button_clearcache.y") - 35)
				setProperty("button_clearcache.color", 0xff0000)
			end
		end
		if getProperty("button_import.status") == 2 then
			startImport()
		end
		if getProperty("button_osuparse.status") == 2 then
			getOsuFolders()
		end


		for i = 1, #osuparse_folders do
			if runHaxeCode([[return getVar("osuparse_objects")[ ]]..tostring(i - 1)..[[ ].status;]]) == 2 then
				if not exists(runHaxeCode([[return Paths.modFolders("songcache");]]).."/"..osuparse_folders[i]) then
					createDirectory(runHaxeCode([[return Paths.modFolders("songcache");]]).."/"..osuparse_folders[i])
					local osu_folder = runHaxeCode([[return FileSystem.readDirectory("]]..osu_directory..[[/Songs/]]..osuparse_folders[i]..[[");]])
					for i1 = 1, #osu_folder do
						runHaxeCode([[File.saveBytes(Paths.modFolders("songcache") + "]].."/"..osuparse_folders[i].."/"..osu_folder[i1]..[[", File.getBytes("]]..osu_directory.."/Songs/"..osuparse_folders[i].."/"..osu_folder[i1]..[["));]])
						--runHaxeCode([[File.copy("]]..osu_directory.."/Songs/"..osuparse_folders[i].."/"..osu_folder[i1]..[[", Paths.modFolders("songcache") + "]].."/"..osuparse_folders[i].."/"..osu_folder[i1]..[[");]])
						--saveContent(runHaxeCode([[return Paths.modFolders("songcache");]]).."/"..osuparse_folders[i].."/"..osu_folder[i], getContent(osu_directory.."/Songs/"..osuparse_folders[i].."/"..osu_folder[i]))
					end
					addLog(osuparse_folders[i]..": Successfully imported!")
				else
					addLog(osuparse_folders[i]..": Folder was already imported!", true)
				end
				break
			end
		end

		if runHaxeCode([[FlxG.mouse.overlaps(game.modchartSprites.get("bg_import"), game.camOther);]]) and getPropertyFromClass("flixel.FlxG", "mouse.wheel") ~= 0 then
			runHaxeCode([[
				for (txt in getVar("import_objects"))
				{
					txt.y += FlxG.mouse.wheel > 0 ? 150 : -150;
					txt.visible = txt.y > 40;
				}
			]])
		end
		if runHaxeCode([[FlxG.mouse.overlaps(game.modchartSprites.get("bg_osuparse"), game.camOther);]]) and getPropertyFromClass("flixel.FlxG", "mouse.wheel") ~= 0 then
			runHaxeCode([[
				for (butt in getVar("osuparse_objects"))
				{
					butt.y += FlxG.mouse.wheel > 0 ? 150 : -150;
					butt.visible = butt.y > 30;
				}
			]])
		end

		hue = hue + hueSpeed
		if hue > 360 then
			hue = 0
		end
		setProperty("bg_colorSwap.hue", hue / 360)
	end
end
function toHex(num)
	local str = string.format("%x", num)
	if #str == 1 then
		str = "0"..str
	end
	return str
end

local maxNameLength = 44
function getOsuFolders()
	if exists(osu_directory) then
		local folders = runHaxeCode([[return FileSystem.readDirectory("]]..osu_directory..[[/Songs");]])
		osuparse_folders = folders
		for i = 1, #folders do
			local curColor = stringToColor(folders[i])
			runHaxeCode([[
				var cooltext:String = "]]..folders[i]..[[".substring("]]..folders[i]..[[".indexOf(" - ") + 3, "]]..folders[i]..[[".length);
				cooltext = StringTools.replace(cooltext, " [no video]", "");
				if (cooltext.length > ]]..maxNameLength..[[)
					cooltext = cooltext.substring(0, ]]..maxNameLength..[[ - 3) + "...";

				var coolbutt:FlxButton = new FlxButton(10, 40 + (getVar("osuparse_objects").length * 30), cooltext);
				coolbutt.setGraphicSize(430, 25);
				coolbutt.updateHitbox();
				coolbutt.labelOffsets.y = 10;
				coolbutt.label.setFormat(Paths.font("vcr.ttf"), 16, 0xff000000, "center");
				coolbutt.label.fieldWidth = 430;
				coolbutt.color = ]]..curColor..[[;
				coolbutt.cameras = [game.camOther];
				game.add(coolbutt);
				getVar("osuparse_objects").push(coolbutt);
				return cooltext;
			]])
		end
	else
		addLog("osu! not installed on this device!", true)
	end
end

local foldersToProcess = {"data", "images/bgs", "songs", "weeks"}
local ignoreFile = "import-osu-songs"
function clearConvertedSongs()
	for i = 1, #foldersToProcess do
		local rem_folder = runHaxeCode([[return FileSystem.readDirectory(Paths.modFolders("]]..foldersToProcess[i]..[["));]])
		for i1 = 1, #rem_folder do
			if not stringStartsWith(rem_folder[i1], ignoreFile) and exists(runHaxeCode([[return Paths.modFolders("]]..foldersToProcess[i]..[[");]])..'/'..rem_folder[i1]) then
				if runHaxeCode([[return FileSystem.isDirectory(Paths.modFolders("]]..foldersToProcess[i]..[[") + "/" + "]]..rem_folder[i1]..[[");]]) then
					os.execute('rmdir /S /Q "'..runHaxeCode([[return Paths.modFolders("]]..foldersToProcess[i]..[[");]])..'/'..rem_folder[i1]..'"')
				else
					runHaxeCode([[FileSystem.deleteFile(Paths.modFolders("]]..foldersToProcess[i]..[[") + "/]]..rem_folder[i1]..[[");]])
				end
				addLog(runHaxeCode([[return Paths.modFolders("]]..foldersToProcess[i]..[[");]])..'/'..rem_folder[i1]..": Successfully removed!")
			end
		end
	end
end

function clearSongCache()
	os.execute('rmdir /S /Q "'..runHaxeCode([[return Paths.modFolders("songcache");]])..'"')
	createDirectory(runHaxeCode([[return Paths.modFolders("data").substring(0, Paths.modFolders("data").lastIndexOf("/"));]]).."/songcache")
	addLog(runHaxeCode([[return Paths.modFolders("songcache");]])..": Successfully cleared!")
end

local workingPath = ""
function startImport()
	direc = runHaxeCode([[return Paths.modFolders("scripts").substring(0, Paths.modFolders("scripts").length - 8);]])
	local input_folder = runHaxeCode([[return FileSystem.readDirectory("]]..direc..[[");]])
	for i = 1, #input_folder do
		if stringEndsWith(input_folder[i], '.osz') then
			unzipOSZ(string.sub(input_folder[i], 0, #input_folder[i] - 4))
		end
	end

	workingPath = runHaxeCode([[return Paths.modFolders("songcache");]])
	local folder = runHaxeCode([[return FileSystem.readDirectory("]]..workingPath..[[");]])
	for i = 1, #folder do
		if not runHaxeCode([[return FileSystem.isDirectory("]]..workingPath..[[" + "/" + "]]..folder[i]..[[");]]) then
			goto skipfolder
		end
		addLog(' '..folder[i]..': Starting...')
		local file = runHaxeCode([[return FileSystem.readDirectory("]]..workingPath..[[" + "/" + "]]..folder[i]..[[");]])
		local isOneConverted = false
		local bg_diff = {}
		local audioFileName = ""
		local directory = ""
		local songFileName = ""
		local difficulties = ""
		for i1 = 1, #file do
			if stringEndsWith(file[i1], ".osu") then
				local ret = osu_to_fnf(workingPath.."/"..folder[i].."/"..file[i1])
				addLog('   '..file[i1]..': Reformatting to .json fnf format...')
				if stringStartsWith(ret[1], '||cool_string||') then
					addLog('   '..file[i1]..': '..string.gsub(ret[1], '||cool_string||', ''), true)
					goto skiposufile
				end
				local diff_thing = '-'..formatToSongPath(ret[3])
				if diff_thing == '-normal' then
					diff_thing = ''
				end
				if not exists(runHaxeCode([[return Paths.modFolders("data");]]).."/"..formatToSongPath(ret[2])) then
					createDirectory(runHaxeCode([[return Paths.modFolders("data");]]).."/"..formatToSongPath(ret[2]))
				end
					--[[local check1 = runHaxeCode(
						if (!FileSystem.exists(Paths.modFolders("data") + "/" + "..formatToSongPath(ret[2]).." + "/" + "..formatToSongPath(ret[2]).." + "..diff_thing.." + ".json"))
							File.saveContent(Paths.modFolders("data") + "/" + "..formatToSongPath(ret[2]).." + "/" + "..formatToSongPath(ret[2]).." + "..diff_thing.." + ".json", '..fixStr(ret[1])..');
						return 1;
					)
					if check1 ~= 1 then
						addLog('   '..'data/'..formatToSongPath(ret[2])..'/'..formatToSongPath(ret[2])..diff_thing..'.json'..': Saving failed!', true)
					end]]--
				if not exists(runHaxeCode([[return Paths.modFolders("data");]]).."/"..formatToSongPath(ret[2]).."/"..formatToSongPath(ret[2])..diff_thing..".json") then
					saveContent(runHaxeCode([[return Paths.modFolders("data");]]).."/"..formatToSongPath(ret[2]).."/"..formatToSongPath(ret[2])..diff_thing..".json", fixStr(ret[1]))
				end
				directory = formatToSongPath(ret[2])
				isOneConverted = true
				difficulties = difficulties..ret[3]..', '
				songFileName = ret[2]
				if #audioFileName == 0 then
					audioFileName = ret[4]
				end

				if #ret[5] > 0 then
					if not exists(runHaxeCode([[return Paths.modFolders("images");]]).."/bgs") then
						createDirectory(runHaxeCode([[return Paths.modFolders("images");]]).."/bgs")
					end
					if not exists(runHaxeCode([[return Paths.modFolders("images");]]).."/bgs/"..formatToSongPath(ret[2])) then
						createDirectory(runHaxeCode([[return Paths.modFolders("images");]]).."/bgs/"..formatToSongPath(ret[2]))
					end
					if not exists(runHaxeCode([[return Paths.modFolders("images");]]).."/bgs/"..formatToSongPath(ret[2]).."/"..string.sub(ret[5], 0, lastIndexOf(ret[5], '.') - 1)..".png") then
						addLog('   '..'images/bgs/'..string.sub(ret[5], 0, lastIndexOf(ret[5], '.') - 1)..".png"..': Saving bg image...')
						local check2 = runHaxeCode([[
							Sys.command(Paths.modFolders("imgconverter.exe"), ["]]..workingPath.."/"..folder[i].."/"..ret[5]..[[", Paths.modFolders("images/bgs") + "/]]..formatToSongPath(ret[2])..[[" + "/]]..string.sub(ret[5], 0, lastIndexOf(ret[5], '.') - 1)..[[.png"]);
							return 1;
						]])
						if check2 ~= 1 then
							addLog('   '..'images/bgs/'..string.sub(ret[5], 0, lastIndexOf(ret[5], '.') - 1)..".png"..': Saving failed!', true)
						end
					end

					table.insert(bg_diff, ret[3]..'||||'..string.sub(ret[5], 0, lastIndexOf(ret[5], '.') - 1))
				end
			end
			::skiposufile::
		end
		if isOneConverted then
			difficulties = string.sub(difficulties, 1, #difficulties - 2)
			difficulties = sortBySize(formatToSongPath(songFileName), difficulties)
			if not exists(runHaxeCode([[return Paths.modFolders("songs");]]).."/"..directory) then
				createDirectory(runHaxeCode([[return Paths.modFolders("songs");]]).."/"..directory)
			end
			if not exists(runHaxeCode([[return Paths.modFolders("songs");]]).."/"..directory.."/Inst.ogg") then
				addLog('   '..'songs/'..directory..': Saving Inst.ogg...')
				local check3 = runHaxeCode([[
					Sys.command(Paths.modFolders("ffmpeg.exe"), ['-y', '-loglevel', '0', '-i', "]]..workingPath..[[/]]..folder[i]..[[/]]..audioFileName..[[", '-c:a', 'libvorbis', '-b:a', '320k', '-map', 'a', Paths.modFolders("songs") + '/' + "]]..directory..[[" + '/Inst.ogg']);
					return 1;
				]])
				if check3 ~= 1 then
					addLog('   '..'songs/'..directory..'/Inst.ogg: Saving failed!', true)
				end
			end

			if not exists(runHaxeCode([[return Paths.modFolders("weeks");]]).."/"..directory..".json") then
				addLog('   '..'weeks/'..directory..'.json: Saving week file...')
				local huinya = [[{
	"songs": [
		["songFileName_r", "nil", [165, 0, 77] ]
	],

	"weekCharacters": [
		"",
		"bf",
		"gf"
	],
	"weekBackground": "stage",
	"difficulties": "difficulties_r",

	"storyName": "",
	"weekBefore": "none",
	"weekName": "directory_r",
	"startUnlocked": true,

	"hideStoryMode": true,
	"hideFreeplay": false
}]]
				huinya = runHaxeCode([[return StringTools.replace(']]..fixStr(huinya)..[[', "songFileName_r", ']]..fixStr(songFileName)..[[');]])
				huinya = runHaxeCode([[return StringTools.replace(']]..fixStr(huinya)..[[', "difficulties_r", ']]..fixStr(difficulties)..[[');]])
				huinya = runHaxeCode([[return StringTools.replace(']]..fixStr(huinya)..[[', "directory_r", ']]..fixStr(directory)..[[');]])
				saveContent(runHaxeCode([[return Paths.modFolders("weeks");]]).."/"..directory..".json", huinya)
				--if check4 ~= 1 then
					--addLog('   '..'weeks/'..directory..'.json: Saving failed!', true)
				--end
			end
		end

		if #bg_diff > 0 and not exists(runHaxeCode([[return Paths.modFolders("data");]]).."/"..directory.."/osu_bg.lua") then
			addLog('   '..'data/'..directory..': Implementing bg image to song...')
			--local check5 = runHaxeCode([[
				--File.saveContent(Paths.modFolders("data") + "/]]..directory..[[/" + "osu_bg.lua", ']]..getScript(bg_diff)..[[');
				--return 1;
			--]])
			--if check5 ~= 1 then
				--addLog('   '..'data/'..directory..'/osu_bg.lua: Saving failed!', true)
			--end
			saveContent(runHaxeCode([[return Paths.modFolders("data");]]).."/"..directory.."/osu_bg.lua", getScript(bg_diff))
			--print(exists(runHaxeCode([[return Paths.modFolders("data");]]).."/"..directory.."/osu_bg.lua"))
		end
		addLog(' '..folder[i]..': Completed!')
		::skipfolder::
	end
	addLog('Import osu songs completed!')
end

function sortBySize(dir, diffs)
	local diffs_orig = diffs
	diffs = stringSplit(diffs, ', ')
	local diffs_ = ''
	for i = 1, #diffs do
		if diffs[i] == 'Normal' then
			diffs[i] = ''
		else
			diffs[i] = '-'..formatToSongPath(diffs[i])
		end
		diffs_ = diffs_..diffs[i]..', '
	end
	diffs = string.sub(diffs_, 1, #diffs_ - 2)
	return runHaxeCode([[
		var newDA = [];
		var diffs_orig = "]]..diffs_orig..[[".split(", ");
		var diffs = "]]..diffs..[[".split(", ");
		for (i in 0...diffs.length)
		{
			newDA.push([diffs_orig[i], FileSystem.stat(Paths.modFolders("data") + "/]]..dir..'/'..dir..[[" + diffs[i] + ".json").size]);
		}
		newDA.sort((a, b) -> a[1] - b[1]);
		var newA = [];
		for (things in newDA)
			newA.push(things[0]);

		return newA.join(', ');
	]])
end

function unzipOSZ(osz)
	local check6 = runHaxeCode([[
		var dir = Paths.modFolders("scripts").substr(0, Paths.modFolders("scripts").length - 8);
		if (!FileSystem.exists(dir + "/songcache/]]..osz..[["))
			FileSystem.createDirectory(dir + "/songcache/]]..osz..[[");
		Sys.command(Paths.modFolders('7z.exe'), ['e', dir + "/]]..osz..[[.osz", '-o' + Paths.modFolders('songcache') + '/' + "]]..osz..[[", '-y']);
		FileSystem.deleteFile(dir + "/]]..osz..[[.osz");
		return 1;
	]])
	if check6 ~= 1 then
		addLog(' '..osz..'.osz: Extracting failed!', true);
	end
end

function formatToSongPath(str, doLower)
	if doLower == nil then doLower = true end
	str = runHaxeCode([[
		var invalidChars = "~&\\;:<>#";
		var hideChars = ".,'%?!*";
		var str = "]]..string.gsub(str, [["]], [[']])..[[";
		for (i in 0...invalidChars.length)
			str = StringTools.replace(str, invalidChars.charAt(i), '-');
		for (i in 0...hideChars.length)
			str = StringTools.replace(str, hideChars.charAt(i), '');
		return str;
	]])
	if doLower then
		str = string.gsub(str, ' ', '-')
		str = string.lower(str)
	end
	return str
end

function getMapOptions(map, name)
	for i = 1, #map do
		--addLog(string.lower(map[i]), string.lower(name)..":")
		if stringStartsWith(string.lower(map[i]), string.lower(name)..":") then
			return stringTrim(string.sub(map[i], lastIndexOf(map[i], ":") + 1, #map[i]))
		end
	end

	return "null"
end

-- https://stackoverflow.com/a/20461096
function lastIndexOf(haystack, needle)
    local i, j
    local k = 0
    repeat
        i = j
        j, k = string.find(haystack, needle, k + 1, true)
    until j == nil

    return i
end

function findLine(array, find, fromLine, toLine, silent)
	if toLine == nil then
		toLine = #array
	end
	if fromLine == nil then
		fromLine = 1
	end

	for i = fromLine, toLine - 1 do
		if stringStartsWith(array[i], find) then
			return i
		end
	end

	if not silent then addLog("String "..find.." not found!") end
	return nil
end

function osu_to_fnf(path)
	local map = getTextFile(path)
	local curMode = tonumber(getMapOptions(map, "Mode"))
	if curMode ~= 3 then
		local osuModes = {'standard osu', 'osu!taiko', 'osu!catch', 'osu!mania'}
		return {"||cool_string||"..'Beatmap is a '..osuModes[curMode + 1]..'. It must be a osu!mania! Ignoring...', "", "", ""}
	end
	local title = formatToSongPath(getMapOptions(map, "Title"), false)
	if title == "null" then
		title = formatToSongPath(getMapOptions(map, "TitleUnicode"), false)
	end
	if title == "null" then
		title = "Test"
	end
	local keyCount = tonumber(getMapOptions(map, "CircleSize"))
	if keyCount ~= 4 then
		--error_throw('Converter supports only 4 key mode! You have a '..keyCount..' key beatmap.')
		return {"||cool_string||"..'Beatmap has a '..keyCount..' key. It must be a 4 key! Ignoring...', "", "", ""}
	end

	runHaxeCode([[
		// copied from psych engine charting state
		setVar('jsondataobj', '{
	"song": {
		"convertedBy": "osu songs in psych engine script",
		"song": "Sus",
		"notes": notestoreplace,
		"events": [],
		"bpm": bpmtoreplace,
		"needsVoices": false,
		"player1": "bf",
		"player2": "pico",
		"gfVersion": "gf",
		"speed": 3,
		"stage": "osu",
		"mania": 3,
		"playerKeyCount": 4,
		"keyCount": 4,
		"validScore": false
	}
}');

		setVar('jsondataobj', StringTools.replace(getVar('jsondataobj'), '"song": "Sus",', '"song": "]]..title..[[",'));
	]])
	local toData = {}
	for i = findLine(map, '[HitObjects]') + 1, #map - 1 do
		local osuLine = stringSplit(map[i], ',')
		table.insert(toData, {tonumber(osuLine[3]), convertNote(osuLine[1], keyCount), (tonumber(string.sub(osuLine[6], 0, string.find(osuLine[6], ':') - 1)) - tonumber(osuLine[3]))})
		if toData[#toData][3] < 0 then toData[#toData][3] = 0 end
	end

	local bpm = 150
	if findLine(map, '[TimingPoints]') ~= nil then
		bpm = math.floor(60000 / tonumber(stringSplit(map[findLine(map, '[TimingPoints]') + 1], ',')[2]))
	end
	runHaxeCode([[setVar('jsondataobj', StringTools.replace(getVar('jsondataobj'), "bpmtoreplace", ]]..bpm..[[));]])

	local toret = {}
	local obj_notes = "[\n\t\t\t"
	local i1 = 0
	local laststr = ""
	for i = 0, 100000 do
		obj_notes = obj_notes..'{\n\t\t\t\t"typeOfSection": 0,\n\t\t\t\t"lengthInSteps": 16,\n\t\t\t\t"sectionNotes": sectionnotesreplace,\n\t\t\t\t"mustHitSection": true,\n\t\t\t\t"gfSection": false,\n\t\t\t\t"altAnim": false\n\t\t\t},\n\t\t\t'

		local toret2 = "[\n\t\t\t\t\t"
		for note = 1, #toData do
			if toData[note][1] <= ((i1 + 1) * (4 * (1000 * 60 / bpm))) and toData[note][1] > (i1 * (4 * (1000 * 60 / bpm))) then
				toret2 = toret2..'[\n\t\t\t\t\t\t'..toData[note][1]..',\n\t\t\t\t\t\t'..toData[note][2]..',\n\t\t\t\t\t\t'..toData[note][3]..'\n\t\t\t\t\t],\n\t\t\t\t\t'
				laststr = '['..toData[note][1]..','..toData[note][2]..','..toData[note][3]..']'
			end
		end
		if toret2 ~= "[\n\t\t\t\t\t" then
			toret2 = string.sub(toret2, 1, #toret2 - 7)
			toret2 = toret2..'\n\t\t\t\t]'
		else
			toret2 = string.sub(toret2, 1, #toret2 - 7)
			toret2 = toret2..'[]'
		end

		obj_notes = string.gsub(obj_notes, "sectionnotesreplace", toret2)

		if '['..toData[#toData][1]..','..toData[#toData][2]..','..toData[#toData][3]..']' == laststr then
			break
		end
		i1 = i1 + 1
	end
	obj_notes = string.sub(obj_notes, 1, #obj_notes - 5)..'\n\t\t]'
	runHaxeCode([[
		setVar('jsondataobj', StringTools.replace(getVar('jsondataobj'), "notestoreplace", ']]..obj_notes..[['));
	]])

	local bgName = ""
	if findLine(map, '[Events]') ~= 1 then
		for i = findLine(map, '[Events]') + 1, #map - 1 do
			if not stringStartsWith(map[i], '//') and stringStartsWith(map[i], '0') then
				bgName = stringSplit(map[i], ',')[3]
				bgName = string.sub(bgName, 2, -2)
				break
			end
			if #map[i] == 0 then
				break
			end
		end
	end

	-- fucking why Json.stringify not working in hscript???????????????????????
	return {runHaxeCode([[var d = getVar('jsondataobj'); setVar('jsondataobj', ""); return d;]]), title, getMapOptions(map, "Version"), getMapOptions(map, "AudioFilename"), bgName}
end

function convertNote(from_note, keyCount, fromosu)
	if fromosu == nil then fromosu = true end
	from_note = tonumber(from_note);

	local num = 512 / keyCount;
	local ty = from_note * num;

	if fromosu then
		for i = 0, keyCount - 1 do
			local th = {num * i, (num * (i + 1)) - 1};
			if from_note >= th[1] and from_note <= th[2] then
				return i
			end
		end
	else
		if from_note >= keyCount then
			from_note = from_note - keyCount + 1
		end
		return tonumber(((num * from_note) + ((num * (from_note + 1)) - 1)) / 2) + 1;
	end

	addLog('Note ' + from_note + ' not found in array!');
	return 0;
end

function formatToFileName(str)
	return string.gsub(str, '"', "'")
end

function createDirectory(path)
	runHaxeCode([[FileSystem.createDirectory("]]..formatToFileName(path)..[[");]])
end

function exists(path)
	return runHaxeCode([[
		var path = "]]..formatToFileName(path)..[[";
		var folder = FileSystem.readDirectory(path.substring(0, path.lastIndexOf("/")));
		for (thing in folder)
			if (thing == path.substring(path.lastIndexOf("/") + 1, path.length))
				return true;
		return false;
	]])
end

function saveContent(path, content)
	runHaxeCode([[File.saveContent("]]..formatToFileName(path)..[[", ']]..fixStr(content)..[[');]])
end

-- thx to this!!!!!!!!!!!! https://superuser.com/questions/377017/filenames-too-long-and-windows-cant-open-the-files
function getContent(path)
	if runHaxeCode([[return FileSystem.exists("]]..formatToFileName(path)..[[");]]) then
		return runHaxeCode([[return File.getContent("]]..formatToFileName(path)..[[");]])
	end

	return runHaxeCode([[
		var path = "]]..formatToFileName(path)..[[";
		Sys.command("C:/Windows/System32/subst.exe", ["W:", path.substring(0, path.lastIndexOf("/"))]);
		var toret:String = File.getContent("W:" + path.substring(path.lastIndexOf("/"), path.length));
		Sys.command("C:/Windows/System32/subst.exe", ["W:", "/D"]);
		return toret;
	]])
end

function getTextFile(path, split)
	if split == nil then split = "\n" end
	local d = 0
	if exists(path) then
		d = getContent(path)
	end

	if d == 0 then
		addLog(path..": File not found!")
		return ""
	else
		return stringSplit(d, split)
	end
end

function fixStr(str)
	str = string.gsub(str, [[\']], "'")
	return string.gsub(str, "'", [[\']])
end

function getScript(bg_diff)
	local toretu = [[-- automatically generated by osu songs in psych engine script
local bgName = ""
function onCreate()
string_to_replace
	makeLuaSprite("bg", "bgs/"..songPath.."/"..bgName, 0, 0)
	setObjectCamera("bg", "camhud")
	setGraphicSize("bg", 1280, 720)
	addLuaSprite("bg")
	setProperty("bg.alpha", 0.6)
end

function onCreatePost()
	triggerEvent("Camera Follow Pos", 750, 350)
end
function onCountdownStarted()
	setHealthBarColors("FF0000", "00FF00")
end

function onUpdate()
	if startedCountdown then
		for i = 0, getProperty("opponentStrums.length") - 1 do
			setPropertyFromGroup("opponentStrums", i, "visible", false);
		end
		if not middlescroll then
			for i = 0, getProperty("playerStrums.length") - 1 do
				setPropertyFromGroup("playerStrums", i, "x", 412 + (112 * i));
			end
		end
	end

	setProperty("healthBar.angle", 90)
	setProperty("healthBar.x", getPropertyFromGroup("playerStrums", getProperty("playerStrums.length") - 1, "x") - 160)
	setProperty("healthBar.y", 413)

	if getPropertyFromClass("ClientPrefs", "downScroll") then
		setProperty("scoreTxt.y", 20)
	else
		setProperty("scoreTxt.y", 678)
	end

	setProperty("dad.visible", false)
	setProperty("gf.visible", false)
	setProperty("boyfriend.visible", false)
	setProperty("iconP2.visible", false)
	setProperty("iconP1.visible", false)
end
]]
	local toretu_diff = ''
	for i = 1, #bg_diff do
		bg_diff[i] = string.gsub(bg_diff[i], "'", [[\']])
		local d = stringSplit(bg_diff[i], '||||')
		toretu_diff = toretu_diff..[[	if difficultyName == "]]..d[1]..[[" then bgName = "]]..d[2]..[[" end
]]
	end
	toretu = string.gsub(toretu, 'string_to_replace', toretu_diff);
	return toretu
end