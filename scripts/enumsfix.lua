-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: fix of enums for lua/hscript

-- WARNING 2: if you wanna copy any function from here, dont forget add addHaxeLibrary("Type") in start of function onCreate(), or just add it in start of function which you wanna copy!!!!

-- just a example how it works
function onCreatePost()
	addHaxeLibrary("FlxTextBorderStyle", "flixel.text") -- adds FlxTextBorderStyle as enum

	setEnumFromProperty("scoreTxt.borderStyle", 0) -- 0 will work too cuz 0 = NONE; print getEnumFieldsFromProperty('scoreTxt.borderStyle') to see all possible vars for it!
	setProperty("scoreTxt.borderStyle", "none") -- u can use it in lowercase too

	-- get/setEnumFromProperty works as get/setProperty, but if it not enum, it will do nothing

	-- just debugPrint examples, uncomment it if you want see how it work
	--[[
		debugPrint('scoreTxt.borderStyle: '..getProperty("scoreTxt.borderStyle"))
		debugPrint('enum fields length of scoreTxt.borderStyle: '..#getEnumFieldsFromProperty("scoreTxt.borderStyle"))
		debugPrint('enum fields length of flixel.text.FlxTextBorderStyle: '..#getEnumFields("flixel.text.FlxTextBorderStyle"))
		debugPrint('enum name of scoreTxt.borderStyle: '..getEnumNameFromProperty("scoreTxt.borderStyle"))
		if not isEnumFromProperty('dad.x') then debugPrint('dad.x is not enum') end
		if not isEnum('flixel.text.FlxText') then debugPrint('flixel.text.FlxText is not enum') end
	]]--
end

-- fixes of common lua funcs
function onCreate()
	addHaxeLibrary("Type") -- the very important line
	local oldAHL = addHaxeLibrary
	addHaxeLibrary = function (className, package)
		local classPath = className
		package = package or ""
		if #package > 0 then classPath = package.."."..className end
		if isEnum(classPath) then
			runHaxeCode(className.."=Type.resolveEnum('"..classPath.."');")
			return
		end
		oldAHL(className, package)
	end
	local oldSP = setProperty
	setProperty = function (property, value)
		if isEnumFromProperty(property) then
			setEnumFromProperty(property, value)
		else
			oldSP(property, value)
		end
		return true
	end
	local oldGP = getProperty
	getProperty = function (property, value)
		if isEnumFromProperty(property) then return getEnumFromProperty(property, value) end
		return oldGP(property, value)
	end
end

-- dont touch everything bottom if you dont know what u doing!

function existsLuaObject(obj)
	for i, k in ipairs({"modchartSprites", "modchartTexts", "variables"}) do
		if runHaxeCode("return game."..k..".exists('"..obj.."');") then return true end
	end
	return false
end

function getEnumFromProperty(property)
	local enum, property = getEnumNameFromProperty(property)
	if enum == nil then return nil end

	return runHaxeCode("return "..property.." + '';")
end

function setEnumFromProperty(property, value)
	local enum, property = getEnumNameFromProperty(property)
	if enum == nil then return end
	if type(value) == "number" then
		value = value + 1
		local enumFields = getEnumFields(enum)
		if value > #enumFields or value < 1 then return end
		if runHaxeCode("return Type.resolveClass('Reflect').getProperty(Type.resolveEnum('"..enum.."'), '"..enumFields[value].."') == null;") then return end
		value = "Type.resolveEnum('"..enum.."')."..enumFields[value]
	else
		value = value:upper()
		if runHaxeCode("return Type.resolveClass('Reflect').getProperty(Type.resolveEnum('"..enum.."'), '"..value.."') == null;") then return end
		value = "Type.resolveEnum('"..enum.."')."..value
	end

	runHaxeCode(property.."="..value..";")
end

function isEnum(enum)
	return runHaxeCode("return Type.resolveEnum('"..enum.."') != null;")
end

function isEnumFromProperty(property)
	local enum, property = getEnumNameFromProperty(property)
	return enum ~= nil
end

function getEnumFields(enum)
	return runHaxeCode("return Type.getClassFields(Type.resolveEnum('"..enum.."'));")
end

function getEnumFieldsFromProperty(property)
	local enum, property = getEnumNameFromProperty(property)
	if enum == nil then return {} end
	return getEnumFields(enum)
end

function getEnumNameFromProperty(property)
	if existsLuaObject(property) then property = "getLuaObject('"..property.."')" end
	property = "game."..property
	if runHaxeCode("return (Type.typeof("..property..") + '').substring(0, 5) != 'TEnum';") then return nil end

	return runHaxeCode("var str = (Type.typeof("..property..") + ''); return str.substring(6, str.length - 1);"), property
end