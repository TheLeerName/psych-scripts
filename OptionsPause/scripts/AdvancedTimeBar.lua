-- WARNING: USES PSYCH ENGINE 0.6.1 AND LATER

-- Author: TheLeerName
-- Description: script does tracking timeBar to change values of timeTxt and timeBarBG, ex. if you moving timeBar then timeTxt and timeBarBG will be move too!

function onCreatePost()
	addHaxeLibrary('Math')
	addHaxeLibrary('Conductor')
	addHaxeLibrary('ClientPrefs')
	addHaxeLibrary('FlxStringUtil', 'flixel.util')
	
	if getPropertyFromClass('ClientPrefs', 'timeBarType') == 'Disabled' then
		setProperty('timeTxt.visible', false)
		setProperty('timeBar.visible', false)
		setProperty('timeBarBG.visible', false)
	else
		setProperty('timeTxt.visible', true)
		setProperty('timeBar.visible', true)
		setProperty('timeBarBG.visible', true)
	end
end

function onSongStart()
	doTweenAlpha('die1', 'timeTxt', 1, 0.5, 'circOut')
	doTweenAlpha('die2', 'timeBar', 1, 0.5, 'circOut')
	doTweenAlpha('die3', 'timeBarBG', 1, 0.5, 'circOut')
end

function onUpdatePost()
	if not getProperty('startingSong') and not getProperty('paused') then
		setProperty('timeTxt.x', getProperty('timeBar.x') + (getProperty('timeBar.width') / 2) - 4 - (getProperty('timeTxt.width') / 2))
		setProperty('timeTxt.y', getProperty('timeBar.y') - 4 - (getProperty('timeTxt.height') / 4))
		setProperty('timeTxt.alpha', getProperty('timeBar.alpha'))
		setProperty('timeTxt.visible', getProperty('timeBar.visible'))
		setProperty('timeTxt.angle', getProperty('timeBar.angle'))

		setProperty('timeBarBG.x', getProperty('timeBar.x') - 4)
		setProperty('timeBarBG.y', getProperty('timeBar.y') - 4)
		setGraphicSize('timeBarBG', getProperty('timeBar.width') + 8, getProperty('timeBar.height') + 8)
		setProperty('timeBarBG.alpha', getProperty('timeBar.alpha'))
		setProperty('timeBarBG.visible', getProperty('timeBar.visible'))
		setProperty('timeBarBG.angle', getProperty('timeBar.angle'))

		if getPropertyFromClass('ClientPrefs', 'timeBarType') ~= 'Disabled' then
			runHaxeCode([[
				var curTime = Conductor.songPosition - ClientPrefs.noteOffset;
				if(curTime < 0) curTime = 0;
				var songPercent = (curTime / FlxG.sound.music.length);

				var songCalc = (FlxG.sound.music.length - curTime);
				if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

				var secondsTotal = Math.floor(songCalc / 1000);
				if(secondsTotal < 0) secondsTotal = 0;

				if(ClientPrefs.timeBarType != 'Song Name')
					game.timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				
				game.timeBar.value = songPercent;
			]])
			setProperty('timeTxt.visible', true)
			setProperty('timeBar.visible', true)
			setProperty('timeBarBG.visible', true)
		else
			setProperty('timeTxt.visible', false)
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
		end
	end
end