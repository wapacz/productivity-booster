on run {input, parameters}
    tell application "System Events"
        -- 1. Trigger native Spotlight (⌘ + Space)
        keystroke space using {command down}
        delay 0.3
        
        -- 2. Switch directly to Clipboard History panel (⌘ + 4 using hardware key code 21)
        key code 21 using {command down}
        
        -- Safety flag: Ensure we only paste if the user explicitly commits a choice
        set shouldPaste to false
        
        -- 3. Actively monitor the lifecycle and focus state of the Spotlight interface
        repeat while (exists (window 1 of application process "Spotlight"))
            -- Fetch the current frontmost application process name
            set frontProcess to name of first application process whose frontmost is true
            
            -- Safeguard: If the user clicks away or switches context, immediately abort
            if frontProcess is not "Spotlight" then
                set shouldPaste to false
                exit repeat
            end if
            
            -- Assume valid session state while Spotlight retains exclusive focus
            set shouldPaste to true
            delay 0.05
        end repeat
        
        -- 4. Post-execution execution loop
        delay 0.1
        if (not (exists (window 1 of application process "Spotlight"))) and shouldPaste is true then
            -- Context successfully committed via Return/Enter. Fire final paste sequence (⌘ + V).
            keystroke "v" using {command down}
        end if
    end tell
    return input
end run
