function onUpdate()
	if runHaxeCode("return FlxG.keys.anyJustPressed(ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1')));") then
		setProperty('inCutscene', true)
		openCustomSubstate('fucku', true)
	end
end

function onCustomSubstateCreate(name)
	if name == 'fucku' then
		addHaxeLibrary('FlxMath', 'flixel.math')
		addHaxeLibrary('Application', 'lime.app')
		addHaxeLibrary('Date')
		addHaxeLibrary('StringTools')
		addHaxeLibrary('FileSystem', 'sys')
		addHaxeLibrary('File', 'sys.io')
		addHaxeLibrary('FlxTransitionableState', 'flixel.addons.transition')
		addHaxeLibrary('TitleState')
		addHaxeLibrary('WeekData')
		addHaxeLibrary('Paths')
		addHaxeLibrary('Main')
		addHaxeLibrary('Std')
		addHaxeLibrary('Type')
		addHaxeLibrary('TextField', 'openfl.text')
		addHaxeLibrary('TextFormat', 'openfl.text')

		makeLuaSprite('diepng', 'die', 0, 0)
		setGraphicSize('diepng', 1280, 720)
		setObjectCamera('diepng', 'camother')
		addLuaSprite('diepng', true)

		makeLuaSprite('diewhite', nil, 0, 0)
		makeGraphic('diewhite', 1280, 720, 'FFFFFF')
		setObjectCamera('diewhite', 'camother')
		addLuaSprite('diewhite', true)

		runHaxeCode([[
			fpsVar = new TextField();
			FlxG.stage.addChild(fpsVar);
			fpsVar.x = 10;
			fpsVar.y = 3;
			fpsVar.selectable = false;
			fpsVar.mouseEnabled = false;
			fpsVar.defaultTextFormat = new TextFormat('_sans', 14, 0xffffff);
			fpsVar.autoSize = 'LEFT';
			fpsVar.multiline = true;
			fpsVar.text = 'KYS: now\nKill: 655.3 YS';
			fpsVar.textColor = 0xffffffff;
			fpsVar.visible = Main.fpsVar.visible;
		]])
		setPropertyFromClass("Main", "fpsVar.visible", false)

		playSound('die', 1, 'diemp3')

		doTweenAlpha('tweenalphadiewhite', 'diewhite', 0, 2.25, 'smoothstepout')
	end
end

local time = 0
function onCustomSubstateUpdate(name, elapsed)
	if name == 'fucku' then
		time = time + elapsed
		if not luaSoundExists('diemp3') then
			closeCustomSubstate()
		end
		if runHaxeCode("return FlxG.keys.justPressed.J;") then closeCustomSubstate() end
		if runHaxeCode("return FlxMath.roundDecimal("..tostring(time)..", 1);") == 6 then
			doTweenAlpha('tweenalphadiewhite', 'diewhite', 0.95, 0.3, 'bouncein')
		end
		if runHaxeCode("return FlxMath.roundDecimal("..tostring(time)..", 1);") == 6.4 then
			doTweenAlpha('tweenalphadiewhite', 'diewhite', 0, 1.5, 'smoothstepout')
		end
	end
end

function onCustomSubstateDestroy(name)
	if name == 'fucku' then
		removeLuaSprite('diepng')
		removeLuaSprite('diewhite')
		time = 0
		setProperty('inCutscene', false)
		fakeCrash()
	end
end

