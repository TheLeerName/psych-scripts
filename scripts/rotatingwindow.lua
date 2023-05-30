-- WARNING: USES PSYCH ENGINE 0.6.3 AND LATER

-- Author: TheLeerName
-- Description: a rotating window!
-- How to use:
--   1. Put this script in mods/scripts

-- idk change smth im lazy to do config

function onCreatePost()
	luaDebugMode = true
	print(getPropertyFromClass("openfl.Lib", "application.window.display.bounds.width"), getPropertyFromClass("openfl.Lib", "application.window.display.bounds.height"))
	setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
	setPropertyFromClass("Main", "fpsVar.visible", false)
	defaultBounds = {x = getPropertyFromClass("openfl.Lib", "application.window.x"), y = getPropertyFromClass("openfl.Lib", "application.window.y"), width = getPropertyFromClass("openfl.Lib", "application.window.width"), height = getPropertyFromClass("openfl.Lib", "application.window.height")}
	setPropertyFromClass("openfl.Lib", "application.window.x", 0)
	setPropertyFromClass("openfl.Lib", "application.window.y", 0)
	setPropertyFromClass("openfl.Lib", "application.window.width", getPropertyFromClass("openfl.Lib", "application.window.display.bounds.width") + 1)
	setPropertyFromClass("openfl.Lib", "application.window.height", getPropertyFromClass("openfl.Lib", "application.window.display.bounds.height") + 1)
	setPropertyFromClass("flixel.FlxG", "game.scaleX", 0.5)
	setPropertyFromClass("flixel.FlxG", "game.scaleY", 0.5)
	setPropertyFromClass("flixel.FlxG", "stage.color", 0x00ff00)
	setWindowColor(0x0000ff00)
end

function onUpdate(elapsed)
	--print(getProperty("camGame.width"))
	setPropertyFromClass("flixel.FlxG", "game.x", getPropertyFromClass("openfl.Lib", "application.window.display.bounds.width") * getPropertyFromClass("flixel.FlxG", "game.scaleX") / 2)
	setPropertyFromClass("flixel.FlxG", "game.y", getPropertyFromClass("openfl.Lib", "application.window.display.bounds.height") * getPropertyFromClass("flixel.FlxG", "game.scaleY") / 2)
	setProperty("camGame.angle", getProperty("camGame.angle") + 1)
	setProperty("camHUD.angle", getProperty("camHUD.angle") + 1)
	setProperty("camOther.angle", getProperty("camOther.angle") + 1)
end

function onDestroy()
	--setPropertyFromClass("flixel.FlxG", "fullscreen", false)
	setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
	setPropertyFromClass("Main", "fpsVar.visible", getPropertyFromClass("ClientPrefs", "showFPS"))
	setPropertyFromClass("openfl.Lib", "application.window.x", defaultBounds.x)
	setPropertyFromClass("openfl.Lib", "application.window.y", defaultBounds.y)
	setPropertyFromClass("openfl.Lib", "application.window.width", defaultBounds.width)
	setPropertyFromClass("openfl.Lib", "application.window.height", defaultBounds.height)
	setPropertyFromClass("flixel.FlxG", "game.scaleX", 1)
	setPropertyFromClass("flixel.FlxG", "game.scaleY", 1)
	setPropertyFromClass("flixel.FlxG", "game.x", 0)
	setPropertyFromClass("flixel.FlxG", "game.y", 0)
	setPropertyFromClass("flixel.FlxG", "stage.color", 0x000000)

	setWindowAlpha(255)
end

ffi = require "ffi"

ffi.cdef [[
    typedef int BOOL;
    typedef int BYTE;
    typedef int LONG;
    typedef LONG DWORD;
    typedef DWORD COLORREF;
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    typedef int bInvert;
        
        HWND GetActiveWindow(void);
        
        LONG SetWindowLongA(HWND hWnd, int nIndex, LONG dwNewLong);
        
    HWND SetLayeredWindowAttributes(HWND hwnd, COLORREF crKey, BYTE bAlpha, DWORD dwFlags);
        
        DWORD GetLastError();
]]
--function onCreate()
    --setTransparency(COLOR_HERE) --info about colors in C https://learn.microsoft.com/en-us/windows/win32/gdi/colorref
--end
function setWindowColor(color)
	color = color or 0
    local hwnd = ffi.C.GetActiveWindow()
    
    if ffi.C.SetWindowLongA(hwnd, -20, 0x00080000) ~= 0 then
		ffi.C.SetLayeredWindowAttributes(hwnd, color, 0, 0x00000001)
    end
end
function setWindowAlpha(alpha)
    local hwnd = ffi.C.GetActiveWindow()
    
    if ffi.C.SetWindowLongA(hwnd, -20, 0x00080000) ~= 0 then
		ffi.C.SetLayeredWindowAttributes(hwnd, 0, alpha, 0x00000002)
    end
end
-- btw thing above from mayo set window transparency script