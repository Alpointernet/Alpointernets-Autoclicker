#Persistent 

toggleLeft := false
toggleRight := false
clickCountLeft := 0
clickCountRight := 0
lastClickTimeLeft := 0
lastClickTimeRight := 0
inactivityTimerRunning := false
clickCountToSimulateLeft := 2 ; Initial default value for left click
clickCountToSimulateRight := 2 ; Initial default value for right click
clickWaitTimeLeft := 50 ; Click wait time for left click
clickWaitTimeRight := 50 ; Click wait time for right click
doubleClickWaitTimeLeft := 200 ; Double click wait time for left click
doubleClickWaitTimeRight := 200 ; Double click wait time for right click
inactivityResetTimeLeft := 1000 ; Inactivity reset time for left click
inactivityResetTimeRight := 1000 ; Inactivity reset time for right click
clickCountForDoubleClickLeft := 3 ; Click count for left double click
clickCountForDoubleClickRight := 3 ; Click count for right double click
winActiveCheck := 1  ; 1 = Enabled, 0 = Disabled
noDelayMode := 0  ; 0 = Disabled, 1 = Enabled
leftClickEnabled := 1  ; 1 = Enabled, 0 = Disabled
rightClickEnabled := 1  ; 1 = Enabled, 0 = Disabled
holdRightClick := 0  ; 0 = Disabled, 1 = Enabled
realisticClicking := 0 ; 0 = Disabled, 1 = Enabled
minClickDelay := 20 ; Minimum delay for realistic clicking
maxClickDelay := 300 ; Maximum delay for realistic clicking
guiModifier := "Alt" ; Default GUI modifier key
guiKey := "c" ; Default GUI key
exitModifier := "Alt" ; Default exit modifier key
exitKey := "v" ; Default exit key

; Load settings from the configuration file
IfExist, %A_ScriptDir%\settings.ini
{
    IniRead, clickCountToSimulateLeft, %A_ScriptDir%\settings.ini, Settings, ClickCountToSimulateLeft, 2
    IniRead, clickCountToSimulateRight, %A_ScriptDir%\settings.ini, Settings, ClickCountToSimulateRight, 2
    IniRead, clickWaitTimeLeft, %A_ScriptDir%\settings.ini, Settings, ClickWaitTimeLeft, 50
    IniRead, clickWaitTimeRight, %A_ScriptDir%\settings.ini, Settings, ClickWaitTimeRight, 50
    IniRead, doubleClickWaitTimeLeft, %A_ScriptDir%\settings.ini, Settings, DoubleClickWaitTimeLeft, 200
    IniRead, doubleClickWaitTimeRight, %A_ScriptDir%\settings.ini, Settings, DoubleClickWaitTimeRight, 200
    IniRead, inactivityResetTimeLeft, %A_ScriptDir%\settings.ini, Settings, InactivityResetTimeLeft, 1000
    IniRead, inactivityResetTimeRight, %A_ScriptDir%\settings.ini, Settings, InactivityResetTimeRight, 1000
    IniRead, clickCountForDoubleClickLeft, %A_ScriptDir%\settings.ini, Settings, ClickCountForDoubleClickLeft, 3
    IniRead, clickCountForDoubleClickRight, %A_ScriptDir%\settings.ini, Settings, ClickCountForDoubleClickRight, 3
    IniRead, winActiveCheck, %A_ScriptDir%\settings.ini, Settings, WinActiveCheck, 1
    IniRead, noDelayMode, %A_ScriptDir%\settings.ini, Settings, NoDelayMode, 0
    IniRead, leftClickEnabled, %A_ScriptDir%\settings.ini, Settings, LeftClickEnabled, 1
    IniRead, rightClickEnabled, %A_ScriptDir%\settings.ini, Settings, RightClickEnabled, 1
    IniRead, holdRightClick, %A_ScriptDir%\settings.ini, Settings, HoldRightClick, 0
    IniRead, realisticClicking, %A_ScriptDir%\settings.ini, Settings, RealisticClicking, 0
    IniRead, guiModifier, %A_ScriptDir%\settings.ini, Hotkeys, GuiModifier, Alt
    IniRead, guiKey, %A_ScriptDir%\settings.ini, Hotkeys, GuiKey, c
    IniRead, exitModifier, %A_ScriptDir%\settings.ini, Hotkeys, ExitModifier, Alt
    IniRead, exitKey, %A_ScriptDir%\settings.ini, Hotkeys, ExitKey, v
}