function fakeCrash()
playSound('error')
runHaxeCode([[
var dateNow = Date.now().toString();
dateNow = StringTools.replace(dateNow, " ", "_");
dateNow = StringTools.replace(dateNow, ":", "'");
if (!FileSystem.exists('crash')) FileSystem.createDirectory('crash');
var path = "crash/PsychEngine_" + dateNow + ".txt";

Application.current.window.alert("StrumNote.hx (line 139)
flixel/group/FlxGroup.hx (line 175)
flixel/group/FlxGroup.hx (line 175)
flixel/addons/ui/FlxUIState.hx (line 212)
MusicBeatState.hx (line 70)
PlayState.hx (line 3025)
flixel/FlxState.hx (line 203)
flixel/FlxGame.hx (line 747)
flixel/FlxGame.hx (line 677)
flixel/FlxGame.hx (line 551)
openfl/events/EventDispatcher.hx (line 402)
openfl/display/DisplayObject.hx (line 1399)]

Uncaught Error: you are an idiot!
Please report this error to the GitHub page: https://www.youtube.com/watch?v=dQw4w9WgXcQ

> Crash Handler written by: sqirra-rng
Crash dump saved in " + path,
"Error!");
File.saveContent(path, "lol r u data miner?\nTmV2ZXIgR29ubmEgR2l2ZSBZb3UgVXAgTHlyaWNzCgpbSW50cm9dCkRlc2VydCB5b3UKT29oLW9vaC1vb2gtb29oCkh1cnQgeW91CgpbVmVyc2UgMV0KV2UncmUgbm8gc3RyYW5nZXJzIHRvIGxvdmUKWW91IGtub3cgdGhlIHJ1bGVzIGFuZCBzbyBkbyBJCkEgZnVsbCBjb21taXRtZW50J3Mgd2hhdCBJJ20gdGhpbmtpbmcgb2YKWW91IHdvdWxkbid0IGdldCB0aGlzIGZyb20gYW55IG90aGVyIGd1eQoKW1ByZS1DaG9ydXNdCkkganVzdCB3YW5uYSB0ZWxsIHlvdSBob3cgSSdtIGZlZWxpbmcKR290dGEgbWFrZSB5b3UgdW5kZXJzdGFuZAoKW0Nob3J1c10KTmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXAKTmV2ZXIgZ29ubmEgbGV0IHlvdSBkb3duCk5ldmVyIGdvbm5hIHJ1biBhcm91bmQgYW5kIGRlc2VydCB5b3UKTmV2ZXIgZ29ubmEgbWFrZSB5b3UgY3J5Ck5ldmVyIGdvbm5hIHNheSBnb29kYnllCk5ldmVyIGdvbm5hIHRlbGwgYSBsaWUgYW5kIGh1cnQgeW91CgpbVmVyc2UgMl0KV2UndmUga25vd24gZWFjaCBvdGhlciBmb3Igc28gbG9uZwpZb3VyIGhlYXJ0J3MgYmVlbiBhY2hpbmcsIGJ1dCB5b3UncmUgdG9vIHNoeSB0byBzYXkgaXQKSW5zaWRlLCB3ZSBib3RoIGtub3cgd2hhdCdzIGJlZW4gZ29pbmcgb24KV2Uga25vdyB0aGUgZ2FtZSwgYW5kIHdlJ3JlIGdvbm5hIHBsYXkgaXQKCltQcmUtQ2hvcnVzXQpBbmQgaWYgeW91IGFzayBtZSBob3cgSSdtIGZlZWxpbmcKRG9uJ3QgdGVsbCBtZSB5b3UncmUgdG9vIGJsaW5kIHRvIHNlZQoKW0Nob3J1c10KTmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXAKTmV2ZXIgZ29ubmEgbGV0IHlvdSBkb3duCk5ldmVyIGdvbm5hIHJ1biBhcm91bmQgYW5kIGRlc2VydCB5b3UKTmV2ZXIgZ29ubmEgbWFrZSB5b3UgY3J5Ck5ldmVyIGdvbm5hIHNheSBnb29kYnllCk5ldmVyIGdvbm5hIHRlbGwgYSBsaWUgYW5kIGh1cnQgeW91Ck5ldmVyIGdvbm5hIGdpdmUgeW91IHVwCk5ldmVyIGdvbm5hIGxldCB5b3UgZG93bgpOZXZlciBnb25uYSBydW4gYXJvdW5kIGFuZCBkZXNlcnQgeW91Ck5ldmVyIGdvbm5hIG1ha2UgeW91IGNyeQpOZXZlciBnb25uYSBzYXkgZ29vZGJ5ZQpOZXZlciBnb25uYSB0ZWxsIGEgbGllIGFuZCBodXJ0IHlvdQoKW1Bvc3QtQ2hvcnVzXQpPb2ggKEdpdmUgeW91IHVwKQpPb2gtb29oIChHaXZlIHlvdSB1cCkKT29oLW9vaApOZXZlciBnb25uYSBnaXZlLCBuZXZlciBnb25uYSBnaXZlIChHaXZlIHlvdSB1cCkKT29oLW9vaApOZXZlciBnb25uYSBnaXZlLCBuZXZlciBnb25uYSBnaXZlIChHaXZlIHlvdSB1cCkKCltCcmlkZ2VdCldlJ3ZlIGtub3duIGVhY2ggb3RoZXIgZm9yIHNvIGxvbmcKWW91ciBoZWFydCdzIGJlZW4gYWNoaW5nLCBidXQgeW91J3JlIHRvbyBzaHkgdG8gc2F5IGl0Ckluc2lkZSwgd2UgYm90aCBrbm93IHdoYXQncyBiZWVuIGdvaW5nIG9uCldlIGtub3cgdGhlIGdhbWUsIGFuZCB3ZSdyZSBnb25uYSBwbGF5IGl0CgpbUHJlLUNob3J1c10KSSBqdXN0IHdhbm5hIHRlbGwgeW91IGhvdyBJJ20gZmVlbGluZwpHb3R0YSBtYWtlIHlvdSB1bmRlcnN0YW5kCgpbQ2hvcnVzXQpOZXZlciBnb25uYSBnaXZlIHlvdSB1cApOZXZlciBnb25uYSBsZXQgeW91IGRvd24KTmV2ZXIgZ29ubmEgcnVuIGFyb3VuZCBhbmQgZGVzZXJ0IHlvdQpOZXZlciBnb25uYSBtYWtlIHlvdSBjcnkKTmV2ZXIgZ29ubmEgc2F5IGdvb2RieWUKTmV2ZXIgZ29ubmEgdGVsbCBhIGxpZSBhbmQgaHVydCB5b3UKTmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXAKTmV2ZXIgZ29ubmEgbGV0IHlvdSBkb3duCk5ldmVyIGdvbm5hIHJ1biBhcm91bmQgYW5kIGRlc2VydCB5b3UKTmV2ZXIgZ29ubmEgbWFrZSB5b3UgY3J5Ck5ldmVyIGdvbm5hIHNheSBnb29kYnllCk5ldmVyIGdvbm5hIHRlbGwgYSBsaWUgYW5kIGh1cnQgeW91Ck5ldmVyIGdvbm5hIGdpdmUgeW91IHVwCk5ldmVyIGdvbm5hIGxldCB5b3UgZG93bgpOZXZlciBnb25uYSBydW4gYXJvdW5kIGFuZCBkZXNlcnQgeW91Ck5ldmVyIGdvbm5hIG1ha2UgeW91IGNyeQpOZXZlciBnb25uYSBzYXkgZ29vZGJ5ZQpOZXZlciBnb25uYSB0ZWxsIGEgbGllIGFuZCBodXJ0IHlvdQ==\n");

PlayState.deathCounter = 0;
PlayState.seenCutscene = false;
WeekData.loadTheFirstEnabledMod();

TitleState.initialized = false;
TitleState.closedState = false;
FlxG.stage.removeChild(fpsVar);
Main.fpsVar.visible = ClientPrefs.showFPS;
FlxG.switchState(new TitleState());

PlayState.cancelMusicFadeTween();
FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
PlayState.changedDifficulty = false;
PlayState.chartingMode = false;
]])
end