-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: idk its like in some rhythm games
-- How to use:
--   1. Put this script in mods/scripts

function onCreatePost()
	luaDebugMode = true
	addHaxeLibrary('Math')
	addHaxeLibrary('Std')
	addHaxeLibrary('Note')
	addHaxeLibrary('FunkinLua')
	runHaxeCode([[
		//for (note in PlayState.instance.unspawnNotes)
			//if (note.noteData == 3)
			//{
				//note.copyX = false;
				//note.copyY = false;
				//note.offsetX = -200;
			//}
		//PlayState.instance.playerStrums.members[0].direction = 45;
	]])
end

function onCountdownStarted()
	-- 8, 2.8, -2.8, -8
	-- 20, 7, -7, -20
		for i = 0, 1 do
			setAngleStrum(i, 0, 20)
			setAngleStrum(i, 1, 7)
			setAngleStrum(i, 2, -7)
			setAngleStrum(i, 3, -20)
		end
		setPropertyFromGroup('playerStrums', 0, 'y', getPropertyFromGroup('playerStrums', 0, 'y') - 50);
		setPropertyFromGroup('playerStrums', 0, 'x', getPropertyFromGroup('playerStrums', 0, 'x') - 50);

		setPropertyFromGroup('playerStrums', 1, 'x', getPropertyFromGroup('playerStrums', 1, 'x') - 25);
		setPropertyFromGroup('playerStrums', 2, 'x', getPropertyFromGroup('playerStrums', 2, 'x') + 25);

		setPropertyFromGroup('playerStrums', 3, 'y', getPropertyFromGroup('playerStrums', 3, 'y') - 50);
		setPropertyFromGroup('playerStrums', 3, 'x', getPropertyFromGroup('playerStrums', 3, 'x') + 50);


		setPropertyFromGroup('opponentStrums', 0, 'y', getPropertyFromGroup('opponentStrums', 0, 'y') - 50);
		setPropertyFromGroup('opponentStrums', 0, 'x', getPropertyFromGroup('opponentStrums', 0, 'x') - 50);

		setPropertyFromGroup('opponentStrums', 1, 'x', getPropertyFromGroup('opponentStrums', 1, 'x') - 25);
		setPropertyFromGroup('opponentStrums', 2, 'x', getPropertyFromGroup('opponentStrums', 2, 'x') + 25);

		setPropertyFromGroup('opponentStrums', 3, 'y', getPropertyFromGroup('opponentStrums', 3, 'y') - 50);
		setPropertyFromGroup('opponentStrums', 3, 'x', getPropertyFromGroup('opponentStrums', 3, 'x') + 50);
end

function setAngleStrum(player, index, angle)
	local hei = {'note.mustPress && ', ''}
	local hei2 = {'player', 'opponent'}
	runHaxeCode([[
		var ind = ]]..index..[[;
		var ang = ]]..angle..[[;
		PlayState.instance.]]..hei2[player + 1]..[[Strums.members[ind].direction = ang + 90;
		var nl = [8, 29, 42, 54];
		nl = [100, 45, [18, -39], [18, -39], [18, -39], [18, -39] ];
		for (note in PlayState.instance.unspawnNotes)
			if (]]..hei[player + 1]..[[note.noteData == ind)
			{
				for (tailnote in note.tail)
				{
					tailnote.angle = ang;
					//tailnote.offsetX = nl[0];
					//tailnote.offsetY = nl[1];
				}
				if (note.tail.length > 0)
				{
					//note.tail[note.tail.length - 1].offsetX -= note.tail[note.tail.length - 1].width / 2;
				}
				/*if (note.tail.length > 0)
				{
					note.tail[note.tail.length - 1].offsetX = nl[note.tail[note.tail.length - 1].noteData + 2][0];
					note.tail[note.tail.length - 1].offsetY = nl[note.tail[note.tail.length - 1].noteData + 2][1];
				}*/
			}
		for (note in PlayState.instance.notes)
			if (]]..hei[player + 1]..[[note.noteData == ind)
			{
				for (tailnote in note.tail)
				{
					tailnote.angle = ang;
					//tailnote.offsetX = nl[0];
					//tailnote.offsetY = nl[1];
				}
				if (note.tail.length > 0)
				{
					//note.tail[note.tail.length - 1].offsetX -= note.tail[note.tail.length - 1].width / 2;
				}
				/*if (note.tail.length > 0)
				{
					note.tail[note.tail.length - 1].offsetX = nl[note.tail[note.tail.length - 1].noteData + 2][0];
					note.tail[note.tail.length - 1].offsetY = nl[note.tail[note.tail.length - 1].noteData + 2][1];
				}*/
			}

		trace('ok i pull up ]]..player..[[, ' + ind + ', ' + ang);
	]])
end