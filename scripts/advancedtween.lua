-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: just a advanced tween function like in haxe
-- How to use:
--   1. Put these functions in your script <3

function onCountdownStarted()
	doTween("bfscale", "boyfriend.scale", {x = 1.5, y = 1.5}, 4, {ease = "bounceout", startDelay = 0.1,
		onUpdate = function(tag, percent)
			debugPrint(tag..": "..(percent * 100).."%")
		end,
		onComplete = function(tag)
			debugPrint(tag.." tween completed")
		end
	})
end

function doTween(tag, vars, values, duration, options)
	local newValue = "{"
	if ease == nil then ease = "" end
	for var, val in pairs(values) do newValue = newValue..var..":"..val.."," end
	values = string.sub(newValue, 1, #newValue - 1).."}"

	if options == nil then options = {} end
	local typez = {[1] = 1, [2] = 2, [4] = 4, [8] = 8, [16] = 16, ["persist"] = 1, ["looping"] = 2, ["pingpong"] = 4, ["oneshot"] = 8, ["backward"] = 16}
	options.type = typez[options.type]
	if options.type == nil then options.type = 8 end
	doTween_opt_update = options.onUpdate or function (tag, percent) end
	doTween_opt_start = options.onStart or function (tag) end
	doTween_opt_complete = options.onComplete or function (tag) end
	
	
	addHaxeLibrary("FunkinLua")
	runHaxeCode([[
		var penisExam = null;
		var killMe = ']]..vars..[['.split('.');
		if(killMe.length > 1)
			penisExam = FunkinLua.getVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
		else
			penisExam = FunkinLua.getVarInArray(FunkinLua.getInstance(), ']]..vars..[[');

		var lua = game.luaArray[0];
		for (llua in game.luaArray) if (llua.scriptName == ']]..scriptName..[[') lua = llua;
		if(penisExam != null) {
			game.modchartTweens.set(']]..tag..[[', FlxTween.tween(penisExam, ]]..values..[[, ]]..duration..[[, {
				type: ]]..options.type..[[,
				ease: game.luaArray[0].getFlxEaseByString(']]..(options.ease or "")..[['),
				startDelay: ]]..(options.startDelay or 0)..[[,
				loopDelay: ]]..(options.loopDelay or 0)..[[,
				onUpdate: function (twn:FlxTween) { lua.call('doTween_opt_update', [']]..tag..[[', twn.percent]); },
				onStart: function (twn:FlxTween) { lua.call('doTween_opt_start', [']]..tag..[[']); },
				onComplete: function(twn:FlxTween) {
					lua.call('doTween_opt_complete', [']]..tag..[[']);
					game.callOnLuas('onTweenCompleted', [']]..tag..[[']);
					if (]]..options.type..[[ == 8 || ]]..options.type..[[ == 16) game.modchartTweens.remove(']]..tag..[[');
				}
			}));
		}
	]])
end