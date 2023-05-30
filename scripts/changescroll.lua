-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER
-- Description: functions for change scroll of notes
-- Author: TheLeerName

function onCreatePost()
	-- moving notes for properly reading it by player lol
	for i = 0, getProperty('playerStrums.length') - 1 do
		setPropertyFromGroup('playerStrums', i, 'y', 300)
	end
	for i = 0, getProperty('opponentStrums.length') - 1 do
		setPropertyFromGroup('opponentStrums', i, 'y', 300)
	end
	setProperty('spawnTime', 400)
	--changeStrumScroll(2, 3, true)
	--changeNoteScroll({0}, false)
	for note = 0, getProperty('unspawnNotes.length') - 1 do
		thegreatrandom = math.floor(math.random(0, 1))
		if thegreatrandom == 1 and not getPropertyFromGroup('unspawnNotes', note, 'isSustainNote') then
			changeNotesScroll({getPropertyFromGroup('unspawnNotes', note, 'strumTime')}, true)
		end
	end
end

local ST_list = {}
local MP_list = {}
local ND_list = {}
local DS_list = {}

-- changes scroll on ALL CERTAIN STRUM notes
-- player: int, 2 = bf, 1 == opponent
-- index: int, noteData of strum
-- downScroll: boolean
-- example: changes a scroll of bf to down on right note - changeStrumScroll(2, 3, true)
function changeStrumScroll(player, index, downScroll)
	if player == 2 then
		setPropertyFromGroup('opponentStrums', index, 'downScroll', downScroll)
		-- fixing hold notes
		runHaxeCode([[
			for (note in game.unspawnNotes)
				if (note.isSustainNote && note.prevNote != null && note.mustPress && note.noteData == ]]..tostring(index)..[[)
					note.flipY = ]]..tostring(downScroll)..[[;
			for (note in game.notes)
				if (note.isSustainNote && note.prevNote != null && note.mustPress && note.noteData == ]]..tostring(index)..[[)
					note.flipY = ]]..tostring(downScroll)..[[;
		]])
	else
		setPropertyFromGroup('playerStrums', index, 'downScroll', downScroll)
		-- fixing hold notes
		runHaxeCode([[
			for (note in game.unspawnNotes)
				if (note.isSustainNote && note.prevNote != null && !note.mustPress && note.noteData == ]]..tostring(index)..[[)
					note.flipY = ]]..tostring(downScroll)..[[;
			for (note in game.notes)
				if (note.isSustainNote && note.prevNote != null && !note.mustPress && note.noteData == ]]..tostring(index)..[[)
					note.flipY = ]]..tostring(downScroll)..[[;
		]])
	end
end

-- changes scroll of CERTAIN notes
-- strumTime: {} array with strumtime float (in decimals, right how in json file)
-- downScroll: boolean
-- example: changes a scroll of note to down on strumtime 0 - changeStrumScroll({0}, true)
function changeNotesScroll(strumTime, downScroll)
	for i = 1, #strumTime do
		-- adding to 
		for note = 0, getProperty('notes.length') - 1 do
			if strumTime[i] == getPropertyFromGroup('notes', note, 'strumTime') then
				for notetail = 0, getPropertyFromGroup('notes', note, 'tail.length') - 1 do
					for note1 = 0, getProperty('notes.length') - 1 do
						local mustPress = false
						if getStaticProperty("game.notes.members["..tostring(note).."].tail["..tostring(notetail).."].mustPress") == 'true' then
							mustPress = true
						end
						if mustPress == getPropertyFromGroup('notes', note1, 'mustPress') and tonumber(getStaticProperty("game.notes.members["..tostring(note).."].tail["..tostring(notetail).."].noteData")) == getPropertyFromGroup('notes', note1, 'noteData') and round(tonumber(getStaticProperty("game.notes.members["..tostring(note).."].tail["..tostring(notetail).."].strumTime")), 9) == round(getPropertyFromGroup('notes', note1, 'strumTime'), 9) then
							table.insert(ST_list, getPropertyFromGroup('notes', note1, 'strumTime'))
							table.insert(MP_list, getPropertyFromGroup('notes', note1, 'mustPress'))
							table.insert(ND_list, getPropertyFromGroup('notes', note1, 'noteData'))
							table.insert(DS_list, downScroll)
							setPropertyFromGroup('notes', note1, 'flipY', downScroll)
						end
					end
				end
				table.insert(ST_list, getPropertyFromGroup('notes', note, 'strumTime'))
				table.insert(MP_list, getPropertyFromGroup('notes', note, 'mustPress'))
				table.insert(ND_list, getPropertyFromGroup('notes', note, 'noteData'))
				table.insert(DS_list, downScroll)
			end
		end
		for note = 0, getProperty('unspawnNotes.length') - 1 do
			if strumTime[i] == getPropertyFromGroup('unspawnNotes', note, 'strumTime') then
				for notetail = 0, getPropertyFromGroup('unspawnNotes', note, 'tail.length') - 1 do
					for note1 = 0, getProperty('unspawnNotes.length') - 1 do
						local mustPress = false
						if getStaticProperty("game.unspawnNotes["..tostring(note).."].tail["..tostring(notetail).."].mustPress") == 'true' then
							mustPress = true
						end
						if mustPress == getPropertyFromGroup('unspawnNotes', note1, 'mustPress') and tonumber(getStaticProperty("game.unspawnNotes["..tostring(note).."].tail["..tostring(notetail).."].noteData")) == getPropertyFromGroup('unspawnNotes', note1, 'noteData') and round(tonumber(getStaticProperty("game.unspawnNotes["..tostring(note).."].tail["..tostring(notetail).."].strumTime")), 9) == round(getPropertyFromGroup('unspawnNotes', note1, 'strumTime'), 9) then
							table.insert(ST_list, getPropertyFromGroup('unspawnNotes', note1, 'strumTime'))
							table.insert(MP_list, getPropertyFromGroup('unspawnNotes', note1, 'mustPress'))
							table.insert(ND_list, getPropertyFromGroup('unspawnNotes', note1, 'noteData'))
							table.insert(DS_list, downScroll)
							setPropertyFromGroup('unspawnNotes', note1, 'flipY', downScroll)
						end
					end
				end
				table.insert(ST_list, getPropertyFromGroup('unspawnNotes', note, 'strumTime'))
				table.insert(MP_list, getPropertyFromGroup('unspawnNotes', note, 'mustPress'))
				table.insert(ND_list, getPropertyFromGroup('unspawnNotes', note, 'noteData'))
				table.insert(DS_list, downScroll)
			end
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

