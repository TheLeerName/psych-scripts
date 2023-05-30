-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: just a code for properly getting scroll/num/caps lock keys
-- How to use:
--   1. Put these functions in your script <3

ffi = require "ffi"
ffi.cdef [[ int GetKeyState(int key); ]]
-- https://learn.microsoft.com/ru-ru/windows/win32/inputdev/virtual-key-codes
function getScrollLockPressed() return bit.band(ffi.C.GetKeyState(0x91), 0x0001) ~= 0 end
function getNumLockPressed() return bit.band(ffi.C.GetKeyState(0x90), 0x0001) ~= 0 end
function getCapsLockPressed() return bit.band(ffi.C.GetKeyState(0x14), 0x0001) ~= 0 end

function onUpdate(elapsed)
	if getCapsLockPressed() then
		-- code
	end
end