; Create dynamic hotkeys based on modifier
if (guiModifier = "Alt")
    Hotkey, !%guiKey%, ShowGui
else if (guiModifier = "LControl")
    Hotkey, ^%guiKey%, ShowGui
else if (guiModifier = "RControl")
    Hotkey, >^%guiKey%, ShowGui

if (exitModifier = "Alt")
    Hotkey, !%exitKey%, ExitScript
else if (exitModifier = "LControl")
    Hotkey, ^%exitKey%, ExitScript
else if (exitModifier = "RControl")
    Hotkey, >^%exitKey%, ExitScript

ShowGui:
{
    ; Create the GUI window
    Gui, New
    Gui, Color, FFFFFF  ; Light background
    Gui, Font, c000000 S10, Segoe UI  ; Black text
    Gui, +Alwaysontop

    ; Add draggable background labels between controls
    Gui, Add, Text, x0 y0 w630 h10 gGuiMove BackgroundTrans
    Gui, Add, Text, x0 y10 w10 h500 gGuiMove BackgroundTrans
    Gui, Add, Text, x620 y10 w10 h500 gGuiMove BackgroundTrans
    Gui, Add, Text, x290 y10 w20 h500 gGuiMove BackgroundTrans

    ; Left-click section
    Gui, Add, Text, x10 y10 w280 h25 Center gGuiMove vLblLeftSideHeader, Left Click
    Gui, Add, Text, x10 y40 gGuiMove vLblClickCountToSimulate, Number of clicks to simulate:
    Gui, Add, Edit, x10 y60 w280 h25 vClickCountToSimulateEdit BackgroundF0F0F0 c000000, %clickCountToSimulateLeft%

    Gui, Add, Text, x10 y100 gGuiMove vLblClickWaitTime, Delay time between simulated clicks (ms):
    Gui, Add, Edit, x10 y120 w280 h25 vClickWaitTimeEdit BackgroundF0F0F0 c000000, %clickWaitTimeLeft%

    Gui, Add, Text, x10 y160 gGuiMove vLblDoubleClickWaitTime, Double-click detection time (ms):
    Gui, Add, Edit, x10 y180 w280 h25 vDoubleClickWaitTimeEdit BackgroundF0F0F0 c000000, %doubleClickWaitTimeLeft%

    Gui, Add, Text, x10 y220 gGuiMove vLblInactivityResetTime, Inactivity reset time (ms):
    Gui, Add, Edit, x10 y240 w280 h25 vInactivityResetTimeEdit BackgroundF0F0F0 c000000, %inactivityResetTimeLeft%

    Gui, Add, Text, x10 y280 gGuiMove vLblClickCountForDoubleClick, Number of clicks to trigger double-click:
    Gui, Add, Edit, x10 y300 w280 h25 vClickCountForDoubleClickEdit BackgroundF0F0F0 c000000, %clickCountForDoubleClickLeft%

    Gui, Add, Button, x10 y340 w20 h20 vLeftClickEnabledCheck gToggleLeftClick, % (leftClickEnabled ? "X" : " ")
    Gui, Add, Text, x35 y340 w255 h20 vLeftClickEnabledLabel, Enable Left Click

    Gui, Add, Button, x10 y370 w20 h20 vWinActiveCheckEdit gToggleWinActive, % (winActiveCheck ? "X" : " ")
    Gui, Add, Text, x35 y370 w255 h20 vWinActiveCheckLabel, Enable "Only When Minecraft is Active"

    Gui, Add, Button, x10 y400 w20 h20 vRealisticClickingCheck gToggleRealisticClicking, % (realisticClicking ? "X" : " ")
    Gui, Add, Text, x35 y400 w120 h20 vRealisticClickingLabel, Mimic Realistic Click
    Gui, Add, Edit, x160 y400 w40 h20 vMinClickDelayEdit BackgroundF0F0F0 c000000, %minClickDelay%
    Gui, Add, Text, x205 y400 w10 h20, -
    Gui, Add, Edit, x220 y400 w40 h20 vMaxClickDelayEdit BackgroundF0F0F0 c000000, %maxClickDelay%

    ; Right-click section (positioned to the right)
    Gui, Add, Text, x310 y10 w280 h25 Center gGuiMove vLblRightSideHeader, Right Click
    Gui, Add, Text, x310 y40 gGuiMove vLblClickCountToSimulateRight, Number of clicks to simulate:
    Gui, Add, Edit, x310 y60 w280 h25 vClickCountToSimulateEditRight BackgroundF0F0F0 c000000, %clickCountToSimulateRight%

    Gui, Add, Text, x310 y100 gGuiMove vLblClickWaitTimeRight, Delay time between simulated clicks (ms):
    Gui, Add, Edit, x310 y120 w280 h25 vClickWaitTimeEditRight BackgroundF0F0F0 c000000, %clickWaitTimeRight%

    Gui, Add, Text, x310 y160 gGuiMove vLblDoubleClickWaitTimeRight, Double-click detection time (ms):
    Gui, Add, Edit, x310 y180 w280 h25 vDoubleClickWaitTimeEditRight BackgroundF0F0F0 c000000, %doubleClickWaitTimeRight%

    Gui, Add, Text, x310 y220 gGuiMove vLblInactivityResetTimeRight, Inactivity reset time (ms):
    Gui, Add, Edit, x310 y240 w280 h25 vInactivityResetTimeEditRight BackgroundF0F0F0 c000000, %inactivityResetTimeRight%

    Gui, Add, Text, x310 y280 gGuiMove vLblClickCountForDoubleClickRight, Number of clicks to trigger double-click:
    Gui, Add, Edit, x310 y300 w280 h25 vClickCountForDoubleClickEditRight BackgroundF0F0F0 c000000, %clickCountForDoubleClickRight%

    Gui, Add, Button, x310 y340 w20 h20 vRightClickEnabledCheck gToggleRightClick, % (rightClickEnabled ? "X" : " ")
    Gui, Add, Text, x335 y340 w255 h20 vRightClickEnabledLabel, Enable Right Click

    Gui, Add, Button, x310 y370 w20 h20 vNoDelayModeCheckRight gToggleNoDelay, % (noDelayMode ? "X" : " ")
    Gui, Add, Text, x335 y370 w255 h20 vNoDelayModeLabel, No Delay Mode

    Gui, Add, Button, x310 y400 w20 h20 vHoldRightClickCheck gToggleHoldClick, % (holdRightClick ? "X" : " ")
    Gui, Add, Text, x335 y400 w255 h20 vHoldRightClickLabel, Hold Click Mode

    ; Hotkey settings section
    Gui, Add, Text, x10 y430 w280 h20, GUI Hotkey:
    Gui, Add, DropDownList, x10 y450 w100 vGuiModifierEdit, Alt||LControl|RControl
    Gui, Add, Edit, x120 y450 w170 h20 vGuiKeyEdit, %guiKey%

    Gui, Add, Text, x310 y430 w280 h20, Exit Hotkey:
    Gui, Add, DropDownList, x310 y450 w100 vExitModifierEdit, Alt||LControl|RControl
    Gui, Add, Edit, x420 y450 w170 h20 vExitKeyEdit, %exitKey%

    ButtonWidth := 120
    Gap := 10
    WindowWidth := 600
    TotalButtonWidth := ButtonWidth * 2 + Gap
    XPosition := (WindowWidth - TotalButtonWidth) / 2

    ButtonX1 := XPosition
    ButtonX2 := XPosition + ButtonWidth + Gap

    Gui, Add, Button, x%ButtonX1% y490 w120 h30 Default gSetClickSettings BackgroundF0F0F0 c000000, Save Settings
    Gui, Add, Button, x%ButtonX2% y490 w120 h30 gCancelGUI BackgroundF0F0F0 c000000, Cancel

    Gui, Font, cC0C0C0 S8
    Gui, Add, Text, x433 y508 w160 h20, Made with <3 by Alpointernet
    Gui, Font, c000000 S10, Segoe UI  ; Reset font

    Gui, Show,, Settings

    Gui, +LastFound
    hwnd := WinExist()

    WinSet, Style, -0xC00000, ahk_id %hwnd%

    DllCall("SetWindowRgn", "UInt", hwnd, "UInt", CreateRoundRectRgn(0, 0, 600, 530, 15, 15), "Int", true)

    Gui, Show, w630 h550

    return
}