function onUpdatePost()
	if not getProperty('inCutscene') and startedCountdown then
		for note = 0, getProperty('notes.length') - 1 do
			for i = 1, #ST_list do
				if ND_list[i] == getPropertyFromGroup('notes', note, 'noteData') and MP_list[i] == getPropertyFromGroup('notes', note, 'mustPress') and ST_list[i] == getPropertyFromGroup('notes', note, 'strumTime') then
					positionShit(note, DS_list[i])
				end
			end
		end
	end
end

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function positionShit(note, strumScroll)
	addHaxeLibrary('Math')
	addHaxeLibrary('Note')

	local distance = (getPropertyFromClass('Conductor', 'songPosition') - getPropertyFromGroup('notes', note, 'strumTime')) * getProperty('songSpeed') * getPropertyFromGroup('notes', note, 'multSpeed')
	if strumScroll then
		distance = distance * 0.45
	else
		distance = distance * -0.45
	end
	setPropertyFromGroup('notes', note, 'distance', distance)

	local noteData = getPropertyFromGroup('notes', note, 'noteData')
	local strumX = 0
	local strumY = 0
	local strumDirection = 0
	if getPropertyFromGroup('notes', note, 'mustPress') then
		strumX = getPropertyFromGroup('playerStrums', noteData, 'x')
		strumY = getPropertyFromGroup('playerStrums', noteData, 'y')
		strumDirection = getPropertyFromGroup('playerStrums', noteData, 'direction')
	else
		strumX = getPropertyFromGroup('opponentStrums', noteData, 'x')
		strumY = getPropertyFromGroup('opponentStrums', noteData, 'y')
		strumDirection = getPropertyFromGroup('opponentStrums', noteData, 'direction')
	end
	strumX = strumX + getPropertyFromGroup('notes', note, 'offsetX')
	strumY = strumY + getPropertyFromGroup('notes', note, 'offsetY')

	if getPropertyFromGroup('notes', note, 'copyX') then
		setPropertyFromGroup('notes', note, 'x', strumX + tonumber(getStaticProperty("Math.cos("..tostring(strumDirection).." * Math.PI / 180)")) * distance)
	end
	if getPropertyFromGroup('notes', note, 'copyY') then
		setPropertyFromGroup('notes', note, 'y', strumY + tonumber(getStaticProperty("Math.sin("..tostring(strumDirection).." * Math.PI / 180)")) * distance)

		if strumScroll and getPropertyFromGroup('notes', note, 'isSustainNote') then
			local setNoteY = getPropertyFromGroup('notes', note, 'y')
			if stringEndsWith(getPropertyFromGroup('notes', note, 'animation.curAnim.name'), 'end') then
				local fakeCrochet = (60 / tonumber(getStaticProperty('PlayState.SONG.bpm'))) * 1000
				setNoteY = setNoteY + (10.5 * (fakeCrochet / 400) * 1.5 * getProperty('songSpeed') + (46 * (getProperty('songSpeed') - 1)))
				setNoteY = setNoteY - (46 * (1 - (fakeCrochet / 600)) * getProperty('songSpeed'))
				if getStaticProperty('PlayState.isPixelStage') == 'true' then
					setNoteY = setNoteY + (8 + (6 - getPropertyFromGroup('notes', note, 'originalHeightForCalcs')) * tonumber(getStaticProperty('PlayState.daPixelZoom')))
				else
					setNoteY = setNoteY - 19
				end
			end
			setNoteY = setNoteY + ((tonumber(getStaticProperty('Note.swagWidth')) / 2) - (60.5 * (getProperty('songSpeed') - 1)))
			setNoteY = setNoteY + (27.5 * ((tonumber(getStaticProperty('PlayState.SONG.bpm')) / 100) - 1) * (getProperty('songSpeed') - 1))

			setPropertyFromGroup('notes', note, 'y', setNoteY)
		end
	end
end