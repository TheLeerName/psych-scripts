-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: just a rainbow score txt :)
-- How to use:
--   1. Put this script in mods/scripts
--   2. Now you have rainbow score txt <3

local hue = 0
function onUpdate(elapsed)
	hue = hue + 1
	if hue > 360 then hue = 0 end
	runHaxeCode("game.scoreTxt.clearFormats();")
	changeFormat("scoreTxt", HSVToHEX(hue, 1, 1), "000000", string.find(getProperty("scoreTxt.text"), "Score: "), string.find(getProperty("scoreTxt.text"), "| Misses: "))
	changeFormat("scoreTxt", HSVToHEX(hue, 1, 1), "000000", string.find(getProperty("scoreTxt.text"), "Misses: "), string.find(getProperty("scoreTxt.text"), "| Rating: "))
	changeFormat("scoreTxt", HSVToHEX(hue, 1, 1), "000000", string.find(getProperty("scoreTxt.text"), "Rating: "), #getProperty("scoreTxt.text") + 1)
end

function HSVToHEX(hue, saturation, value)
	if saturation == 0 then
		return "000000"
	end

	-- Get the hue sector
	local hue_sector = math.floor( hue / 60 );
	local hue_sector_offset = ( hue / 60 ) - hue_sector;

	local p = value * ( 1 - saturation );
	local q = value * ( 1 - saturation * hue_sector_offset );
	local t = value * ( 1 - saturation * ( 1 - hue_sector_offset ) );

	local rgb = {0, 0, 0}
	if hue_sector == 0 then
		rgb = {value, t, p};
	elseif hue_sector == 1 then
		rgb = {q, value, p};
	elseif hue_sector == 2 then
		rgb = {p, value, t};
	elseif hue_sector == 3 then
		rgb = {p, q, value};
	elseif hue_sector == 4 then
		rgb = {t, p, value};
	elseif hue_sector == 5 then
		rgb = {value, p, q};
	end;
	return ('%02X'):format(tonumber(rgb[1] * 255))..('%02X'):format(tonumber(rgb[2] * 255))..('%02X'):format(tonumber(rgb[3] * 255))
end

--[[
 Changes format of `FlxText` object on specific lines

		Arguments:
	textObject : string -> A name of text object to change
	textColor : string -> 24-bit color of specific string (ex. "ffffff")
	borderColor : string -> 24-bit border color of specific string (ex. "000000")
	beginIndex : number -> The start index of the string
	endIndex : number -> The end index of the string

	Returns true if function successfully executed, otherwise returns nil
]]--
function changeFormat(textObject, textColor, borderColor, beginIndex, endIndex)
	if luaTextExists(textObject) then textObject = "game.modchartTexts.get('"..textObject.."')" else textObject = "game."..textObject end
	return runHaxeCode(textObject..".addFormat(new flixel.text.FlxTextFormat(0x"..textColor..", false, false, 0x"..borderColor.."), "..tostring(beginIndex - 1)..", "..tostring(endIndex - 1).."); return true;")
end