ToggleWinActive:
winActiveCheck := !winActiveCheck
GuiControl,, WinActiveCheckEdit, % (winActiveCheck ? "X" : " ")
return

ToggleLeftClick:
leftClickEnabled := !leftClickEnabled
GuiControl,, LeftClickEnabledCheck, % (leftClickEnabled ? "X" : " ")
return

ToggleNoDelay:
noDelayMode := !noDelayMode
GuiControl,, NoDelayModeCheckRight, % (noDelayMode ? "X" : " ")
return

ToggleRightClick:
rightClickEnabled := !rightClickEnabled
GuiControl,, RightClickEnabledCheck, % (rightClickEnabled ? "X" : " ")
return

ToggleHoldClick:
holdRightClick := !holdRightClick
GuiControl,, HoldRightClickCheck, % (holdRightClick ? "X" : " ")
return

ToggleRealisticClicking:
realisticClicking := !realisticClicking
GuiControl,, RealisticClickingCheck, % (realisticClicking ? "X" : " ")
return

GuiMove:
PostMessage, 0xA1, 2,,, A
return

CreateRoundRectRgn(x, y, width, height, radiusX, radiusY)
{
    return DllCall("gdi32.dll\CreateRoundRectRgn", "Int", x, "Int", y, "Int", width, "Int", height, "Int", radiusX, "Int", radiusY, "UInt")
}

