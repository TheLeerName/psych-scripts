-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: new tween functions
-- How to use:
--   1. Just put these functions in your script and use it <3

-- just example
function onSongStart()
	doTween("gftween", "gf", {x = 200, y = 200}, 5, "linear")
	doTweenFromClass("dasd", "openfl.Lib", "application.window", {width = 600, height = 600}, 5, 'backin')
end

function doTween(tag, vars, values, duration, ease)
    local newValue = "{"
    if ease == nil then ease = "" end
    for var, val in pairs(values) do newValue = newValue..var..":"..val.."," end
    values = string.sub(newValue, 1, #newValue - 1).."}"
	addHaxeLibrary("FunkinLua")
    runHaxeCode([[
		var penisExam = null;
		var killMe = ']]..vars..[['.split('.');
		if(killMe.length > 1)
			penisExam = FunkinLua.getVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
		else
			penisExam = FunkinLua.getVarInArray(FunkinLua.getInstance(), ']]..vars..[[');

        if(penisExam != null) {
            game.modchartTweens.set(']]..tag..[[', FlxTween.tween(penisExam, ]]..values..[[, ]]..duration..[[, {ease: game.luaArray[0].getFlxEaseByString(']]..ease..[['),
                onComplete: function(twn:FlxTween) {
                    game.callOnLuas('onTweenCompleted', [']]..tag..[[']);
                    game.modchartTweens.remove(']]..tag..[[');
                }
            }));
        }
    ]])
end
function doTweenFromClass(tag, classVar, vars, values, duration, ease)
    local newValue = "{"
    if ease == nil then ease = "" end
    for var, val in pairs(values) do newValue = newValue..var..":"..val.."," end
    values = string.sub(newValue, 1, #newValue - 1).."}"
	addHaxeLibrary("FunkinLua")
	addHaxeLibrary("Type")
    runHaxeCode([[
		var penisExam = null;
		var killMe = ']]..vars..[['.split('.');
		if(killMe.length > 1) {
			var coverMeInPiss = FunkinLua.getVarInArray(Type.resolveClass(']]..classVar..[['), killMe[0]);
			for (i in 1...killMe.length-1) {
				coverMeInPiss = FunkinLua.getVarInArray(coverMeInPiss, killMe[i]);
			}
			penisExam = FunkinLua.getVarInArray(coverMeInPiss, killMe[killMe.length-1]);
		}
		else
			penisExam = FunkinLua.getVarInArray(Type.resolveClass(']]..classVar..[['), ']]..vars..[[');
        if(penisExam != null) {
            game.modchartTweens.set(']]..tag..[[', FlxTween.tween(penisExam, ]]..values..[[, ]]..duration..[[, {ease: game.luaArray[0].getFlxEaseByString(']]..ease..[['),
                onComplete: function(twn:FlxTween) {
                    game.callOnLuas('onTweenCompleted', [']]..tag..[[']);
                    game.modchartTweens.remove(']]..tag..[[');
                }
            }));
		}
    ]])
end