-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: options in pause menu
-- Dependencies of script: PauseSubstate.lua, AdvancedTimeBar.lua
-- If you want use it in your mod, just credit me <3
-- How to use:
--   Open pause menu
--   Left mouse click on gray thing in right bottom corner of screen
--   Scroll with mouse
--   Left mouse click on bool or list option to change value
--   Left mouse hold and scroll with mouse on int or float option to change value
--   Press the R key or right mouse click to reset value to default
--   Left mouse click on "Click to Open" thing to close it

------------------------------------- config started -------------------------------------

local optionsArray = {
	-- name : string - uses in ClientPrefs if type is not custom or title
	-- type : string - bool, float, int, list, custom, title
	-- values : table - custom, float, int types uses only 1 index of table
	-- value : number - on bool type 0 is false and 1 is true
	-- description : string
	-- min : number - uses only in float or int type!
	-- step : number - uses only in float or int type!
	-- max : number - uses only in float or int type!
	{name = "downScroll", type = "bool", values = {"Upscroll", "Downscroll"}, value = 1, description = "If Downscroll, notes go Down instead of Up,\nsimple enough."},
	{name = "middleScroll", type = "bool", values = {"Middlescroll - OFF", "Middlescroll - ON"}, value = 1, description = "If ON, your notes get centered."},
	{name = "ghostTapping", type = "bool", values = {"Ghost Tapping - OFF", "Ghost Tapping - ON"}, value = 1, description = "If ON, you won't get misses, while there are\nno notes able to be hit."},
	--{name = "controllerMode", type = "bool", values = {"Controller Mode - OFF", "Controller Mode - ON"}, value = 0, description = ""},
	{name = "noReset", type = "bool", values = {"Reset Button - ON", "Reset Button - OFF"}, value = 1, description = "If ON, pressing Reset will do death."},
	{name = "keyBindsMenu", type = "custom", values = {"Key Binds - %note_left% %note_down% %note_up% %note_right%"}, value = nil, description = "Opens keybind menu."},
	{name = "gameplaySettingsMenu", type = "custom", values = {"Gameplay Settings"}, value = nil, description = "Opens gameplay settings menu."},

	{name = "HUD Elements", type = "title"},
	--{name = "fallingSnow", type = "bool", values = {"Falling Snow - OFF", "Falling Snow - ON"}, value = 1, description = "If ON, the wonderful snowflakes\nwill fall in pause menu. (only in winter)"},
	{name = "opponentStrums", type = "bool", values = {"Opponent Notes - OFF", "Opponent Notes - ON"}, value = 1, description = "If OFF, opponent notes get hidden."},
	{name = "hitsoundVolume", type = "float", values = {"Hitsound Volume - %v%"}, value = 0, min = 0, step = 0.1, max = 1, description = "Funny notes does \"Tick!\" when you hit them."},
	--{name = "arrowHSV", type = "custom"},
	{name = "noteSplashes", type = "bool", values = {"Note Splashes - OFF", "Note Splashes - ON"}, value = 1, description = "If OFF, hitting \"Sick!\" notes won't show\nparticles."},
	{name = "camZooms", type = "bool", values = {"Camera Zooms - OFF", "Camera Zooms - ON"}, value = 1, description = "If OFF, the camera won't zoom on beat hit."},
	{name = "scoreZoom", type = "bool", values = {"Score Text Static", "Score Text Zoom on Hit"}, value = 1, description = "If Score Text Static, disables Score text\nzooming when you hit a note."},
	{name = "healthBarAlpha", type = "float", values = {"Health Bar Transparency - %v%"}, value = 0, min = 0, step = 0.1, max = 1, description = "How much transparent should\nthe health barand icons be."},
	{name = "hideHud", type = "bool", values = {"Show HUD", "Hide HUD"}, value = 1, description = "If Hide HUD, hides most HUD elements."},
	{name = "timeBarType", type = "list", values = {"Time Bar Type - Time Left", "Time Bar Type - Time Elapsed", "Time Bar Type - Song Name", "Time Bar Type - Disabled"}, value = 1, description = "What should the Time Bar display?"},

	{name = "Graphics", type = "title"},
	{name = "showFPS", type = "bool", values = {"FPS Counter - OFF", "FPS Counter - ON"}, value = 1, description = "If unchecked, hides FPS Counter."},
	{name = "framerate", type = "int", values = {"Framerate - %v FPS"}, value = 0, min = 60, step = 1, max = 240, description = "Pretty self explanatory, isn't it?"},

	{name = "Offsets", type = "title"},
	--{name = "comboOffset", type = "custom"},
	{name = "ratingOffset", type = "int", values = {"Rating Offset - %vms"}, value = 0, min = -30, step = 1, max = 30, description = "Changes how late/early you have\nto hit for a \"Sick!\" in milliseconds."},
	{name = "sickWindow", type = "int", values = {"Sick Window - %vms"}, value = 0, min = 15, step = 1, max = 45, description = "Changes the amount of time you have\nfor hitting a \"Sick!\" in milliseconds."},
	{name = "goodWindow", type = "int", values = {"Good Window - %vms"}, value = 0, min = 15, step = 1, max = 90, description = "Changes the amount of time you have\nfor hitting a \"Good\" in milliseconds."},
	{name = "badWindow", type = "int", values = {"Bad Window - %vms"}, value = 0, min = 15, step = 1, max = 135, description = "Changes the amount of time you have\nfor hitting a \"Bad\" in milliseconds."},
	{name = "safeFrames", type = "int", values = {"Safe Frames - %v"}, value = 0, min = 2, step = 1, max = 10, description = "Changes how many frames you have for\nhitting a note earlier or late."}
}
local gameplaySettings = {
	-- just like in optionsArray
	{name = "scrollspeed", type = "float", values = {"Scroll Speed - %v"}, value = 1, min = 0.35, step = 0.05, max = 6, description = "Changes how slow/fast notes\nscrolls on strums."},
	{name = "scrolltype", type = "list", values = {"Scroll Type - Constant", "Scroll Type - Multiplicative"}, value = 1, description = "Changes a scroll speed type."},
	{name = "healthgain", type = "float", values = {"Health Gain - %v"}, value = 1, min = 0.1, step = 0.1, max = 5, description = "Changes how many health\nwill give on note hit."},
	{name = "healthloss", type = "float", values = {"Health Loss - %v"}, value = 1, min = 0.1, step = 0.1, max = 5, description = "Changes how many health\nwill loss on note miss."},
	{name = "instakill", type = "bool", values = {"Insta Kill - OFF", "Insta Kill - ON"}, value = 1, description = "If ON, note miss will do death."},
	--{name = "practice", type = "bool", values = {"Practice Mode - OFF", "Practice Mode - ON"}, value = 1, description = "Changes practice mode."},
	--{name = "botplay", type = "bool", values = {"Bot Play - OFF", "Bot Play - ON"}, value = 1, description = "If ON, notes will hit automatically on player strums."},
	--{name = "opponentplay", type = "bool", values = {"Opponent Play - OFF", "Opponent Play - ON"}, value = 1, description = "If ON, you will play on opponent side."},
}

