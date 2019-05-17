; Author: Rolando Lucio
; Git: https://github.com/rolandolucio/dynastio-autokeys

#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1
defDelay:=60
statusFlag:=0
justPlace:=0
; for low level some exceptions maybe needed
lowLevelAcct:=0
;Default Values
HitAndMoveWeaponKey:=2 ;Expect saber or pan
lastKey:=HitAndMoveWeaponKey

swapStatus(statusFlag)
{
    If (statusFlag>0){
    statusFlag:=0
    }Else{
        statusFlag:=1
    }
    return statusFlag
}
MenuBuild_Open(s:=20)
{
    Sleep, %s%
    Send, {b}
    return s   ; "Return" expects an expression.
}
MenuBuildArmy_Open(s:=20)
{   
    MenuBuild_Open(s)
    Sleep, %s%
    ; Reset By Clicking Defenses
    Click, 1186, 359  Left, Down
    Sleep, %s%
    Click, 1186, 359  Left, Up
    Sleep, %s%
    Click, 1314, 359 Left, Down
    Sleep, %s%
    Click, 1314, 359 Left, Up
    return s   
}
MenuBuildDefenses_Open(s:=20)
{   
    ;MenuBuildArmy_Open(s)
    MenuBuild_Open(s)
    Sleep, %s%
    ; reset by scrollup
   ; Click, WheelUp
   ;Reset By selecting Army tab and clicking back
    Click, 1314, 359 Left, Down
    Sleep, %s%
    Click, 1314, 359 Left, Up
    Sleep, %s%
    Click, 1186, 359  Left, Down
    Sleep, %s%
    Click, 1186, 359  Left, Up
    return s   
}
MenuBuildMisc_Open(s:=20)
{   
    ;MenuBuildArmy_Open(s)
    MenuBuild_Open(s)
    Sleep, %s%
    ; reset by scrollup
   ; Click, WheelUp
   ;Reset By selecting Army tab and clicking back
    Click, 1314, 359 Left, Down
    Sleep, %s%
    Click, 1314, 359 Left, Up
    Sleep, %s%
    Click, 1380, 359  Left, Down
    Sleep, %s%
    Click, 1380, 359  Left, Up
    return s   
}
MenuBuild_BuildBtn(s:=20)
{
    Sleep, %s%
    Click, 1579, 745 Left, Down
    Sleep, %s%
    Click, 1579, 745 Left, Up
    return s 
}
cmd_Trap_Build(lowLevelAcct:=0,s:=10)
{
    MouseGetPos, xpos, ypos 
    MenuBuildDefenses_Open(s)
    Sleep, %s%
    If (lowLevelAcct=0){
    ;Select Trap After Cactus Wall
        Click, 1267, 761 Left, Down
        Sleep, %s%
        Click, 1267, 761 Left, Up
    }Else{
        Click, 1267, 710 Left, Down
        Sleep, %s%
        Click, 1267, 710 Left, Up
    }
    MenuBuild_BuildBtn(s)
    Sleep, %s%
    Click,  %xpos%, %ypos% , 0
    return 1
}
cmd_Wall_Build(s:=10)
{
    MouseGetPos, xpos, ypos 
    MenuBuildDefenses_Open(s)
    Sleep, %s%
    ;Select Trap
    Click, 1186, 359  Left, Down
    Sleep, %s%
    Click, 1186, 359  Left, Up
    MenuBuild_BuildBtn(s)
    Sleep, %s%
    Click,  %xpos%, %ypos% , 0
    return 1
}
cmd_Guard_Build(s:=10)
{
    MouseGetPos, xpos, ypos 
    MenuBuildArmy_Open(s)
    Sleep, %s%
    ;Select Trap
    Click, 1267, 380 Left, Down
    Sleep, %s%
    Click, 1267, 370 Left, Up
    MenuBuild_BuildBtn(s)
    Sleep, %s%
    Click,  %xpos%, %ypos% , 0
    return 1
}
cmd_Knight_Build(s:=10)
{
    MouseGetPos, xpos, ypos 
    MenuBuildArmy_Open(s)
    Sleep, %s%
    ;Select Trap
    Click, 1267, 520 Left, Down
    Sleep, %s%
    Click, 1267, 520 Left, Up
    MenuBuild_BuildBtn(s)
    Sleep, %s%
    Click,  %xpos%, %ypos% , 0
    return 1
}
BuildSoul(s:=10)
{
    MouseGetPos, xpos, ypos 
    MenuBuildMisc_Open(s)
    Sleep, %s%
    ;Select Soul
    Click, 1267, 545 Left, Down
    Sleep, %s%
    Click, 1267, 545 Left, Up
    MenuBuild_BuildBtn(s)
    Sleep, %s%
    Click,  %xpos%, %ypos% , 0
    return 1
}
/*
SendRecord
Send The key and record it to variable by reference 
case: record and active last we want to record
otherwise any kek use ahk native history
*/
SendRecord(ByRef refVar,keyToSend)
{
    Send, {%keyToSend%}
    refVar:= keyToSend
}
/*
SendToggle
toggle from Any Key to Base key
Or from Base To Second key
And Record it
*/
SendToggle(ByRef lastKey, base,second,delay:=100)
{
    Sleep, %delay%
    If (lastKey!=base){
        Send, {%base%}
        lastKey:=base
    }Else{
        Send, {%second%}
        lastKey:=second
    }
}
/*
Equip
Works for equippable Gear as Shields or hats
Equip the selected item in one single action
instead of having to key click manually
optional could send a key to be selected after 
ie.
single equip heal hat at 0
equip(0)
with select of katana at 2 after
equip(0,2)

*/
Equip(item,select:=10,delay:=100)
{
    MouseGetPos, xpos, ypos 
    Send, {%item%}
    Sleep, %delay%
    Click,  %xpos%, %ypos%  Left, Down
    Sleep, %delay%
    Click,  %xpos%, %ypos%  Left, Up
    If (select!=10){
        Send, {%select%}
    } 
}
/*
    same as SendRecord invoke equip
*/
EquipRecord(ByRef refVar,item,select:=10,delay:=100)
{
    If (select!=10){
        refVar:=select
    }Else
    {
        refVar:=item
    }
    Equip(item,select,delay)
}
/**********************
Macro like functions
=====================
*/
LevelTraps(ByRef lastKey,ByRef statusFlag,counter,lowLevelAcct,defDelay,ByRef justPlace)
{
    If (justPlace=1){         
        cmd_Trap_Build(lowLevelAcct,defDelay)
        Sleep, 500
        Send, {LShift Down}
    }
    Loop, %counter% {
        If (statusFlag=0){
            break
        }
        If (justPlace=0){         
            cmd_Trap_Build(lowLevelAcct,defDelay)
            Sleep, 500
            Send, {LShift Down}
        }
        
        MouseGetPos, xpos, ypos 
        initx:=xpos
        inity:=ypos
        hity:=inity-30
        xpos:=xpos-50
        ypos:=ypos-50
        Click,  %xpos%, %ypos%  Left, Down
        Sleep, 100
        Click,  %xpos%, %ypos%  Left, Up
        Sleep, 100
        Click,  %xpos%, %ypos% , 0
        xpos:=xpos+50
        Sleep, 100
        Click,  %xpos%, %ypos%  Left, Down
        Sleep, 100
        Click,  %xpos%, %ypos%  Left, Up
        Sleep, 100
        Click,  %xpos%, %ypos% , 0
        ypos:=ypos+50
        Sleep, 100
        Click,  %xpos%, %ypos%  Left, Down
        Sleep, 100
        Click,  %xpos%, %ypos%  Left, Up
        Sleep, 100
        Click,  %xpos%, %ypos% , 0
        ypos:=ypos+50
        Sleep, 100
        Click,  %xpos%, %ypos%  Left, Down
        Sleep, 100
        Click,  %xpos%, %ypos%  Left, Up
        Sleep, 100
        Click,  %xpos%, %ypos% , 0
        Sleep, 100
               
        If (justPlace=0){
            Send, {LShift Up}
            Send, {Escape}
            Sleep, 500
            SendRecord(lastKey,5)
            Click,  %initx%, %hity% , 0
            Sleep, 100
            Click,  %initx%, %hity%  Left, Down
            Sleep, 100
            Click,  %initx%, %hity%  Left, Up
            Sleep, 100     
        }
        Click,  %initx%, %inity% , 0
        Sleep, 100
    }
    If (justPlace=1){
        Send, {LShift Up}
        Send, {Escape}
        Sleep, 500
    }
   
    
}

