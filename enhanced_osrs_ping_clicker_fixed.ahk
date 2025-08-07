; Enhanced OSRS AutoClicker with RuneLite Integration
; Uses both ping.txt and tick.txt from RuneLite Ping & Tick Logger plugin
; Toggle with F12 (Start/Stop), exit with Esc.

#Persistent
#SingleInstance Force
SetBatchLines -1
CoordMode, Mouse, Screen

; --- Configuration ---
minClickGap := 30     ; Min gap between clicks (ms)
maxClickGap := 50     ; Max gap between clicks (ms)
jitterMax   := 10     ; Max jitter (+/- ms)
defaultTick := 600    ; Default game tick length (ms) if file unavailable

; --- File Paths ---
pingPath    := A_UserProfile . "\.runelite\ping.txt"
tickPath    := A_UserProfile . "\.runelite\tick.txt"
dataPath    := A_UserProfile . "\.runelite\ping_tick_data.txt"

; --- State ---
running     := false
cycleCount  := 0
lastPing    := 0
lastTick    := defaultTick
lastCheck   := A_TickCount

; --- Build Enhanced GUI ---
Gui, Font, s10, Segoe UI
Gui, Add, Text,    x10 y10   w150 h20 vPingText,        Ping: N/A
Gui, Add, Text,    x10 y35   w150 h20 vTickText,        Tick: N/A
Gui, Add, Text,    x10 y60   w150 h20 vClickGapText,    Click Gap: N/A
Gui, Add, Text,    x10 y85   w150 h20 vJitterText,      Jitter: N/A
Gui, Add, Text,    x10 y110  w150 h20 vSleepText,       Sleep: N/A
Gui, Add, Text,    x10 y135  w150 h20 vActualText,      Actual: N/A
Gui, Add, Text,    x10 y160  w150 h20 vCycleText,       Cycle: 0
Gui, Add, Text,    x10 y185  w150 h20 vStatusText,      Status: Paused

; File status indicators
Gui, Add, Text,    x170 y10  w140 h15 vPingFileStatus,  Ping File: Checking...
Gui, Add, Text,    x170 y30  w140 h15 vTickFileStatus,  Tick File: Checking...  
Gui, Add, Text,    x170 y50  w140 h15 vDataFileStatus,  Data File: Checking...

; Raw data display
Gui, Add, Text,    x10 y210  w300 h15 vRawPingText,     Raw Ping: N/A
Gui, Add, Text,    x10 y230  w300 h15 vRawTickText,     Raw Tick: N/A
Gui, Add, Text,    x10 y250  w300 h15 vRawDataText,     Raw Data: N/A

; Control buttons
Gui, Add, Button,  x170 y85  w70  h25 gToggleBtn vBtnToggle, Start
Gui, Add, Button,  x250 y85  w60  h25 gExitBtn vBtnExit, Exit

; Log display
Gui, Add, Edit,    x10 y280  w300 h120 vLogEdit ReadOnly VScroll, ; Multiline log

; File path info
Gui, Add, Text,    x10 y410  w300 h15 vPathText,        Ping: %pingPath%
Gui, Add, Text,    x10 y430  w300 h15 vTickPathText,    Tick: %tickPath%

Gui, +AlwaysOnTop
Gui, Show, x0 y0 w330 h460, Enhanced OSRS AutoClicker
WinActivate, Enhanced OSRS AutoClicker

; Initial file checks
CheckAllFiles()
SetTimer, CheckAllFiles, 3000
return

; --- Functions ---
CheckAllFiles() {
    CheckPingFile()
    CheckTickFile()
    CheckDataFile()
}

CheckPingFile() {
    global pingPath, lastPing
    if FileExist(pingPath) {
        FileRead, pingStr, %pingPath%
        if (ErrorLevel = 0 && pingStr != "") {
            pingValue := Trim(pingStr) + 0
            if (pingValue > 0) {
                lastPing := pingValue
                GuiControl,, PingFileStatus, Ping: OK
                GuiControl, +cGreen, PingFileStatus
                GuiControl,, RawPingText, % "Raw Ping: " . Trim(pingStr)
            } else {
                GuiControl,, PingFileStatus, Ping: Invalid
                GuiControl, +cRed, PingFileStatus
                GuiControl,, RawPingText, % "Raw Ping: Invalid data (" . Trim(pingStr) . ")"
            }
        } else {
            GuiControl,, PingFileStatus, Ping: Read Error
            GuiControl, +cRed, PingFileStatus
            GuiControl,, RawPingText, Raw Ping: Failed to read file
        }
    } else {
        GuiControl,, PingFileStatus, Ping: Missing
        GuiControl, +cRed, PingFileStatus
        GuiControl,, RawPingText, Raw Ping: File not found
    }
}

