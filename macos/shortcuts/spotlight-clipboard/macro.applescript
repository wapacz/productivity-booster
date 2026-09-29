use framework "AppKit"
use scripting additions

on run {input, parameters}
    set clipboardChangeCountBeforeOpen to currentClipboardChangeCount()

    tell application "System Events"
        keystroke space using {command down}
        delay 0.3

        -- Hardware key code for "4": keystroke "4" depends on the keyboard layout and can be dropped during focus transitions
        key code 21 using {command down}

        repeat while (exists (window 1 of application process "Spotlight"))
            delay 0.05
        end repeat
    end tell

    -- Return copies the chosen entry and bumps the change count; Escape or click-away leaves it untouched, so neither triggers a paste
    if currentClipboardChangeCount() is clipboardChangeCountBeforeOpen then return input

    -- Gives focus time to return to the previous app before pasting into it
    delay 0.1
    tell application "System Events" to keystroke "v" using {command down}
    return input
end run

on currentClipboardChangeCount()
    return (current application's NSPasteboard's generalPasteboard()'s changeCount()) as integer
end currentClipboardChangeCount