SetClickSettings:
{
    Gui, Submit

    ; Validate and update settings only if the inputs are valid numbers
    clickCountToSimulateLeft := (ClickCountToSimulateEdit != "" && RegExMatch(ClickCountToSimulateEdit, "^\d+$")) ? ClickCountToSimulateEdit : clickCountToSimulateLeft
    clickCountToSimulateRight := (ClickCountToSimulateEditRight != "" && RegExMatch(ClickCountToSimulateEditRight, "^\d+$")) ? ClickCountToSimulateEditRight : clickCountToSimulateRight
    clickWaitTimeLeft := (ClickWaitTimeEdit != "" && RegExMatch(ClickWaitTimeEdit, "^\d+$")) ? ClickWaitTimeEdit : clickWaitTimeLeft
    clickWaitTimeRight := (ClickWaitTimeEditRight != "" && RegExMatch(ClickWaitTimeEditRight, "^\d+$")) ? ClickWaitTimeEditRight : clickWaitTimeRight
    doubleClickWaitTimeLeft := (DoubleClickWaitTimeEdit != "" && RegExMatch(DoubleClickWaitTimeEdit, "^\d+$")) ? DoubleClickWaitTimeEdit : doubleClickWaitTimeLeft
    doubleClickWaitTimeRight := (DoubleClickWaitTimeEditRight != "" && RegExMatch(DoubleClickWaitTimeEditRight, "^\d+$")) ? DoubleClickWaitTimeEditRight : doubleClickWaitTimeRight
    inactivityResetTimeLeft := (InactivityResetTimeEdit != "" && RegExMatch(InactivityResetTimeEdit, "^\d+$")) ? InactivityResetTimeEdit : inactivityResetTimeLeft
    inactivityResetTimeRight := (InactivityResetTimeEditRight != "" && RegExMatch(InactivityResetTimeEditRight, "^\d+$")) ? InactivityResetTimeEditRight : inactivityResetTimeRight
    clickCountForDoubleClickLeft := (ClickCountForDoubleClickEdit != "" && RegExMatch(ClickCountForDoubleClickEdit, "^\d+$")) ? ClickCountForDoubleClickEdit : clickCountForDoubleClickLeft
    clickCountForDoubleClickRight := (ClickCountForDoubleClickEditRight != "" && RegExMatch(ClickCountForDoubleClickEditRight, "^\d+$")) ? ClickCountForDoubleClickEditRight : clickCountForDoubleClickRight
    minClickDelay := (MinClickDelayEdit != "" && RegExMatch(MinClickDelayEdit, "^\d+$")) ? MinClickDelayEdit : minClickDelay
    maxClickDelay := (MaxClickDelayEdit != "" && RegExMatch(MaxClickDelayEdit, "^\d+$")) ? MaxClickDelayEdit : maxClickDelay

    ; Update hotkey settings
    if (guiModifier = "Alt")
        Hotkey, !%guiKey%, Off
    else if (guiModifier = "LControl")
        Hotkey, ^%guiKey%, Off
    else if (guiModifier = "RControl")
        Hotkey, >^%guiKey%, Off

    if (exitModifier = "Alt")
        Hotkey, !%exitKey%, Off
    else if (exitModifier = "LControl")
        Hotkey, ^%exitKey%, Off
    else if (exitModifier = "RControl")
        Hotkey, >^%exitKey%, Off
    
    guiModifier := GuiModifierEdit
    guiKey := GuiKeyEdit
    exitModifier := ExitModifierEdit
    exitKey := ExitKeyEdit
    
    if (guiModifier = "Alt")
        Hotkey, !%guiKey%, ShowGui, On
    else if (guiModifier = "LControl")
        Hotkey, ^%guiKey%, ShowGui, On
    else if (guiModifier = "RControl")
        Hotkey, >^%guiKey%, ShowGui, On

    if (exitModifier = "Alt")
        Hotkey, !%exitKey%, ExitScript, On
    else if (exitModifier = "LControl")
        Hotkey, ^%exitKey%, ExitScript, On
    else if (exitModifier = "RControl")
        Hotkey, >^%exitKey%, ExitScript, On

    ; Reset toggle states when settings change
    toggleLeft := false
    toggleRight := false

    ; Save updated settings to the INI file
    IniWrite, %clickCountToSimulateLeft%, %A_ScriptDir%\settings.ini, Settings, ClickCountToSimulateLeft
    IniWrite, %clickCountToSimulateRight%, %A_ScriptDir%\settings.ini, Settings, ClickCountToSimulateRight
    IniWrite, %clickWaitTimeLeft%, %A_ScriptDir%\settings.ini, Settings, ClickWaitTimeLeft
    IniWrite, %clickWaitTimeRight%, %A_ScriptDir%\settings.ini, Settings, ClickWaitTimeRight
    IniWrite, %doubleClickWaitTimeLeft%, %A_ScriptDir%\settings.ini, Settings, DoubleClickWaitTimeLeft
    IniWrite, %doubleClickWaitTimeRight%, %A_ScriptDir%\settings.ini, Settings, DoubleClickWaitTimeRight
    IniWrite, %inactivityResetTimeLeft%, %A_ScriptDir%\settings.ini, Settings, InactivityResetTimeLeft
    IniWrite, %inactivityResetTimeRight%, %A_ScriptDir%\settings.ini, Settings, InactivityResetTimeRight
    IniWrite, %clickCountForDoubleClickLeft%, %A_ScriptDir%\settings.ini, Settings, ClickCountForDoubleClickLeft
    IniWrite, %clickCountForDoubleClickRight%, %A_ScriptDir%\settings.ini, Settings, ClickCountForDoubleClickRight
    IniWrite, %winActiveCheck%, %A_ScriptDir%\settings.ini, Settings, WinActiveCheck
    IniWrite, %noDelayMode%, %A_ScriptDir%\settings.ini, Settings, NoDelayMode
    IniWrite, %leftClickEnabled%, %A_ScriptDir%\settings.ini, Settings, LeftClickEnabled
    IniWrite, %rightClickEnabled%, %A_ScriptDir%\settings.ini, Settings, RightClickEnabled
    IniWrite, %holdRightClick%, %A_ScriptDir%\settings.ini, Settings, HoldRightClick
    IniWrite, %realisticClicking%, %A_ScriptDir%\settings.ini, Settings, RealisticClicking
    IniWrite, %guiModifier%, %A_ScriptDir%\settings.ini, Hotkeys, GuiModifier
    IniWrite, %guiKey%, %A_ScriptDir%\settings.ini, Hotkeys, GuiKey
    IniWrite, %exitModifier%, %A_ScriptDir%\settings.ini, Hotkeys, ExitModifier
    IniWrite, %exitKey%, %A_ScriptDir%\settings.ini, Hotkeys, ExitKey

    ToolTip, % "Settings updated!"
    Sleep, 2000
    Tooltip
    Gui, Destroy
    return
}