local scrollStep = 20 -- scroll speed of menu thingy on mouse wheel change
local scrollSound = "dialogue" -- name of sound played on option click

------ using 24-bit color format ------
local color_bg = "808080"
local color_dragger = "606060"

local color_focus = "ffffff"
local color_unfocus = "cccccc"
local color_title = "beccb1"

-------------------------------------- config ended --------------------------------------
------------ change everything you want in bottom if you know what you doing -------------

local textArray_index = 0
local opened = false
local pos = {}
function onCustomSubstateCreatePost(name)
	if name == "PauseMenu" then
		luaDebugMode = true
		addHaxeLibrary('FlxMath', 'flixel.math')
		addHaxeLibrary('FlxText', 'flixel.text')
		addHaxeLibrary('Reflect')
		pos = {screenWidth - 400, screenHeight - 150, 400, 150}
		runHaxeCode([[
			setVar('bg_dragger', null);
			setVar('text_dragger', null);
			setVar('bg', null);
			setVar('textArray', []);
			setVar('textArrays', []);

			setVar('objects_pm', []);

			setVar('bg', new FlxSprite(]]..pos[1]..[[, FlxG.height).makeGraphic(]]..pos[3]..[[, ]]..pos[4]..[[, 0xff]]..color_bg..[[));
			getVar('objects_pm').push(getVar('bg'));

			setVar('bg_dragger', new FlxSprite(]]..pos[1]..[[, FlxG.height + 50).makeGraphic(]]..pos[3]..[[, ]]..pos[4]..[[ - 100, 0xff]]..color_dragger..[[));
			getVar('objects_pm').push(getVar('bg_dragger'));

			setVar('text_dragger', new FlxText(]]..pos[1]..[[ + 120, FlxG.height + 80, FlxG.width - ]]..pos[1]..[[, 'Click to Open'));
			getVar('text_dragger').setFormat(Paths.font('vcr.ttf'), 20);
			getVar('objects_pm').push(getVar('text_dragger'));

			FlxG.mouse.visible = true;
		]])

		updateTexts()
		addObjects()

		runHaxeCode([[
			FlxTween.tween(getVar('text_dragger'), {y: getVar('bg').y - 40}, 0.4);
			FlxTween.tween(getVar('bg_dragger'), {y: getVar('bg').y - 50}, 0.4);
		]])

		regenMenu(0)
	end
end

function updateTexts()
	runHaxeCode([[
		setVar('textArrays', [ [], [], [] ]);
	]])
	for i = 1, #optionsArray do
		if optionsArray[i].defaultValue == nil then optionsArray[i].defaultValue = optionsArray[i].value end
		if optionsArray[i].defaultDescription == nil then optionsArray[i].defaultDescription = optionsArray[i].description end
		runHaxeCode([[getVar('textArrays')[0].push({x: ]]..pos[1]..[[, y: FlxG.height, text: ']]..string.gsub(getOptionText(i), "'", "\\'")..[[', color: 0xff]]..color_unfocus..[[, size: 19});]])
	end

	runHaxeCode([[getVar('textArrays')[1].push({x: ]]..pos[1]..[[, y: FlxG.height, text: '   GO BACK', color: 0xff]]..color_unfocus..[[, size: 19});]])
	for i = 0, 3 do
		runHaxeCode([[getVar('textArrays')[1].push({x: ]]..pos[1]..[[, y: FlxG.height, text: ']]..string.gsub(getKeybindText(i, false, true), "'", "\\'")..[[', color: 0xff]]..color_unfocus..[[, size: 19});]])
	end

	runHaxeCode([[getVar('textArrays')[2].push({x: ]]..pos[1]..[[, y: FlxG.height, text: '   GO BACK', color: 0xff]]..color_unfocus..[[, size: 19});]])
	for i = 1, #gameplaySettings do
		if gameplaySettings[i].defaultValue == nil then gameplaySettings[i].defaultValue = gameplaySettings[i].value end
		if gameplaySettings[i].defaultDescription == nil then gameplaySettings[i].defaultDescription = gameplaySettings[i].description end
		runHaxeCode([[
			getVar('textArrays')[2].push({x: ]]..pos[1]..[[, y: FlxG.height, text: ']]..getGameplayOptionText(i)..[[', color: 0xff]]..color_unfocus..[[, size: 19});
		]])
	end
end

function regenMenu(index)
	updateTexts()
	runHaxeCode([[
		for (txt in getVar("textArray")) if (txt.length != 0)
		{
			txt.kill();
			txt.destroy();
		}
		setVar("textArray", [ [] ]);

		var i = 0;
		for (txt in getVar("textArrays")[ ]]..tostring(index)..[[ ])
		{
			var t:FlxText = new FlxText(txt.x, txt.y, 0, txt.text);
			t.setFormat(Paths.font('vcr.ttf'), txt.size, txt.color);
			getVar('textArray').push(t);
			getVar('objects_pm').push(t);

			if (]]..tostring(opened)..[[)
				t.y = ]]..pos[2]..[[ + (20 * i);
			i++;
		}
	]])
	addObjects()
	textArray_index = index
	if index == 1 then
		blockInput(true, {"ui_up", "ui_left", "ui_right", "ui_down", "note_up", "note_left", "note_right", "note_down"})
	else
		blockInput(false, {"ui_up", "ui_left", "ui_right", "ui_down", "note_up", "note_left", "note_right", "note_down"})
	end
end

-- change block of all input keys, presented in controlsArray
-- block : bool - if false, input unblocks
-- controlsArray : table string - a table with input keys, like in ClientPrefs.keyBinds map; if nil, then changing block of all input keys
function blockInput(block, controlsArray)
	controlsArray = controlsArray or {"ui_up", "ui_left", "ui_right", "ui_down", "note_up", "note_left", "note_right", "note_down", "accept", "back", "pause", "reset"}
	addHaxeLibrary("TitleState")
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
			game.keysArray = [
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
			];
		]])
	end
end

function addObjects()
	runHaxeCode([[
		for (op in getVar('objects_pm'))
		{
			op.cameras = [game.camOther];
			game.add(op);
		}
	]])
end

