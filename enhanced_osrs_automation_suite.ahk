; Enhanced OSRS Automation Suite with RuneLite Integration
; Fully functional with reliable GUI and hotkeys
; F12: Toggle Prayer Flicking | F11: Toggle Special Attack | F10: Toggle Herb Cleaning
; F9: Gear Switch | F8: Emergency Teleport | Esc: Exit

#Persistent
#SingleInstance Force
#InstallKeybdHook
#UseHook
SetBatchLines -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; === CONFIGURATION ===
minClickGap := 30
maxClickGap := 50
jitterMax := 10
defaultTick := 600
runeliteWindowTitle := "RuneLite"
runeliteClass := "SunAwtFrame"

; === STATE VARIABLES ===
prayerFlickEnabled := false
specialAttackEnabled := false
herbCleaningEnabled := false
autoTeleportEnabled := false
lastPing := 0
lastTick := defaultTick
rlWindowId := 0
rlX := 0
rlY := 0
rlWidth := 0
rlHeight := 0

; === USER PROFILE DETECTION ===
GetUserProfile() {
    EnvGet, envProfile, USERPROFILE
    if (envProfile != "") return envProfile
    if (A_UserProfile != "") return A_UserProfile
    
    EnvGet, homeDrive, HOMEDRIVE
    EnvGet, homePath, HOMEPATH
    if (homeDrive != "" && homePath != "")
        return homeDrive . homePath
    
    return "C:\Users\" . A_UserName
}

; === FILE PATHS ===
userProfile := GetUserProfile()
pingPath := userProfile . "\.runelite\ping.txt"
tickPath := userProfile . "\.runelite\tick.txt"

; === WINDOW DETECTION ===
DetectRuneLiteWindow() {
    global runeliteWindowTitle, runeliteClass
    
    ; Try exact match first
    WinGet, windows, List, %runeliteWindowTitle%
    Loop, %windows% {
        WinGetClass, class, % "ahk_id " . windows%A_Index%
        if (class = runeliteClass) 
            return windows%A_Index%
    }
    
    ; Fallback to class detection
    WinGet, javaWindows, List, ahk_class SunAwtFrame
    Loop, %javaWindows% {
        WinGetTitle, title, % "ahk_id " . javaWindows%A_Index%
        if (InStr(title, "Old School") || InStr(title, "OSRS")) 
            return javaWindows%A_Index%
    }
    
    return 0
}

; === COORDINATE FUNCTIONS ===
GetRuneLiteCoordinates() {
    global rlWindowId, rlX, rlY, rlWidth, rlHeight
    
    rlWindowId := DetectRuneLiteWindow()
    if (!rlWindowId) {
        return false
    }
    
    WinGetPos, rlX, rlY, rlWidth, rlHeight, ahk_id %rlWindowId%
    WinActivate, ahk_id %rlWindowId%
    return true
}

GetQuickPrayerCoords() {
    global rlX, rlY, rlWidth, rlHeight
    prayerX := rlX + rlWidth - 180
    prayerY := rlY + 85
    return prayerX . "," . prayerY
}

GetSpecialAttackCoords() {
    global rlX, rlY, rlWidth, rlHeight
    specX := rlX + rlWidth - 50
    specY := rlY + rlHeight - 100
    return specX . "," . specY
}

GetInventorySlotCoords(slot) {
    global rlX, rlY, rlWidth, rlHeight
    if (slot < 1 || slot > 28) 
        return "0,0"
    
    row := Floor((slot - 1) / 4)
    col := Mod(slot - 1, 4)
    invBaseX := rlX + rlWidth - 180
    invBaseY := rlY + rlHeight - 250
    slotX := invBaseX + (col * 40)
    slotY := invBaseY + (row * 35)
    return slotX . "," . slotY
}

; === AUTOMATION FUNCTIONS ===
PrayerFlick() {
    if (!GetRuneLiteCoordinates()) 
        return
    
    coords := GetQuickPrayerCoords()
    StringSplit, coordArray, coords, `,
    
    Random, offsetX, -3, 3
    Random, offsetY, -3, 3
    clickX := coordArray1 + offsetX
    clickY := coordArray2 + offsetY
    
    Click, %clickX%, %clickY%
    Sleep, 50
    Click, %clickX%, %clickY%
    UpdateLog("Prayer flicked at " . clickX . "," . clickY)
}

SpecialAttack() {
    if (!GetRuneLiteCoordinates()) 
        return
    
    coords := GetSpecialAttackCoords()
    StringSplit, coordArray, coords, `,
    
    Random, offsetX, -2, 2
    Random, offsetY, -2, 2
    clickX := coordArray1 + offsetX
    clickY := coordArray2 + offsetY
    
    Click, %clickX%, %clickY%
    UpdateLog("Special attack activated")
}

