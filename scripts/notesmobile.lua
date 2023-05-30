-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: T H I C K notes like mobile hitboxes
-- How to use:
--   1. Put this script in mods/scripts

function onCreatePost()
	--setPropertyFromGroup('playerStrums', 3, 'width', getPropertyFromGroup('playerStrums', 3, 'width') * 1.5)
	--updateHitboxFromGroup('playerStrums', 3)

	runHaxeCode([[
		for (note in game.opponentStrums)
			note.visible = false;

		for (note in game.unspawnNotes)
		{
			note.scale.x *= 2.5;
			note.updateHitbox();
			if (!note.mustPress)
				note.visible = false;
		}
		for (note in game.notes)
		{
			note.scale.x *= 2.5;
			note.updateHitbox();
			if (!note.mustPress)
				note.visible = false;
		}

		for (note in game.playerStrums)
		{
			note.scale.x *= 2.5;
			note.updateHitbox();
		}
	]])
	runHaxeCode("game.playerStrums.members[0].x = 50;")
	runHaxeCode("game.playerStrums.members[1].x = 350;")
	runHaxeCode("game.playerStrums.members[2].x = 650;")
	runHaxeCode("game.playerStrums.members[3].x = 950;")
end