#IF statusFlag>0
/***************************
Full CMD Routines
=======================
*/
/*
tggs menu button
*/
/*
MButton::
WinActivate
Sleep, 333
MenuBuild_Open(defDelay)
Return
*/
LShift & ~MButton::
while  KeyIsDown := GetKeyState("Mbutton")
{
    MouseGetPos, xpos, ypos 
    Click,  %xpos%, %ypos%  Left, Down
    Sleep, 100
    Click,  %xpos%, %ypos%  Left, Up
    Sleep, 100
    ;Click,  %xpos%, %ypos% , 0
}
Return


RButton::
WinActivate
Sleep, 333
cmd_Trap_Build(lowLevelAcct,defDelay)
Return
Tab::
CapsLock::
WinActivate
Sleep, 333
cmd_Wall_Build(defDelay)
Return
XButton2::
WinActivate
Sleep, 333
cmd_Guard_Build(defDelay)
Return
XButton1::
WinActivate
Sleep, 333
cmd_Knight_Build(defDelay)
Return
Numpad0::
NumpadIns::
WinActivate
Sleep, 333
BuildSoul(defDelay)
Return
F6::
WinActivate
Sleep, 333

LevelTraps(lastKey,statusFlag,20,lowLevelAcct,defDelay,justPlace)