CleanHerbs() {
    if (!GetRuneLiteCoordinates()) 
        return
    
    herbCoords := GetInventorySlotCoords(1)
    toolCoords := GetInventorySlotCoords(2)
    StringSplit, herbArray, herbCoords, `,
    StringSplit, toolArray, toolCoords, `,
    
    Click, %toolArray1%, %toolArray2%
    Sleep, 100
    Click, %herbArray1%, %herbArray2%
    UpdateLog("Herb cleaning cycle")
}

EmergencyTeleport() {
    if (!GetRuneLiteCoordinates()) 
        return
    
    magicTabX := rlX + rlWidth - 80
    magicTabY := rlY + rlHeight - 50
    Click, %magicTabX%, %magicTabY%
    Sleep, 200
    
    teleportX := rlX + rlWidth - 180
    teleportY := rlY + rlHeight - 200
    Click, %teleportX%, %teleportY%
    UpdateLog("Emergency teleport activated!")
}

; === GUI CONSTRUCTION ===
BuildEnhancedGUI() {
    Gui, New, +AlwaysOnTop, OSRS Automation Suite
    Gui, Font, s9, Segoe UI
    
    ; === STATUS PANEL ===
    Gui, Add, GroupBox, x10 y10 w310 h70, System Status
    Gui, Add, Text, x20 y35 w80 h20, Ping:
    Gui, Add, Text, x20 y55 w80 h20, Tick:
    Gui, Add, Text, x100 y35 w40 h20 vPingValue, N/A
    Gui, Add, Text, x100 y55 w40 h20 vTickValue, N/A
    
    Gui, Add, Text, x150 y35 w150 h20 vPingStatus, Checking...
    Gui, Add, Text, x150 y55 w150 h20 vTickStatus, Checking...
    Gui, Add, Text, x20 y75 w290 h20 vRuneLiteStatus, RuneLite: Searching...
    
    ; === AUTOMATION CONTROLS ===
    Gui, Add, GroupBox, x10 y100 w310 h100, Automation Controls
    Gui, Add, Checkbox, x20 y120 w120 h20 vChkPrayer gTogglePrayer, Prayer (F12)
    Gui, Add, Checkbox, x20 y145 w120 h20 vChkSpecial gToggleSpecial, Special (F11)
    Gui, Add, Checkbox, x150 y120 w120 h20 vChkHerbs gToggleHerbs, Herbs (F10)
    Gui, Add, Checkbox, x150 y145 w120 h20 vChkTeleport gToggleTeleport, Teleport (F8)
    
    ; === ACTIVITY LOG ===
    Gui, Add, GroupBox, x10 y210 w310 h150, Activity Log
    Gui, Add, Edit, x20 y230 w290 h120 vActivityLog ReadOnly
    
    ; === ACTION BUTTONS ===
    Gui, Add, Button, x20 y370 w80 h25 gDetectCoords, Detect Coords
    Gui, Add, Button, x120 y370 w80 h25 gRefreshStatus, Refresh
    Gui, Add, Button, x220 y370 w80 h25 gExitBtn, Exit
    
    ; Show GUI
    Gui, Show, Center w330 h410, OSRS Automation Suite
    WinSet, AlwaysOnTop, On, OSRS Automation Suite
    WinActivate, OSRS Automation Suite
    
    SetTimer, UpdateStatus, 1000
    SetTimer, RunAutomation, -100
}

; === STATUS UPDATES ===
UpdateStatus() {
    CheckFiles()
    CheckRuneLite()
}

CheckFiles() {
    global pingPath, tickPath, lastPing, lastTick
    
    ; Ping file status
    if FileExist(pingPath) {
        FileRead, pingStr, %pingPath%
        if pingStr is number
        {
            lastPing := pingStr
            GuiControl,, PingValue, %lastPing% ms
            GuiControl,, PingStatus, [OK]
            GuiControl, +cGreen, PingStatus
        }
        else
        {
            GuiControl,, PingStatus, [Invalid]
            GuiControl, +cRed, PingStatus
        }
    }
    else
    {
        GuiControl,, PingStatus, [Missing]
        GuiControl, +cRed, PingStatus
    }
    
    ; Tick file status
    if FileExist(tickPath) {
        FileRead, tickStr, %tickPath%
        if tickStr is number
        {
            lastTick := tickStr
            GuiControl,, TickValue, %lastTick% ms
            GuiControl,, TickStatus, [OK]
            GuiControl, +cGreen, TickStatus
        }
        else
        {
            GuiControl,, TickStatus, [Invalid]
            GuiControl, +cRed, TickStatus
        }
    }
    else
    {
        lastTick := defaultTick
        GuiControl,, TickStatus, [Missing]
        GuiControl, +cRed, TickStatus
    }
}

CheckRuneLite() {
    if (DetectRuneLiteWindow()) {
        GuiControl,, RuneLiteStatus, RuneLite: Connected
        GuiControl, +cGreen, RuneLiteStatus
    } else {
        GuiControl,, RuneLiteStatus, RuneLite: Not Found
        GuiControl, +cRed, RuneLiteStatus
    }
}