local keybindsCosmeticName = {'Left', 'Down', 'Up', 'Right'}
local keybindsName = {'note_left', 'note_down', 'note_up', 'note_right'}
function getKeybindText(index, withoutText, cosmetic)
	local toreturn = [[
		var keyarray:Array<Dynamic> = [
			[-2, 'ANY'],
			[-1, 'NONE'],
			[65, 'A'],
			[66, 'B'],
			[67, 'C'],
			[68, 'D'],
			[69, 'E'],
			[70, 'F'],
			[71, 'G'],
			[72, 'H'],
			[73, 'I'],
			[74, 'J'],
			[75, 'K'],
			[76, 'L'],
			[77, 'M'],
			[78, 'N'],
			[79, 'O'],
			[80, 'P'],
			[81, 'Q'],
			[82, 'R'],
			[83, 'S'],
			[84, 'T'],
			[85, 'U'],
			[86, 'V'],
			[87, 'W'],
			[88, 'X'],
			[89, 'Y'],
			[90, 'Z'],
			[48, 'ZERO'],
			[49, 'ONE'],
			[50, 'TWO'],
			[51, 'THREE'],
			[52, 'FOUR'],
			[53, 'FIVE'],
			[54, 'SIX'],
			[55, 'SEVEN'],
			[56, 'EIGHT'],
			[57, 'NINE'],
			[33, 'PAGEUP'],
			[34, 'PAGEDOWN'],
			[36, 'HOME'],
			[35, 'END'],
			[45, 'INSERT'],
			[27, 'ESCAPE'],
			[189, 'MINUS'],
			[187, 'PLUS'],
			[46, 'DELETE'],
			[8, 'BACKSPACE'],
			[219, 'LBRACKET'],
			[221, 'RBRACKET'],
			[220, 'BACKSLASH'],
			[20, 'CAPSLOCK'],
			[186, 'SEMICOLON'],
			[222, 'QUOTE'],
			[13, 'ENTER'],
			[16, 'SHIFT'],
			[188, 'COMMA'],
			[190, 'PERIOD'],
			[191, 'SLASH'],
			[192, 'GRAVEACCENT'],
			[17, 'CONTROL'],
			[18, 'ALT'],
			[32, 'SPACE'],
			[38, 'UP'],
			[40, 'DOWN'],
			[37, 'LEFT'],
			[39, 'RIGHT'],
			[9, 'TAB'],
			[301, 'PRINTSCREEN'],
			[112, 'F1'],
			[113, 'F2'],
			[114, 'F3'],
			[115, 'F4'],
			[116, 'F5'],
			[117, 'F6'],
			[118, 'F7'],
			[119, 'F8'],
			[120, 'F9'],
			[121, 'F10'],
			[122, 'F11'],
			[123, 'F12'],
			[96, 'NUMPADZERO'],
			[97, 'NUMPADONE'],
			[98, 'NUMPADTWO'],
			[99, 'NUMPADTHREE'],
			[100, 'NUMPADFOUR'],
			[101, 'NUMPADFIVE'],
			[102, 'NUMPADSIX'],
			[103, 'NUMPADSEVEN'],
			[104, 'NUMPADEIGHT'],
			[105, 'NUMPADNINE'],
			[109, 'NUMPADMINUS'],
			[107, 'NUMPADPLUS'],
			[110, 'NUMPADPERIOD'],
			[106, 'NUMPADMULTIPLY'],
		];
		
	]]
	if cosmetic then
		toreturn = toreturn..[[
			keyarray = [
				[-2, 'ANY'],
				[-1, 'NONE'],
				[65, 'A'],
				[66, 'B'],
				[67, 'C'],
				[68, 'D'],
				[69, 'E'],
				[70, 'F'],
				[71, 'G'],
				[72, 'H'],
				[73, 'I'],
				[74, 'J'],
				[75, 'K'],
				[76, 'L'],
				[77, 'M'],
				[78, 'N'],
				[79, 'O'],
				[80, 'P'],
				[81, 'Q'],
				[82, 'R'],
				[83, 'S'],
				[84, 'T'],
				[85, 'U'],
				[86, 'V'],
				[87, 'W'],
				[88, 'X'],
				[89, 'Y'],
				[90, 'Z'],
				[48, '0'],
				[49, '1'],
				[50, '2'],
				[51, '3'],
				[52, '4'],
				[53, '5'],
				[54, '6'],
				[55, '7'],
				[56, '8'],
				[57, '9'],
				[33, 'PGUP'],
				[34, 'PGDOWN'],
				[36, 'HOME'],
				[35, 'END'],
				[45, 'INS'],
				[27, 'ESC'],
				[189, '-'],
				[187, '+'],
				[46, 'DEL'],
				[8, 'BCKSPC'],
				[219, '['],
				[221, ']'],
				[220, '\\'],
				[20, 'CAPS'],
				[186, ';'],
				[222, "'"],
				[13, 'ENTER'],
				[16, 'SHIFT'],
				[188, ','],
				[190, '.'],
				[191, '/'],
				[192, '`'],
				[17, 'CTRL'],
				[18, 'ALT'],
				[32, 'SPACE'],
				[38, 'UP'],
				[40, 'DOWN'],
				[37, 'LEFT'],
				[39, 'RIGHT'],
				[9, 'TAB'],
				[301, 'PRTSCR'],
				[112, 'F1'],
				[113, 'F2'],
				[114, 'F3'],
				[115, 'F4'],
				[116, 'F5'],
				[117, 'F6'],
				[118, 'F7'],
				[119, 'F8'],
				[120, 'F9'],
				[121, 'F10'],
				[122, 'F11'],
				[123, 'F12'],
				[96, '#0'],
				[97, '#1'],
				[98, '#2'],
				[99, '#3'],
				[100, '#4'],
				[101, '#5'],
				[102, '#6'],
				[103, '#7'],
				[104, '#8'],
				[105, '#9'],
				[109, '#-'],
				[107, '#+'],
				[110, '#.'],
				[106, '#*'],
			];
		]]
	end
	toreturn = toreturn..[[
		for (str in keyarray)
			if (str[0] == ClientPrefs.keyBinds[']]..keybindsName[index + 1]..[['][0])
			{
				return str[1];
			}
		return 40;
	]]
	toreturn = runHaxeCode(toreturn)

	if withoutText then
		return toreturn
	else
		return ' '..keybindsCosmeticName[index + 1]..': '..toreturn
	end
end