CancelGUI:
{
    Gui, Destroy
    return
}

ExitScript:
Gui, Destroy ; Destroy GUI first if it exists
ToolTip, % "Application Exit"
Sleep, 500 ; sleep time
Tooltip
ExitApp
return

; Left-click behavior
~LButton:: ; Detect left mouse click
{
    if (leftClickEnabled = 0)  ; Skip if left-click is disabled
        return

    if (winActiveCheck && !WinActive("ahk_exe javaw.exe")) {
        return
    }

    if (A_TickCount - lastClickTimeLeft < doubleClickWaitTimeLeft) {
        clickCountLeft++
    } else {
        clickCountLeft := 1
    }

    lastClickTimeLeft := A_TickCount

    if (clickCountLeft >= clickCountForDoubleClickLeft && !toggleLeft) {
        toggleLeft := true
    }

    if (toggleLeft) {
        Loop, %clickCountToSimulateLeft% {
            Click
            if (noDelayMode = 1) {
                Sleep, 1
            } else if (realisticClicking = 1) {
                Random, randomDelay, %minClickDelay%, %maxClickDelay%
                Sleep, %randomDelay%
            } else {
                Sleep, %clickWaitTimeLeft%
            }
        }
    }

    if (inactivityTimerRunning) {
        SetTimer, DisableDoubleClickLeft, Off
        inactivityTimerRunning := false
    }

    if (!inactivityTimerRunning) {
        SetTimer, DisableDoubleClickLeft, %inactivityResetTimeLeft%
        inactivityTimerRunning := true
    }

    return
}