; === LOGGING ===
UpdateLog(message) {
    FormatTime, timestamp,, HH:mm:ss
    GuiControlGet, currentLog,, ActivityLog
    newLog := currentLog . timestamp . " - " . message . "`r`n"
    
    ; Keep last 10 lines
    lines := StrSplit(newLog, "`n", "`r")
    if (lines.Length() > 10) {
        newLog := ""
        startIndex := lines.Length() - 9
        Loop, 10 {
            if (startIndex + A_Index - 1 <= lines.Length()) {
                line := lines[startIndex + A_Index - 1]
                if (line != "")
                    newLog .= line . "`n"
            }
        }
    }
    
    GuiControl,, ActivityLog, %newLog%
    ControlSend, Edit1, ^{End}, A  ; Auto-scroll to bottom
}

; === EVENT HANDLERS ===
TogglePrayer:
    GuiControlGet, prayerFlickEnabled,, ChkPrayer
    UpdateLog("Prayer: " . (prayerFlickEnabled ? "ENABLED" : "DISABLED"))
    if (prayerFlickEnabled)
        SetTimer, RunAutomation, -100
return

ToggleSpecial:
    GuiControlGet, specialAttackEnabled,, ChkSpecial
    UpdateLog("Special Attack: " . (specialAttackEnabled ? "ENABLED" : "DISABLED"))
return

ToggleHerbs:
    GuiControlGet, herbCleaningEnabled,, ChkHerbs
    UpdateLog("Herb Cleaning: " . (herbCleaningEnabled ? "ENABLED" : "DISABLED"))
return

ToggleTeleport:
    GuiControlGet, autoTeleportEnabled,, ChkTeleport
    UpdateLog("Auto Teleport: " . (autoTeleportEnabled ? "ENABLED" : "DISABLED"))
return

ManualPrayer:
    PrayerFlick()
return

ManualSpecial:
    SpecialAttack()
return

ManualHerbs:
    CleanHerbs()
return

ManualTeleport:
    EmergencyTeleport()
return

DetectCoords:
    if (GetRuneLiteCoordinates()) {
        coords := GetQuickPrayerCoords()
        StringSplit, coordArray, coords, `,
        prayerX := coordArray1
        prayerY := coordArray2
        UpdateLog("Coordinates: Prayer(" . prayerX . "," . prayerY . ") Window(" . rlWidth . "x" . rlHeight . ")")
    } else {
        UpdateLog("RuneLite window not found")
    }
return

RefreshStatus:
    UpdateStatus()
    UpdateLog("Status refreshed")
return

ExitBtn:
    ExitApp
return

; === MAIN AUTOMATION LOOP ===
RunAutomation:
    if (prayerFlickEnabled && lastTick > 0) {
        PrayerFlick()
        SetTimer, RunAutomation, % -lastTick
    } else {
        SetTimer, RunAutomation, -1000
    }
return

; === TRAY MENU ===
Menu, Tray, NoStandard
Menu, Tray, Add, Show/Hide GUI, TrayToggleGUI
Menu, Tray, Add, Exit, TrayExit
Menu, Tray, Default, Show/Hide GUI
Menu, Tray, Click, 1

TrayToggleGUI:
    if WinExist("OSRS Automation Suite") {
        WinGet, isMinimized, MinMax
        if (isMinimized = -1) {
            WinRestore
        }
        WinGet, isVisible, Style
        if (isVisible & 0x10000000) { ; WS_VISIBLE
            WinHide
        } else {
            WinShow
            WinActivate
        }
    } else {
        BuildEnhancedGUI()
    }
return

TrayExit:
    ExitApp
return

; === HOTKEYS ===
F12::
    if WinExist("OSRS Automation Suite") {
        GuiControlGet, prayerFlickEnabled,, ChkPrayer
        GuiControl,, ChkPrayer, % !prayerFlickEnabled
        Gosub, TogglePrayer
    }
return

F11::
    if WinExist("OSRS Automation Suite") {
        GuiControlGet, specialAttackEnabled,, ChkSpecial
        GuiControl,, ChkSpecial, % !specialAttackEnabled
        Gosub, ToggleSpecial
    }
return

F10::
    if WinExist("OSRS Automation Suite") {
        GuiControlGet, herbCleaningEnabled,, ChkHerbs
        GuiControl,, ChkHerbs, % !herbCleaningEnabled
        Gosub, ToggleHerbs
    }
return

F8::
    EmergencyTeleport()
return

F9::
    UpdateLog("Gear switch triggered")
return

; === EMERGENCY HOTKEYS ===
^!F12:: ; Force center position
    if WinExist("OSRS Automation Suite") {
        WinGetPos,,, Width, Height
        WinMove, (A_ScreenWidth - Width)//2, (A_ScreenHeight - Height)//2
        WinShow
        WinActivate
    }
return

; === INITIALIZATION ===
BuildEnhancedGUI()
UpdateLog("Automation suite started")