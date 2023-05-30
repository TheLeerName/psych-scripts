-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: just a copy of PauseSubstate.hx but coded on lua

function onPause()
	openCustomSubstate('PauseMenu', true)
	return Function_Stop
end

function onCustomSubstateCreate(name)
	if name == 'PauseMenu' then
		addHaxeLibrary('FlxTypedGroup', 'flixel.group')
		addHaxeLibrary('FlxSound', 'flixel.sound')
		addHaxeLibrary('FlxText', 'flixel.text')
		addHaxeLibrary('FlxMath', 'flixel.math')
		addHaxeLibrary('Alphabet')
		addHaxeLibrary('Math')
		addHaxeLibrary('Std')
		addHaxeLibrary('CoolUtil')
		addHaxeLibrary('FlxStringUtil', 'flixel.util')
		addHaxeLibrary('WeekData')
		addHaxeLibrary('Highscore')
		addHaxeLibrary('Song')
		addHaxeLibrary('MusicBeatState')

		runHaxeCode([[
			setVar('grpMenuShit', new FlxTypedGroup());

			setVar('menuItems', []);
			setVar('menuItemsOG', ['Resume', 'Restart Song', 'Change Difficulty', 'Exit to menu']);
			setVar('difficultyChoices', []);
			setVar('curSelected', 0);

			setVar('pauseMusic', new FlxSound());
			setVar('practiceText', new FlxText());
			setVar('skipTimeText', new FlxText());
			setVar('skipTimeTracker', new Alphabet());
			setVar('curTime', Math.max(0, Conductor.songPosition));

			setVar('holdTime', 0);
			setVar('cantUnpause', 0.1);

			setVar('objects', []);
		]])

		runHaxeCode([[
			if(CoolUtil.difficulties.length < 2) getVar('menuItemsOG').remove('Change Difficulty'); //No need to change difficulty if there is only one!

			if(PlayState.chartingMode)
			{
				getVar('menuItemsOG').insert(2, 'Leave Charting Mode');
				
				var num:Int = 0;
				if(!PlayState.instance.startingSong)
				{
					num = 1;
					getVar('menuItemsOG').insert(3, 'Skip Time');
				}
				getVar('menuItemsOG').insert(3 + num, 'End Song');
				getVar('menuItemsOG').insert(4 + num, 'Toggle Practice Mode');
				getVar('menuItemsOG').insert(5 + num, 'Toggle Botplay');
			}
			setVar('menuItems', getVar('menuItemsOG'));

			for (i in 0...CoolUtil.difficulties.length) {
				var diff:String = '' + CoolUtil.difficulties[i];
				getVar('difficultyChoices').push(diff);
			}
			getVar('difficultyChoices').push('BACK');
		]])

		runHaxeCode([[
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			bg.alpha = 0;
			bg.scrollFactor.set();
			getVar('objects').push(bg);

			var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
			levelInfo.text += PlayState.SONG.song;
			levelInfo.scrollFactor.set();
			levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
			levelInfo.updateHitbox();
			getVar('objects').push(levelInfo);

			var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
			levelDifficulty.text += CoolUtil.difficultyString();
			levelDifficulty.scrollFactor.set();
			levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
			levelDifficulty.updateHitbox();
			getVar('objects').push(levelDifficulty);

			var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
			blueballedTxt.text = "Blueballed: " + PlayState.deathCounter;
			blueballedTxt.scrollFactor.set();
			blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
			blueballedTxt.updateHitbox();
			getVar('objects').push(blueballedTxt);

			setVar('practiceText', new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32));
			getVar('practiceText').scrollFactor.set();
			getVar('practiceText').setFormat(Paths.font('vcr.ttf'), 32);
			getVar('practiceText').x = FlxG.width - (getVar('practiceText').width + 20);
			getVar('practiceText').updateHitbox();
			getVar('practiceText').visible = PlayState.instance.practiceMode;
			getVar('objects').push(getVar('practiceText'));

			var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
			chartingText.scrollFactor.set();
			chartingText.setFormat(Paths.font('vcr.ttf'), 32);
			chartingText.x = FlxG.width - (chartingText.width + 20);
			chartingText.y = FlxG.height - (chartingText.height + 20);
			chartingText.updateHitbox();
			chartingText.visible = PlayState.chartingMode;
			getVar('objects').push(chartingText);

			blueballedTxt.alpha = 0;
			levelDifficulty.alpha = 0;
			levelInfo.alpha = 0;

			levelInfo.x = FlxG.width - (levelInfo.width + 20);
			levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
			blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

			FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
			FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
			FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

			getVar('objects').push(getVar('grpMenuShit'));

			//cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1] ];
		]])

		runHaxeCode([[
			setVar('pauseMusic', FlxG.sound.play(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic))));
			getVar('pauseMusic').looped = true;
			getVar('pauseMusic').autoDestroy = true;
			getVar('pauseMusic').pause();
			getVar('pauseMusic').time = FlxG.random.int(0, Std.int(getVar('pauseMusic').length / 2));
			getVar('pauseMusic').resume();
			getVar('pauseMusic').volume = 0;
			FlxG.sound.list.add(getVar('pauseMusic'));
		]])

		runHaxeCode([[
			for (ob in getVar('objects'))
			{
				ob.cameras = [game.camOther];
				game.add(ob);
			}
		]])

		regenMenu()
	end