Return
F7::
WinActivate
Sleep, 333
LevelTraps(lastKey,statusFlag,5,lowLevelAcct,defDelay,justPlace)
Return

/******************
; Easy Swap buttons
=====================
*/
/*
    From HitAndMoveWeaponKey To Spear
*/
Space::
SendToggle(lastKey,HitAndMoveWeaponKey,1)
Return


/***************************
Equippable Items
=======================
Reserved 8 to 0 , Numpad /*-
for shields and hats
*/
/* 
Single Equip
*/
8::
EquipRecord(lastKey,8)
Return
9::
EquipRecord(lastKey,9)
Return
0::
EquipRecord(lastKey,0)
Return
/* 
Select EquipRecord
*/
NumpadDiv::
EquipRecord(lastKey,8,HitAndMoveWeaponKey)
Return
NumpadMult::
EquipRecord(lastKey,9,HitAndMoveWeaponKey)
Return
NumpadSub::
EquipRecord(lastKey,0,HitAndMoveWeaponKey)
Return
MButton::
EquipRecord(lastKey,5,HitAndMoveWeaponKey)
Return



/*************************
Record Base Keys & Key Binding
=========================
*/
/*
Default, adding record behavior
*/
1::
SendRecord(lastKey,1)
Return
2::
SendRecord(lastKey,2)
Return
3::
SendRecord(lastKey,3)
Return
4::
SendRecord(lastKey,4)
Return
5::
SendRecord(lastKey,5)
Return
6::
SendRecord(lastKey,6)
Return
7::
SendRecord(lastKey,7)
Return
/* 
Record Key Bind
*/
q::
SendRecord(lastKey,1)
Return
f::
SendRecord(lastKey,3)
Return
r::
SendRecord(lastKey,4)
Return
t::
SendRecord(lastKey,6)
Return
/*
 Simple Key Bind (no record)
*/
|::
Send, {Escape}
Return
/*
AFK Routines
*/
Numpad4::
Loop, 120 {
   
    Loop, 64 {
        Send, {w}
        Sleep, 100
    }
    Loop, 8 {
        Send, {e}
        Sleep, 100
    }
    Loop, 64 {
        Send, {s}
        Sleep, 100
    }
    Loop, 8 {
        Send, {e}
        Sleep, 100
    }
    Sleep, 300000
}  
    
Return
#If


/*****************************
AHK script Flow Control
==============================
*/
Flow:
/*
Exception for low level Acct enable/disable
*/
F8::
lowLevelAcct:=swapStatus(lowLevelAcct)
Return
/*
ie Switch from placing and breking(macros) for just placing for some one
*/
Numpad5::
justPlace:=swapStatus(justPlace)
Return
/*
 Temporaly Logic pause  keys when chating in game  or F9 for outside or reset flag
*/
Enter::
statusFlag:=swapStatus(statusFlag)
Send, {Enter}
Return
/* 
Works As Start/Reset Button 
*/
F9::
statusFlag:=swapStatus(statusFlag)
Return
/*
Full Script Pause, wont execute any stuff untill pressed again
*/
F10::Suspend
/*
as Sys Pause. AHK loops and current threat are paused, execute back when pressing any command back
*/
F11::Pause
/*
Close AHK Script
*/
F12::ExitApp






