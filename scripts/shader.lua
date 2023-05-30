-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: script for applying shader to camHUD/camGame
-- How to use:
--   1. Put this script in mods/scripts
--   2. Change variables below

local shaderName = "VHS2015" -- mods/shaders/VHS2015.frag
local onCamHUD = true
local onCamGame = false

-------------------------------- config ended --------------------------------
---------- dont touch anything below if you dont know what u doing! ----------

function onCreatePost()
	shaderCoordFix()
	makeLuaSprite("doritos")
	makeGraphic("doritos", screenWidth, screenHeight)
	runHaxeCode([[
		game.initLuaShader(']]..shaderName..[[');
		shader0 = game.createRuntimeShader(']]..shaderName..[[');
		game.getLuaObject("doritos").shader = shader0;
		if (]]..tostring(onCamHUD)..[[) game.camHUD.bgColor = 0x01000000;
		if (]]..tostring(onCamHUD)..[[) game.camHUD.setFilters([new ShaderFilter(shader0)]);
		if (]]..tostring(onCamGame)..[[) game.camGame.setFilters([new ShaderFilter(shader0)]);
	]])
end

function onUpdatePost(elapsed)
	setShaderFloat('doritos', 'iTime', os.clock())
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