end

function onCustomSubstateUpdate(name, elapsed)
	if name == 'PauseMenu' then
		runHaxeCode([[
			setVar('cantUnpause', getVar('cantUnpause') - ]]..tostring(elapsed)..[[);
			if (getVar('pauseMusic').volume < 0.5)
				getVar('pauseMusic').volume += 0.01 * ]]..tostring(elapsed)..[[;

			if(getVar('skipTimeText') == null || getVar('skipTimeTracker') == null) return;

			getVar('skipTimeText').x = getVar('skipTimeTracker').x + getVar('skipTimeTracker').width + 60;
			getVar('skipTimeText').y = getVar('skipTimeTracker').y;
			getVar('skipTimeText').visible = (getVar('skipTimeTracker').alpha >= 1);
		]])
		--if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then
			--closeCustomSubstate()
			--runHaxeCode("getVar('pauseMusic').stop();")
		--elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
			--loadSong(songPath)
			--runHaxeCode("getVar('pauseMusic').stop();")
		--end
		if getStaticProperty("PlayState.instance.getControl('UI_UP_P')") == 'true' then
			changeSelection(-1)
		end
		if getStaticProperty("PlayState.instance.getControl('UI_DOWN_P')") == 'true' then
			changeSelection(1)
		end

		runHaxeCode([[
			var daSelected:String = getVar('menuItems')[getVar('curSelected')];
			switch (daSelected)
			{
				case 'Skip Time':
					if (PlayState.instance.getControl('UI_LEFT_P'))
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						setVar('curTime', getVar('curTime') - 1000);
						setVar('holdTime', 0);
					}
					if (PlayState.instance.getControl('UI_RIGHT_P'))
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						setVar('curTime', getVar('curTime') + 1000);
						setVar('holdTime', 0);
					}

					if(PlayState.instance.getControl('UI_LEFT') || PlayState.instance.getControl('UI_RIGHT'))
					{
						setVar('holdTime', getVar('holdTime') + ]]..tostring(elapsed)..[[);
						if(getVar('holdTime') > 0.5)
						{
							setVar('curTime', getVar('curTime') + (45000 * ]]..tostring(elapsed)..[[ * (PlayState.instance.getControl('UI_LEFT') ? -1 : 1)));
						}

						if(getVar('curTime') >= FlxG.sound.music.length) setVar('curTime', getVar('curTime') - FlxG.sound.music.length);
						else if(getVar('curTime') < 0) setVar('curTime', getVar('curTime') + FlxG.sound.music.length);
						getVar('skipTimeText').text = FlxStringUtil.formatTime(Math.max(0, Math.floor(getVar('curTime') / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
					}
			}
		]])

		setProperty("practiceText.visible", getProperty("practiceMode"))
		setProperty("botplayTxt.visible", getProperty("cpuControlled"))

		if getStaticProperty("PlayState.instance.getControl('ACCEPT')") == 'true' and (tonumber(getStaticProperty("getVar('cantUnpause')")) <= 0 or not getPropertyFromClass('ClientPrefs', 'controllerMode')) then
			if getStaticProperty("getVar('menuItems') == getVar('difficultyChoices')") == 'true' then
				if getStaticProperty("getVar('menuItems')[getVar('curSelected')]") ~= 'BACK' then
					runHaxeCode([[
						var name:String = PlayState.SONG.song;
						var poop = Highscore.formatSong(name, getVar('curSelected'));
						PlayState.SONG = Song.loadFromJson(poop, name);
						PlayState.storyDifficulty = getVar('curSelected');
						MusicBeatState.resetState();
						FlxG.sound.music.volume = 0;
						PlayState.changedDifficulty = true;
						PlayState.chartingMode = false;
					]])
				else
					runHaxeCode("setVar('menuItems', getVar('menuItemsOG'));")
					regenMenu()
				end
			end

			local daSelected = getStaticProperty("getVar('menuItems')[getVar('curSelected')]")
			if daSelected == "Resume" then
				closeCustomSubstate()
			elseif daSelected == "Change Difficulty" then
				runHaxeCode([[
					setVar('menuItems', getVar('difficultyChoices'));
					if(getVar('skipTimeText') != null)
					{
						getVar('skipTimeText').kill();
						game.remove(getVar('skipTimeText'));
						getVar('skipTimeText').destroy();
					}
					setVar('skipTimeText', null);
					setVar('skipTimeTracker', null);
				]])
				regenMenu()
			elseif daSelected == "Toggle Practice Mode" then
				runHaxeCode([[
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					getVar('practiceText').visible = PlayState.instance.practiceMode;
				]])
			elseif daSelected == "Restart Song" then
				restsong(false)
			elseif daSelected == "Leave Charting Mode" then
				restsong(false)
				runHaxeCode("PlayState.chartingMode = false;")
			elseif daSelected == "Skip Time" then
				if tonumber(getStaticProperty("getVar('curTime')")) < getPropertyFromClass('Conductor', 'songPosition') then
					runHaxeCode("PlayState.startOnTime = getVar('curTime');")
					restsong(true)
				else
					if tonumber(getStaticProperty("getVar('curTime')")) ~= getPropertyFromClass('Conductor', 'songPosition') then
						runHaxeCode([[
							PlayState.instance.clearNotesBefore(getVar('curTime'));
							PlayState.instance.setSongTime(getVar('curTime'));
						]])
						closeCustomSubstate()
					end
				end
			elseif daSelected == "End Song" then
				closeCustomSubstate()
				runHaxeCode("PlayState.instance.finishSong(true);")
			elseif daSelected == "Toggle Botplay" then
				runHaxeCode([[
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				]])
			elseif daSelected == "Exit to menu" then
				runHaxeCode([[
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					WeekData.loadTheFirstEnabledMod();
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
				]])
			end
		end

		-- why the fuck alphabet update function is not working??
		runHaxeCode([[
			for (item in getVar('grpMenuShit').members)
			{
				var lerpVal:Float = CoolUtil.boundTo(]]..tostring(elapsed)..[[ * 9.6, 0, 1);
				item.x = FlxMath.lerp(item.x, (item.targetY * item.distancePerItem.x) + item.startPosition.x, lerpVal);
				item.y = FlxMath.lerp(item.y, (item.targetY * 1.3 * item.distancePerItem.y) + item.startPosition.y, lerpVal);
			}
		]])
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

function regenMenu()
	runHaxeCode([[
		for (i in 0...getVar('grpMenuShit').members.length) {
			var obj = getVar('grpMenuShit').members[0];
			obj.kill();
			getVar('grpMenuShit').remove(obj, true);
			obj.destroy();
		}

		for (i in 0...getVar('menuItems').length) {
			var item = new Alphabet(90, 320, getVar('menuItems')[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			getVar('grpMenuShit').add(item);

			if(getVar('menuItems')[i] == 'Skip Time')
			{
				setVar('skipTimeText', new FlxText(0, 0, 0, '', 64));
				getVar('skipTimeText').setFormat(Paths.font("vcr.ttf"), 64, 0xffffffff, 'center');
				getVar('skipTimeText').scrollFactor.set();
				getVar('skipTimeText').borderSize = 2;
				setVar('skipTimeTracker', item);
				getVar('objects').push(getVar('skipTimeText'));
				game.add(getVar('skipTimeText'));
				getVar('skipTimeText').cameras = [game.camOther];

				if(getVar('skipTimeText') == null || getVar('skipTimeTracker') == null) return;

				getVar('skipTimeText').x = getVar('skipTimeTracker').x + getVar('skipTimeTracker').width + 60;
				getVar('skipTimeText').y = getVar('skipTimeTracker').y;
				getVar('skipTimeText').visible = (getVar('skipTimeTracker').alpha >= 1);

				getVar('skipTimeText').text = FlxStringUtil.formatTime(Math.max(0, Math.floor(getVar('curTime') / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
			}
		}
		setVar('curSelected', 0);
	]])
	changeSelection(0)
end

function changeSelection(change)
	runHaxeCode([[
		setVar('curSelected', getVar('curSelected') + ]]..tostring(change)..[[);

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (getVar('curSelected') < 0)
			setVar('curSelected', getVar('menuItems').length - 1);
		if (getVar('curSelected') >= getVar('menuItems').length)
			setVar('curSelected', 0);

		var bullShit = 0;

		for (item in getVar('grpMenuShit').members)
		{
			item.targetY = bullShit - getVar('curSelected');
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == getVar('skipTimeTracker'))
				{
					setVar('curTime', Math.max(0, Conductor.songPosition));
					getVar('skipTimeText').text = FlxStringUtil.formatTime(Math.max(0, Math.floor(getVar('curTime') / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
				}
			}
		}
	]])
end

function restsong(skiptrans)
	runHaxeCode([[
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(]]..tostring(skiptrans)..[[)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	]])
end

function onCustomSubstateDestroy(name)
	if name == 'PauseMenu' then
		runHaxeCode([[
			//if (getVar('pauseMusic') != null) getVar('pauseMusic').destroy();
			getVar('pauseMusic').stop();
			for (ob in getVar('objects'))
				ob.destroy();
		]])
	end
end