CheckTickFile() {
    global tickPath, lastTick, defaultTick
    if FileExist(tickPath) {
        FileRead, tickStr, %tickPath%
        if (ErrorLevel = 0 && tickStr != "") {
            tickValue := Trim(tickStr) + 0
            if (tickValue > 200 && tickValue < 2000) {  ; Reasonable tick range
                lastTick := tickValue
                GuiControl,, TickFileStatus, Tick: OK
                GuiControl, +cGreen, TickFileStatus
                GuiControl,, RawTickText, % "Raw Tick: " . Trim(tickStr)
            } else {
                lastTick := defaultTick
                GuiControl,, TickFileStatus, Tick: Invalid
                GuiControl, +cOrange, TickFileStatus
                GuiControl,, RawTickText, % "Raw Tick: Invalid data (" . Trim(tickStr) . ")"
            }
        } else {
            lastTick := defaultTick
            GuiControl,, TickFileStatus, Tick: Read Error
            GuiControl, +cRed, TickFileStatus
            GuiControl,, RawTickText, Raw Tick: Failed to read file
        }
    } else {
        lastTick := defaultTick
        GuiControl,, TickFileStatus, Tick: Missing
        GuiControl, +cRed, TickFileStatus
        GuiControl,, RawTickText, % "Raw Tick: Using default " . defaultTick
    }
}

CheckDataFile() {
    global dataPath
    if FileExist(dataPath) {
        FileRead, dataStr, %dataPath%
        if (ErrorLevel = 0 && dataStr != "") {
            GuiControl,, DataFileStatus, Data: OK
            GuiControl, +cGreen, DataFileStatus
            GuiControl,, RawDataText, % "Raw Data: " . Trim(dataStr)
        } else {
            GuiControl,, DataFileStatus, Data: Read Error
            GuiControl, +cRed, DataFileStatus
            GuiControl,, RawDataText, Raw Data: Failed to read file
        }
    } else {
        GuiControl,, DataFileStatus, Data: Missing
        GuiControl, +cGray, DataFileStatus
        GuiControl,, RawDataText, Raw Data: Optional file not found
    }
}

; --- Hotkeys ---
F12::Toggle()
Esc::ExitApp

; --- Handlers ---
ToggleBtn:
    Toggle()
return

ExitBtn:
    ExitApp
return

; --- Toggle Start/Stop ---
Toggle() {
    global running
    running := !running
    GuiControl,, BtnToggle, % running ? "Stop" : "Start"
    GuiControl,, StatusText, % running ? "Running" : "Paused"
    
    if (running) {
        cycleCount := 0
        GuiControl,, CycleText, Cycle: 0
        SetTimer, MainCycle, -1
    } else {
        SetTimer, MainCycle, Off
    }
}

; --- Enhanced Main Loop ---
MainCycle:
    global running, cycleCount, lastPing, lastTick, minClickGap, maxClickGap, jitterMax
    
    if (!running) {
        return
    }
    
    startTime := A_TickCount
    
    ; Refresh file data every cycle for real-time updates
    CheckAllFiles()
    
    ; Use current tick length as target instead of fixed 600ms
    targetTick := lastTick
    currentPing := lastPing
    
    ; Calculate timing components
    Random, clickGap, %minClickGap%, %maxClickGap%
    Random, jitter, -%jitterMax%, %jitterMax%
    
    ; Enhanced calculation using actual tick length
    ; Formula: Sleep = ActualTickLength - ClickGap - Ping + Jitter
    adjustedWait := targetTick - clickGap - currentPing + jitter
    waitTime := (adjustedWait > 10) ? adjustedWait : 10
    
    ; Perform clicks
    Click
    Sleep, % clickGap
    Click
    
    ; Calculate actual time taken
    endTime := A_TickCount
    actualTime := endTime - startTime
    
    ; Update cycle counter
    cycleCount++
    GuiControl,, CycleText, Cycle: %cycleCount%
    
    ; Update GUI with current values
    GuiControl,, PingText,     Ping: %currentPing% ms
    GuiControl,, TickText,     Tick: %targetTick% ms
    GuiControl,, ClickGapText, Click Gap: %clickGap% ms
    GuiControl,, JitterText,   % "Jitter: " . (jitter >= 0 ? "+" : "") . jitter . " ms"
    GuiControl,, SleepText,    Sleep: %waitTime% ms
    GuiControl,, ActualText,   Actual: %actualTime% ms
    GuiControl,, StatusText,   Status: Running
    
    ; Enhanced logging with tick data
    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
    sign := jitter >= 0 ? "+" : ""
    logLine := ts . " - ping:" . currentPing . "ms, tick:" . targetTick . "ms, gap:" . clickGap . "ms, jitter:" . sign . jitter . "ms, sleep:" . waitTime . "ms, actual:" . actualTime . "ms`n"
    
    ; Write to log file
    FileAppend, %logLine%, % A_ScriptDir . "\enhanced_ping_clicker.log"
    
    ; Update GUI log (keep last 8 lines visible)
    GuiControlGet, oldLog,, LogEdit
    lines := StrSplit(oldLog, "`n")
    if (lines.Length() > 7) {
        ; Keep only last 6 lines plus new one
        newLog := ""
        Loop, % Min(6, lines.Length()) {
            idx := lines.Length() - 6 + A_Index
            if (idx > 0 && lines[idx] != "") {
                newLog .= lines[idx] . "`n"
            }
        }
        newLog .= logLine
    } else {
        newLog := oldLog . logLine
    }
    GuiControl,, LogEdit, %newLog%
    
    ; Scroll to bottom
    GuiControl, Focus, LogEdit
    Send, ^{End}
    
    ; Calculate next run time based on actual measured tick length
    nextRun := startTime + targetTick
    timeToWait := nextRun - A_TickCount
    if (timeToWait < 0)
        timeToWait := 0
    
    SetTimer, MainCycle, % -timeToWait
return

; Helper function
Min(a, b) {
    return (a < b) ? a : b
}