function getOptionText(index)
	if optionsArray[index].type == "title" then
		return optionsArray[index].name
	end

	--[[if optionsArray[index].name == "fallingSnow" then
		updateDescription(index)
		return '  '..optionsArray[index].values[fallingSnow_enabled and 2 or 1]
	end]]--

	local cp = getPropertyFromClass('ClientPrefs', optionsArray[index].name)
	if cp == nil then
		return '  '..optionsArray[index].name
	end

	if optionsArray[index].type == 'bool' then
		updateDescription(index)
		return '  '..optionsArray[index].values[cp and 2 or 1]
	elseif optionsArray[index].type == 'int' or optionsArray[index].type == 'float' then
		updateDescription(index)
		cp = round(cp, 1)
		if stringEndsWith(optionsArray[index].values[1], '%') then
			cp = cp * 100
		end
		return '  '..string.gsub(optionsArray[index].values[1], "%%v", cp)
	elseif optionsArray[index].type == 'list' then
		updateDescription(index)
		for i = 1, #optionsArray[index].values do
			if stringEndsWith(optionsArray[index].values[i], cp) then
				return '  '..optionsArray[index].values[i]
			end
		end
	elseif optionsArray[index].type == 'custom' then
		updateDescription(index)
		local str = optionsArray[index].values[1]
		if optionsArray[index].name == "keyBindsMenu" then
			str = string.gsub(str, "%%note_left%%", getKeybindText(0, true, true))
			str = string.gsub(str, "%%note_down%%", getKeybindText(1, true, true))
			str = string.gsub(str, "%%note_up%%", getKeybindText(2, true, true))
			str = string.gsub(str, "%%note_right%%", getKeybindText(3, true, true))
		end
		return '  '..str
	end

	return '  '..optionsArray[index].name
end

function round(exact, quantum)
    return tonumber(string.format("%."..quantum.."f", exact))
end
function updateDescription(index)
	local descarray = {
		["bool"] = "[click on option to change]",
		["int"] = "[hold button and scroll with mouse]",
		["float"] = "[hold button and scroll with mouse]",
		["list"] = "[click on option to change]",
		["custom"] = "[click on option to open menu]"
	}
	local newdesc = descarray[optionsArray[index].type]
	local uselessstr, ncount = string.gsub(optionsArray[index].defaultDescription, "\n", "\n")
	for i = 1, 2 - ncount do
		newdesc = "\n"..newdesc
	end
	optionsArray[index].description = optionsArray[index].defaultDescription..newdesc
end