DisableDoubleClickLeft:
if (A_TickCount - lastClickTimeLeft >= inactivityResetTimeLeft && toggleLeft) {
    toggleLeft := false
    SetTimer, DisableDoubleClickLeft, Off
    inactivityTimerRunning := false
}
return

; Right-click behavior
~RButton:: ; Detect right mouse click
{
    if (rightClickEnabled = 0)  ; Skip if right-click is disabled
        return

    if (winActiveCheck && !WinActive("ahk_exe javaw.exe")) {
        return
    }

    if (A_TickCount - lastClickTimeRight < doubleClickWaitTimeRight) {
        clickCountRight++
    } else {
        clickCountRight := 1
    }

    lastClickTimeRight := A_TickCount

    if (clickCountRight >= clickCountForDoubleClickRight) {
        if (holdRightClick = 1) {
            while (GetKeyState("RButton", "P")) {
                Click right
                if (noDelayMode = 1) {
                    Sleep, 1
                } else if (realisticClicking = 1) {
                    Random, randomDelay, %minClickDelay%, %maxClickDelay%
                    Sleep, %randomDelay%
                } else {
                    Sleep, %clickWaitTimeRight%
                }
            }
        } else {
            if (!toggleRight) {
                toggleRight := true
            }
            
            if (toggleRight) {
                Loop, %clickCountToSimulateRight% {
                    Click right
                    if (noDelayMode = 1) {
                        Sleep, 0
                    } else if (realisticClicking = 1) {
                        Random, randomDelay, %minClickDelay%, %maxClickDelay%
                        Sleep, %randomDelay%
                    } else {
                        Sleep, %clickWaitTimeRight%
                    }
                }
            }
        }
    }

    if (inactivityTimerRunning) {
        SetTimer, DisableDoubleClickRight, Off
        inactivityTimerRunning := false
    }

    if (!inactivityTimerRunning) {
        SetTimer, DisableDoubleClickRight, %inactivityResetTimeRight%
        inactivityTimerRunning := true
    }

    return
}

DisableDoubleClickRight:
if (A_TickCount - lastClickTimeRight >= inactivityResetTimeRight && toggleRight) {
    toggleRight := false
    SetTimer, DisableDoubleClickRight, Off
    inactivityTimerRunning := false
}
return