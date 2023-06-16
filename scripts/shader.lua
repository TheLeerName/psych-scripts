-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: script for applying shader to camHUD/camGame/FlxG.game
-- How to use:
--   1. Put this script in mods/scripts
--   2. Change variables below

local shaderName = "VHS2015" -- mods/shaders/VHS2015.frag
local onCamHUD = true
local onCamGame = false
local onEntireGame = false

-------------------------------- config ended --------------------------------
---------- dont touch anything below if you dont know what u doing! ----------

local iTime_exists = false
function onCreatePost()
	shaderCoordFix()
	makeLuaSprite("doritos")
	makeGraphic("doritos", screenWidth, screenHeight)
	addHaxeLibrary("Type")
	iTime_exists = runHaxeCode([[
		if (!ClientPrefs.shaders) return false; // remove it if you want adding shaders with disabled option of it >:)

		var shaderContent = [null, null];
		var iTime_exists = false;
		if (Type.resolveClass('sys.FileSystem').exists('mods/shaders/]]..shaderName..[[.frag')) {
			shaderContent[0] = Type.resolveClass('sys.io.File').getContent('mods/shaders/]]..shaderName..[[.frag');
			iTime_exists = Type.resolveClass('StringTools').replace(shaderContent[0], 'uniform float iTime;', '') != shaderContent[0];
		}
		if (Type.resolveClass('sys.FileSystem').exists('mods/shaders/]]..shaderName..[[.vert'))
			shaderContent[1] = Type.resolveClass('sys.io.File').getContent('mods/shaders/]]..shaderName..[[.vert');

		shader0 = new FlxRuntimeShader(shaderContent[0], shaderContent[1]);
		game.runtimeShaders.set(']]..shaderName..[[', shaderContent);

		game.getLuaObject("doritos").shader = shader0;
		if (]]..tostring(onCamHUD)..[[) game.camHUD.bgColor = 0x01000000;
		if (]]..tostring(onCamHUD)..[[) game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("doritos").shader)]);
		if (]]..tostring(onCamGame)..[[) game.camGame.setFilters([new ShaderFilter(game.getLuaObject("doritos").shader)]);
		if (]]..tostring(onEntireGame)..[[) FlxG.game.setFilters([new ShaderFilter(game.getLuaObject("doritos").shader)]);

		return iTime_exists;
	]])
	-- example to set uniforms
	-- setShaderFloat('doritos', 'prob', 1)
end
function onDestroy()
	runHaxeCode("FlxG.game.setFilters([]);")
end

function onUpdatePost(elapsed)
	if iTime_exists then
		setShaderFloat('doritos', 'iTime', os.clock())
	end
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
    
    local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
        if (temp) then temp() end
    end
end