function getGameplayOptionText(index)
	local cp = getFromGameplaySettings(gameplaySettings[index].name)
	if cp == nil then
		return '  '..gameplaySettings[index].name
	end

	if gameplaySettings[index].type == 'bool' then
		updateDescriptionGS(index)
		return '  '..gameplaySettings[index].values[cp and 2 or 1]
	elseif gameplaySettings[index].type == 'int' or gameplaySettings[index].type == 'float' then
		updateDescriptionGS(index)
		cp = round(cp, #tostring(gameplaySettings[index].step) - 2)
		if stringEndsWith(gameplaySettings[index].values[1], '%') then
			cp = cp * 100
		end
		local toret = string.gsub(gameplaySettings[index].values[1], "%%v", cp)
		if getFromGameplaySettings("scrolltype") == "multiplicative" or gameplaySettings[index].name == "healthgain" or gameplaySettings[index].name == "healthloss" then
			toret = toret.."x"
		end
		return '  '..toret
	elseif gameplaySettings[index].type == 'list' then
		updateDescriptionGS(index)
		for i = 1, #gameplaySettings[index].values do
			if stringEndsWith(string.lower(gameplaySettings[index].values[i]), cp) then
				-- update scrollspeed text
				if gameplaySettings[index].name == "scrolltype" then
					setPropertyFromArrayMap("textArray", 2, "text", string.gsub(getPropertyFromArrayMap("textArray", 2, "text"), "x", ""))
					if getFromGameplaySettings("scrolltype") == "multiplicative" then
						setPropertyFromArrayMap("textArray", 2, "text", getPropertyFromArrayMap("textArray", 2, "text").."x")
					end
				end
				return '  '..gameplaySettings[index].values[i]
			end
		end
	elseif gameplaySettings[index].type == 'custom' then
		updateDescriptionGS(index)
		return '  '..gameplaySettings[index].values[1]
	end

	return '  '..gameplaySettings[index].name
end
function updateDescriptionGS(index)
	local descarray = {
		["bool"] = "[click on option to change]",
		["int"] = "[hold button and scroll with mouse]",
		["float"] = "[hold button and scroll with mouse]",
		["list"] = "[click on option to change]",
		["custom"] = "[click on option to open menu]"
	}
	local newdesc = descarray[gameplaySettings[index].type]
	local uselessstr, ncount = string.gsub(gameplaySettings[index].defaultDescription, "\n", "\n")
	for i = 1, 2 - ncount do
		newdesc = "\n"..newdesc
	end
	gameplaySettings[index].description = gameplaySettings[index].defaultDescription..newdesc
end

function onCustomSubstateUpdatePost(name, elapsed)
	if name == 'PauseMenu' then
		local wheel = getPropertyFromClass('flixel.FlxG', 'mouse.wheel')
		if overlap("bg") then
			if wheel ~= 0 then
				updatePosition(wheel)
			end
			if opened then
				if textArray_index == 0 then
					updateValues()
				elseif textArray_index == 1 then
					updateKeybinds()
				elseif textArray_index == 2 then
					updateGameplaySettings()
				end
			end
		elseif overlap("bg_dragger") and mouseClicked('left') then
			if textArray_index ~= 0 then regenMenu(0) end
			updatePositionDragger()
		end
	end
end

function updatePositionDragger()
	if opened then
		for i = 1, getProperty("textArray.length") - 1 do
			setPropertyFromArrayMap("textArray", i, "y", pos[2] + (20 * (i - 1)))
		end
		blockInput(true)
		updatePosition()
		runHaxeCode([[
			for (i in 1...getVar('textArray').length)
				FlxTween.tween(getVar('textArray')[i], {y: FlxG.height}, 0.4, {ease: FlxEase.quartInOut,
					onUpdate: function (tween) {getVar('text_dragger').y = getVar('bg').y - 60;}
				});
			FlxTween.tween(getVar('bg'), {y: FlxG.height}, 0.4, {ease: FlxEase.quartInOut,
				onUpdate: function (tween) {getVar('bg_dragger').y = getVar('bg').y - 50;}
			});
			FlxTween.tween(getVar('text_dragger'), {x: 1000, y: 680}, 0.4, {ease: FlxEase.quartInOut,
				onComplete: function (tween) {
					getVar('text_dragger').text = "Click to Open";
					getVar('text_dragger').size = 20;
				}
			});
		]])
		runTimer("opened_disable", 0.4)
	else
		blockInput(true)
		runHaxeCode([[
			for (i in 1...getVar('textArray').length)
				FlxTween.tween(getVar('textArray')[i], {y: ]]..pos[2]..[[ + (20 * (i - 1))}, 0.4, {ease: FlxEase.quartInOut,
					onUpdate: function (tween){getVar('text_dragger').y = getVar('bg').y - 60;}
				});
			FlxTween.tween(getVar('bg'), {y: ]]..pos[2]..[[}, 0.4, {ease: FlxEase.quartInOut,
				onUpdate: function (tween) {getVar('bg_dragger').y = getVar('bg').y - 50;}
			});
			FlxTween.tween(getVar('text_dragger'), {x: ]]..pos[1]..[[, y: ]]..pos[2]..[[ - 50}, 0.4, {ease: FlxEase.quartInOut,
				onComplete: function (tween) {
					getVar('text_dragger').size = 16;
				}
			});
		]])
		runTimer("opened_enable", 0.4)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "opened_enable" then opened = true blockInput(false) end
	if tag == "opened_disable" then opened = false blockInput(false) end
end

function getPropertyFromArrayMap(arraymap, index, property)
	if runHaxeCode([[return game.variables.exists(']]..arraymap..[[');]]) then arraymap = "getVar('"..arraymap.."')" end
	local toret = runHaxeCode("return "..arraymap.."["..index.."]."..property..";")
	if tonumber(value) ~= nil then
		return tonumber(toret)
	elseif toret == "true" then
		return true
	elseif toret == "false" then
		return false
	elseif stringStartsWith(toret, arraymap) then
		return nil
	end
	return toret
end
function setPropertyFromArrayMap(arraymap, index, property, value)
	if runHaxeCode([[return game.variables.exists(']]..arraymap..[[');]]) then arraymap = "getVar('"..arraymap.."')" end
	if tonumber(value) == nil and tostring(value) ~= "false" and tostring(value) ~= "true" then value = "'"..string.gsub(value, "'", "\\'").."'" end
	runHaxeCode(arraymap.."["..index.."]."..property..[[ = ]]..tostring(value)..[[;]])
end

function updateGameplaySettings()
	for i = 1, getProperty("textArray.length") - 1 do
		if i == 1 then
			if overlapFromGroup("textArray", i) then
				setProperty("text_dragger.text", "Click to back in options.")
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
				if mouseClicked('left') then
					playSound(scrollSound, 0.9)
					setProperty("text_dragger.text", "")
					regenMenu(0)
					break
				end
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		else
			if overlapFromGroup("textArray", i) then
				local type = gameplaySettings[i - 1].type
				if type == "bool" then
					if mouseClicked('left') then
						playSound(scrollSound, 0.9)
	
						gameplaySettings[i - 1].value = intToBool(getFromGameplaySettings(gameplaySettings[i - 1].name), true)
						gameplaySettings[i - 1].value = gameplaySettings[i - 1].value + 1
						if gameplaySettings[i - 1].value > #gameplaySettings[i - 1].values then gameplaySettings[i - 1].value = 1 end
	
						setGameplayOption(i, intToBool(gameplaySettings[i - 1].value))
					end
					if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
						setGameplayOption(i, intToBool(gameplaySettings[i - 1].defaultValue))
					end
					setProperty("text_dragger.text", gameplaySettings[i - 1].description)
					setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
				elseif type == "int" or type == "float" then
					local wheel = getPropertyFromClass('flixel.FlxG', 'mouse.wheel')
					if mousePressed('left') and wheel ~= 0 then
						playSound(scrollSound, 0.9)
	
						gameplaySettings[i - 1].value = getFromGameplaySettings(gameplaySettings[i - 1].name)
						if wheel > 0 then gameplaySettings[i - 1].value = gameplaySettings[i - 1].value + gameplaySettings[i - 1].step end
						if wheel < 0 then gameplaySettings[i - 1].value = gameplaySettings[i - 1].value - gameplaySettings[i - 1].step end
						if gameplaySettings[i - 1].value < gameplaySettings[i - 1].min then gameplaySettings[i - 1].value = gameplaySettings[i - 1].max end
						if gameplaySettings[i - 1].value > gameplaySettings[i - 1].max then gameplaySettings[i - 1].value = gameplaySettings[i - 1].min end
	
						if type == 'int' then
							setGameplayOption(i, math.ceil(gameplaySettings[i - 1].value))
						else
							setGameplayOption(i, gameplaySettings[i - 1].value)
						end
					end
					if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
						setGameplayOption(i, gameplaySettings[i - 1].defaultValue)
					end
					setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
					setProperty("text_dragger.text", gameplaySettings[i - 1].description)
				elseif type == 'list' then
					if mouseClicked('left') then
						playSound(scrollSound, 0.9)
	
						local list = gameplaySettings[i - 1].values
						local find = getFromGameplaySettings(gameplaySettings[i - 1].name)
						for i1 = 1, #list do
							if stringEndsWith(string.lower(list[i1]), find) then
								gameplaySettings[i - 1].value = i1
								break
							end
						end
						gameplaySettings[i - 1].value = gameplaySettings[i - 1].value + 1
						if gameplaySettings[i - 1].value > #gameplaySettings[i - 1].values then gameplaySettings[i - 1].value = 1 end
	
						setGameplayOption(i, string.lower(string.sub(gameplaySettings[i - 1].values[gameplaySettings[i - 1].value], lastIndexOf(gameplaySettings[i - 1].values[gameplaySettings[i - 1].value], " - ") + 3, #gameplaySettings[i - 1].values[gameplaySettings[i - 1].value])))
					end
					if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
						setGameplayOption(i, string.lower(string.sub(gameplaySettings[i - 1].values[gameplaySettings[i - 1].defaultValue], lastIndexOf(gameplaySettings[i - 1].values[gameplaySettings[i - 1].defaultValue], " - ") + 3, #gameplaySettings[i - 1].values[gameplaySettings[i - 1].defaultValue])))
					end
					setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
					setProperty("text_dragger.text", gameplaySettings[i - 1].description)
				end
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		end
	end
end
function getFromGameplaySettings(setting)
	return runHaxeCode("return ClientPrefs.gameplaySettings.get('"..setting.."');")
end
function setFromGameplaySettings(setting, value)
	if tonumber(value) == nil and tostring(value) ~= "false" and tostring(value) ~= "true" then value = "'"..string.gsub(value, "'", "\\'").."'" end
	local toret = runHaxeCode("return ClientPrefs.gameplaySettings.set('"..setting.."', "..tostring(value)..");")
	runHaxeCode("ClientPrefs.saveSettings();")
	return toret
end
function setGameplayOption(index, value)
	local name = gameplaySettings[index - 1].name
	setFromGameplaySettings(name, value)
	setPropertyFromArrayMap("textArray", index, "text", getGameplayOptionText(index - 1))

	if name == "scrollspeed" then
		if getFromGameplaySettings("scrolltype") == "multiplicative" then
			setProperty("songSpeed", getPropertyFromClass("PlayState", "SONG.speed") * value)
		elseif getFromGameplaySettings("scrolltype") == "constant" then
			setProperty("songSpeed", value)
		end
	elseif name == "scrolltype" then
		setProperty("songSpeedType", value)
		if value == "multiplicative" then
			setProperty("songSpeed", getPropertyFromClass("PlayState", "SONG.speed") * getFromGameplaySettings("scrollspeed"))
		elseif value == "constant" then
			setProperty("songSpeed", getFromGameplaySettings("scrollspeed"))
		end
	elseif name == "healthgain" then
		setProperty("healthGain", value)
	elseif name == "healthloss" then
		setProperty("healthLoss", value)
	elseif name == "instakill" then
		setProperty("instakillOnMiss", value)
	elseif name == "practice" then
		setProperty("practiceMode", value)
		setPropertyFromClass("PlayState", "changedDifficulty", true)
	elseif name == "botplay" then
		setProperty("cpuControlled", value)
		setPropertyFromClass("PlayState", "changedDifficulty", true)
	elseif name == "opponentplay" then
		-- no variable in playstate for this option lol
	end
end

function updatePosition(wheel)
	if wheel == nil then wheel = 0 end

	if getProperty("textArray.length") > 1 then
		if not mousePressed('left') and wheel > 0 and getPropertyFromArrayMap("textArray", 1, "y") < pos[2] then
			for i = 1, getProperty("textArray.length") - 1 do
				setPropertyFromArrayMap("textArray", i, "y", getPropertyFromArrayMap("textArray", i, "y") + scrollStep)
			end
		end
		if not mousePressed('left') and wheel < 0 and getPropertyFromArrayMap("textArray", getProperty("textArray.length") - 1, "y") + getPropertyFromArrayMap("textArray", getProperty("textArray.length") - 1, "height") > pos[2] + pos[4] then
			for i = 1, getProperty("textArray.length") - 1 do
				setPropertyFromArrayMap("textArray", i, "y", getPropertyFromArrayMap("textArray", i, "y") - scrollStep)
			end
		end

		for i = 1, getProperty("textArray.length") - 1 do
			local _y = getPropertyFromArrayMap("textArray", i, "y")
			local _y1 = pos[2]
			local _height = getPropertyFromArrayMap("textArray", i, "height")
			local _height1 = pos[4]
			if _y > _y1 then
				setPropertyFromArrayMap("textArray", i, "visible", true)
			end
			if _y + _height < _y1 + _height1 then
				setPropertyFromArrayMap("textArray", i, "visible", true)
			end

			if _y < _y1 then
				setPropertyFromArrayMap("textArray", i, "visible", false)
			end
			if _y + _height > _y1 + _height1 then
				setPropertyFromArrayMap("textArray", i, "visible", false)
			end
		end
	end
end

-- copied from extra keys hscript lololol
--need to check if holding sustains because psych dumb and still uses shitty controls.hx
function onUpdatePost(elapsed)
    local noteCount = getProperty('notes.length')
    for i = 0,noteCount-1 do 
        if getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..getKeybindText(getPropertyFromGroup('notes', i, 'noteData'), true)) then
            if getPropertyFromGroup('notes', i, 'isSustainNote') and getPropertyFromGroup('notes', i, 'canBeHit') and not getPropertyFromGroup('notes', i, 'wasGoodHit')
            and getPropertyFromGroup('notes', i, 'mustPress') and not getPropertyFromGroup('notes', i, 'tooLate') then 
                runHaxeCode([[
                    game.goodNoteHit(game.notes.members[]]..i..[[]);
                ]])
            end
        end 
    end
end

function updateKeybinds()
	for i = 1, getProperty("textArray.length") - 1 do
		if i == 1 then
			if overlapFromGroup("textArray", i) then
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
				if mouseClicked('left') then
					playSound(scrollSound, 0.9)
					setProperty("text_dragger.text", "")
					regenMenu(0)
					break
				end
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		else
			if overlapFromGroup("textArray", i) then
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
				local d = runHaxeCode([[
					var keyPressed:Int = FlxG.keys.firstJustPressed();
					if (keyPressed > -1) {
						ClientPrefs.keyBinds.set(']]..keybindsName[i - 1]..[[', [keyPressed, ClientPrefs.keyBinds.get(']]..keybindsName[i - 1]..[[')[1] ]);
						ClientPrefs.saveSettings();
						game.keysArray = [
							ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
							ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
							ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
							ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
						];
						FlxG.sound.play(Paths.sound(scrollSound), 0.9);
						return true;
					}
					else
						return false;
				]])
				if d then
					local kt = getKeybindText(i - 2, false, true)
					setPropertyFromArrayMap("textArray", i, "text", kt)
					print(kt)
				end
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		end
	end
end

function updateValues()
	for i = 1, #optionsArray do
		local type = optionsArray[i].type
		local name = optionsArray[i].name
		if type == 'bool' then
			if overlapFromGroup("textArray", i) then
				if mouseClicked('left') then
					playSound(scrollSound, 0.9)

					optionsArray[i].value = intToBool(getPropertyFromClass('ClientPrefs', name), true)
					optionsArray[i].value = optionsArray[i].value + 1
					if optionsArray[i].value > #optionsArray[i].values then optionsArray[i].value = 1 end

					setOption(i, intToBool(optionsArray[i].value))
				end
				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
					setOption(i, intToBool(optionsArray[i].defaultValue))
				end
				setProperty("text_dragger.text", optionsArray[i].description)
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		elseif type == 'int' or type == 'float' then
			if overlapFromGroup("textArray", i) then
				local wheel = getPropertyFromClass('flixel.FlxG', 'mouse.wheel')
				if mousePressed('left') and wheel ~= 0 then
					playSound(scrollSound, 0.9)

					optionsArray[i].value = getPropertyFromClass('ClientPrefs', name)
					if wheel > 0 then optionsArray[i].value = optionsArray[i].value + optionsArray[i].step end
					if wheel < 0 then optionsArray[i].value = optionsArray[i].value - optionsArray[i].step end
					if optionsArray[i].value < optionsArray[i].min then optionsArray[i].value = optionsArray[i].max end
					if optionsArray[i].value > optionsArray[i].max then optionsArray[i].value = optionsArray[i].min end

					if type == 'int' then
						setOption(i, math.ceil(optionsArray[i].value))
					else
						setOption(i, optionsArray[i].value)
					end
				end
				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
					setOption(i, optionsArray[i].defaultValue)
				end
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
				setProperty("text_dragger.text", optionsArray[i].description)
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		elseif type == 'list' then
			if overlapFromGroup("textArray", i) then
				if mouseClicked('left') then
					playSound(scrollSound, 0.9)

					local list = optionsArray[i].values
					local find = getPropertyFromClass('ClientPrefs', name)
					for i1 = 1, #list do
						if stringEndsWith(list[i1], find) then
							optionsArray[i].value = i1
							break
						end
					end
					optionsArray[i].value = optionsArray[i].value + 1
					if optionsArray[i].value > #optionsArray[i].values then optionsArray[i].value = 1 end

					setOption(i, string.sub(optionsArray[i].values[optionsArray[i].value], lastIndexOf(optionsArray[i].values[optionsArray[i].value], " - ") + 3, #optionsArray[i].values[optionsArray[i].value]))
				end
				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') or mouseClicked('right') then
					setOption(i, string.sub(optionsArray[i].values[optionsArray[i].defaultValue], lastIndexOf(optionsArray[i].values[optionsArray[i].defaultValue], " - ") + 3, #optionsArray[i].values[optionsArray[i].defaultValue]))
				end
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
				setProperty("text_dragger.text", optionsArray[i].description)
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		elseif type == 'title' then
			setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_title)
		elseif type == 'custom' then
			if overlapFromGroup("textArray", i) then
				if optionsArray[i].name == "keyBindsMenu" then
					setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
					setProperty("text_dragger.text", optionsArray[i].description)
					if mouseClicked('left') then
						playSound(scrollSound, 0.9)
						setProperty("text_dragger.text", "To change hover mouse on bind and press key.\nClick on GO BACK to back in options.\n(game input disabled in menu)")
						regenMenu(1)
						break
					end
				elseif optionsArray[i].name == "gameplaySettingsMenu" then
					setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
					setProperty("text_dragger.text", optionsArray[i].description)
					if mouseClicked('left') then
						playSound(scrollSound, 0.9)
						setProperty("text_dragger.text", "")
						regenMenu(2)
						break
					end
				else
					setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_focus)
					setProperty("text_dragger.text", optionsArray[i].description)
				end
			else
				setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
			end
		else
			setProperty("text_dragger.text", "")
			setPropertyFromArrayMap("textArray", i, "color", "0xff"..color_unfocus)
		end
	end
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

-- might help avoid a crash
local savehidehud = false
function onCreate()
	savehidehud = getPropertyFromClass('ClientPrefs', 'hideHud')
	setPropertyFromClass('ClientPrefs', 'hideHud', false)
end
function onCreatePost()
	setPropertyFromClass('ClientPrefs', 'hideHud', savehidehud)

	if savehidehud then
		setProperty('healthBar.alpha', 0)
	else
		setProperty('healthBar.alpha', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))
	end
	setProperty('iconP1.visible', not savehidehud)
	setProperty('iconP2.visible', not savehidehud)
	setProperty('scoreTxt.visible', not savehidehud)
end


function setOption(index, value)
	-- notmiddlescroll - xstart: 732, xoffset: 112, xstartop: 92, xoffset: 112
	-- middlescroll - xstart: 412, xoffset: 112, xstartop: 82, xstartop2: 971
	local option = optionsArray[index].name
	--[[if option ~= 'fallingSnow' then
		setPropertyFromClass('ClientPrefs', option, value)
		runHaxeCode("ClientPrefs.saveSettings();")
		setPropertyFromArrayMap("textArray", index, "text", getOptionText(index))
	end]]--

	print(option, value, getOptionText(index))

	if option == 'downScroll' then
		if value == true then
			setValueStrums('y', screenHeight - 150, false)

			setProperty('healthBar.y', screenHeight * 0.11)
			setProperty('iconP1.y', getProperty('healthBar.y') - 75)
			setProperty('iconP2.y', getProperty('healthBar.y') - 75)
			setProperty('scoreTxt.y', getProperty('healthBar.y') + 36)
			setProperty('timeBar.y', screenHeight - 31)
			setProperty('botplayTxt.y', getProperty('timeBar.y') - 78)
		else
			setValueStrums('y', 50, false)

			setProperty('healthBar.y', screenHeight * 0.89)
			setProperty('iconP1.y', getProperty('healthBar.y') - 75)
			setProperty('iconP2.y', getProperty('healthBar.y') - 75)
			setProperty('scoreTxt.y', getProperty('healthBar.y') + 36)
			setProperty('timeBar.y', 31)
			setProperty('botplayTxt.y', getProperty('timeBar.y') + 55)
		end

		setValueStrums('downScroll', value, false)
		setLuaValue('downscroll', value)

		runHaxeCode([[
			for (note in game.unspawnNotes)
				if (note.isSustainNote && note.prevNote != null)
					note.flipY = ]]..tostring(value)..[[;
			for (note in game.notes)
				if (note.isSustainNote && note.prevNote != null)
					note.flipY = ]]..tostring(value)..[[;
		]])
	elseif option == 'middleScroll' then
		if value == true then
			for i = 0, getProperty("opponentStrums.length") - 1 do
				if getPropertyFromClass("ClientPrefs", "opponentStrums") then
					setPropertyFromGroup("opponentStrums", i, "alpha", 0.35)
				else
					setPropertyFromGroup("opponentStrums", i, "visible", false)
				end

				if (i < math.ceil(getProperty("opponentStrums.length") / 2)) then
					setPropertyFromGroup("opponentStrums", i, "x", 82 + (112 * i))
				else
					setPropertyFromGroup("opponentStrums", i, "x", 971 + (112 * (i - math.ceil(getProperty("opponentStrums.length") / 2))))
				end
			end
			for i = 0, getProperty("playerStrums.length") - 1 do setPropertyFromGroup("playerStrums", i, "x", 412 + (112 * i)) end
		else
			for i = 0, getProperty("opponentStrums.length") - 1 do
				if getPropertyFromClass("ClientPrefs", "opponentStrums") then
					setPropertyFromGroup("opponentStrums", i, "alpha", 1)
				else
					setPropertyFromGroup("opponentStrums", i, "visible", true)
				end

				setPropertyFromGroup("opponentStrums", i, "x", 92 + (112 * i))
			end
			for i = 0, getProperty("playerStrums.length") - 1 do setPropertyFromGroup("playerStrums", i, "x", 732 + (112 * i)) end
		end
		setLuaValue('middlescroll', value)
	elseif option == 'opponentStrums' then
		if value == true then
			for i = 0, getProperty("opponentStrums.length") - 1 do
				if getPropertyFromClass("ClientPrefs", "middleScroll") then
					setPropertyFromGroup("opponentStrums", i, "alpha", 0.35)
				else
					setPropertyFromGroup("opponentStrums", i, "alpha", 1)
				end
			end
		else
			for i = 0, getProperty("opponentStrums.length") - 1 do setPropertyFromGroup("opponentStrums", i, "alpha", 0) end
		end
	elseif option == 'healthBarAlpha' then
		setProperty('iconP1.alpha', value)
		setProperty('iconP2.alpha', value)
		setProperty('healthBar.alpha', value)
		setLuaValue('healthBarAlpha', value)
	elseif option == 'hideHud' then
		setProperty('iconP1.visible', not value)
		setProperty('iconP2.visible', not value)
		setLuaValue('hideHud', value)
		if value == true then
			setProperty('healthBar.alpha', 0)
		else
			setProperty('healthBar.alpha', getPropertyFromClass('ClientPrefs', 'healthBarAlpha'))
		end
		setProperty('scoreTxt.visible', not value)
	elseif option == 'timeBarType' then
		if value == 'Time Left' or value == 'Time Elapsed' then
			setProperty('timeBar.visible', true)
			setTextSize('timeTxt', 32)
		elseif value == 'Song Name' then
			setProperty('timeBar.visible', true)
			setTextString('timeTxt', getPropertyFromClass("PlayState", "SONG.song"))
			setTextSize('timeTxt', 24)
		elseif value == 'Disabled' then
			setProperty('timeBar.visible', false)
		end
		setLuaValue('timeBarType', value)
	elseif option == 'showFPS' then
		setPropertyFromClass('Main', 'fpsVar.visible', value)
	elseif option == 'sickWindow' then
		runHaxeCode("game.ratingsData[0].hitWindow = Reflect.field(ClientPrefs, '"..option.."');")
	elseif option == 'goodWindow' then
		runHaxeCode("game.ratingsData[1].hitWindow = Reflect.field(ClientPrefs, '"..option.."');")
	elseif option == 'badWindow' then
		runHaxeCode("game.ratingsData[2].hitWindow = Reflect.field(ClientPrefs, '"..option.."');")
	elseif option == 'safeFrames' then
		setPropertyFromClass('Conductor', 'safeZoneOffset', (value / 60) * 1000);
	elseif option == 'framerate' then
		setLuaValue('framerate', value)
	elseif option == 'ghostTapping' then
		setLuaValue('ghostTapping', value)
	elseif option == 'scoreZoom' then
		setLuaValue('scoreZoom', value)
	elseif option == 'camZooms' then
		setLuaValue('cameraZoomOnBeat', value)
	elseif option == 'flashing' then
		setLuaValue('flashingLights', value)
	elseif option == 'noteOffset' then
		setLuaValue('noteOffset', value)
	elseif option == 'noReset' then
		setLuaValue('noResetButton', value)
	elseif option == 'lowQuality' then
		setLuaValue('lowQuality', value)
	elseif option == 'shaders' then
		setLuaValue('shadersEnabled', value)
	--[[elseif option == 'fallingSnow' then
		fallingSnow_enabled = not fallingSnow_enabled
		runHaxeCode(
			FlxG.save.data.fallingSnow_enabled = ..tostring(fallingSnow_enabled)..;
			FlxG.save.flush();
			for (sf in getVar('snowflakes'))
				sf.visible = ..tostring(fallingSnow_enabled)..;
		)
		setPropertyFromArrayMap("textArray", index, "text", getOptionText(index))
	]]--
	end
end

function setValueStrums(vari, value, isString)
	if isString then
		runHaxeCode([[
			for (note in game.playerStrums) Reflect.setProperty(note, ']]..vari..[[', ']]..value..[[');
			for (note in game.opponentStrums) Reflect.setProperty(note, ']]..vari..[[', ']]..value..[[');
		]])
	else
		runHaxeCode([[
			for (note in game.playerStrums) Reflect.setProperty(note, ']]..vari..[[', ]]..tostring(value)..[[);
			for (note in game.opponentStrums) Reflect.setProperty(note, ']]..vari..[[', ]]..tostring(value)..[[);
			for (i in 0...4) {
				game.setOnLuas('defaultPlayerStrumX' + i, ]]..tostring(value)..[[ );
				game.setOnLuas('defaultPlayerStrumY' + i, ]]..tostring(value)..[[ );
				game.setOnLuas('defaultOpponentStrumX' + i, ]]..tostring(value)..[[ );
				game.setOnLuas('defaultOpponentStrumY' + i, ]]..tostring(value)..[[ );
			}
		]])
	end
end

function setLuaValue(name, value)
	runHaxeCode("game.setOnLuas('"..tostring(name).."', "..tostring(value)..");")
end

function overlap(object_name)
	local d = {
		tonumber(getProperty(object_name..".x")),
		tonumber(getProperty(object_name..".y")),
		tonumber(getProperty(object_name..".width")),
		tonumber(getProperty(object_name..".height"))
	}
	local x = math.ceil(runHaxeCode("return FlxG.mouse.getScreenPosition(game.camOther).x;"))
	local y = math.ceil(runHaxeCode("return FlxG.mouse.getScreenPosition(game.camOther).y;"))

	return x > d[1] and x < (d[1] + d[3]) and y > d[2] and y < (d[2] + d[4])
end
function overlapFromGroup(object_name, index)
	local d = {
		tonumber(getPropertyFromArrayMap(object_name, index, "x")),
		tonumber(getPropertyFromArrayMap(object_name, index, "y")),
		tonumber(getPropertyFromArrayMap(object_name, index, "width")),
		tonumber(getPropertyFromArrayMap(object_name, index, "height"))
	}
	local x = math.ceil(runHaxeCode("return FlxG.mouse.getScreenPosition(game.camOther).x;"))
	local y = math.ceil(runHaxeCode("return FlxG.mouse.getScreenPosition(game.camOther).y;"))

	return x > d[1] and x < (d[1] + d[3]) and y > d[2] and y < (d[2] + d[4])
end

function intToBool(value, reverse)
	if reverse then
		if value or value == 'true' then
			return 1
		else
			return 0
		end
	else
		if value == 1 or value == '1' then
			return true
		else
			return false
		end
	end
end

function getStaticProperty(variable)
	runHaxeCode([[ game.introSoundsSuffix = '' + ]]..variable..[[; ]])
	local dat = getProperty('introSoundsSuffix');
	runHaxeCode([[ game.introSoundsSuffix = ''; ]])
	return dat;
end
function setStaticProperty(variable, value)
	runHaxeCode(variable..' = '..value..';')
end

function onCustomSubstateDestroy(name)
	if name == "PauseMenu" then
		runHaxeCode([[
			for (op in getVar('objects_pm'))
			{
				op.kill();
				op.destroy();
			}
			setVar('bg_dragger', null);
			setVar('text_dragger', null);
			setVar('bg', null);
			setVar('textArray', []);
			setVar('textArrays', []);
			setVar('objects_pm', []);

			FlxG.mouse.visible = false;
		]])
		opened = false
	end
end