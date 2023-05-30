-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: just a check for double/triple/quadriple notes pressed
-- How to use:
--   1. Put this function in your script <3

function goodNoteHit(id, data, type, sus)
	if gdh_lastStrumTime == getPropertyFromGroup("notes", id, "strumTime") then
		gdh_pressedNotes = gdh_pressedNotes + 1
		if gdh_pressedNotes == 2 then
			print('double note lolololol!!!!!')
		elseif gdh_pressedNotes == 3 then 
			print('triple note lolololol!!!!!')
		elseif gdh_pressedNotes == 4 then
			gdh_lastStrumTime = -72138973
			print('quadriple note lolololol!!!!!')
		end
	else
		gdh_lastStrumTime = getPropertyFromGroup("notes", id, "strumTime")
		gdh_pressedNotes = 1
	end
end