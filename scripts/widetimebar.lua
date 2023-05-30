-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: just wide time bar
-- How to use:
--   1. Put this script in mods/scripts
--   2. Now you have wide time bar <3

function onSongStart()
	setProperty('timeBar.x', 50)
	setGraphicSize('timeBar', 1170, getProperty('timeBar.height'))
end