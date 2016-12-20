#SingleInstance force
#NoEnv
#include <CvJoyInterface>
SetBatchLines, -1

hotkeyLabels := Object()
hotkeyLabels.Insert("Analog Up")
hotkeyLabels.Insert("Analog Left")
hotkeyLabels.Insert("Analog Down")
hotkeyLabels.Insert("Analog Right")
hotkeyLabels.Insert("X1")
hotkeyLabels.Insert("X2")
hotkeyLabels.Insert("Y1")
hotkeyLabels.Insert("Y2")
hotkeyLabels.Insert("L")
hotkeyLabels.Insert("Y")
hotkeyLabels.Insert("R")
hotkeyLabels.Insert("Lightshield")
hotkeyLabels.Insert("B")
hotkeyLabels.Insert("A")
hotkeyLabels.Insert("X")
hotkeyLabels.Insert("Z")
hotkeyLabels.Insert("C-stick Up")
hotkeyLabels.Insert("C-stick Left")
hotkeyLabels.Insert("C-stick Down")
hotkeyLabels.Insert("C-stick Right")
hotkeyLabels.Insert("Start")
hotkeyLabels.Insert("D-pad Up")
hotkeyLabels.Insert("D-pad Left")
hotkeyLabels.Insert("D-pad Down")
hotkeyLabels.Insert("D-pad Right")

Menu, Tray, Click, 1
;Menu, Tray, NoStandard
Menu, Tray, Add, Edit Controls, ShowGui
Menu, Tray, Default, Edit Controls

#ctrls = 25  ;Total number of Key's we will be binding (excluding UP's)?

for index, element in hotkeyLabels{
 Gui, Add, Text, xm vLB%index%, %element% Hotkey:
 IniRead, savedHK%index%, Hotkeys.ini, Hotkeys, %index%, %A_Space%
 If savedHK%index%                                       ;Check for saved hotkeys in INI file.
  Hotkey,% savedHK%index%, Label%index%                 ;Activate saved hotkeys if found.
  Hotkey,% savedHK%index% . " UP", Label%index%_UP                 ;Activate saved hotkeys if found.
  ;TrayTip, Smashbox, Label%index%_UP, 3, 0
  ;TrayTip, Smashbox, % savedHK%A_Index%, 3, 0
  ;TrayTip, Smashbox, % savedHK%index% . " UP", 3, 0
 checked := false
 if(!InStr(savedHK%index%, "~", false)){
  checked := true
 }
 StringReplace, noMods, savedHK%index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
 StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
 Gui, Add, Hotkey, x+5 vHK%index% gGuiLabel, %noMods%        ;Add hotkey controls and show saved hotkeys.
 if(!checked)
  Gui, Add, CheckBox, x+5 vCB%index% gGuiLabel, Prevent Default Behavior  ;Add checkboxes to allow the Windows key (#) as a modifier..
 else
  Gui, Add, CheckBox, x+5 vCB%index% Checked gGuiLabel, Prevent Default Behavior  ;Add checkboxes to allow the Windows key (#) as a modifier..
}                                                               ;Check the box if Win modifier is used.


;----------Start Hotkey Handling-----------

; Create an object from vJoy Interface Class.
vJoyInterface := new CvJoyInterface()

; Was vJoy installed and the DLL Loaded?
if (!vJoyInterface.vJoyEnabled()){
  ; Show log of what happened
  Msgbox % vJoyInterface.LoadLibraryLog
  ExitApp
}

myStick := vJoyInterface.Devices[1]

;Alert User that script has started
TrayTip, Smashbox, Script Started, 3, 0

; Stick variables
l := false
r := false
u := false
d := false

x1 := 0
x2 := 0
y1 := 0
y2 := 0

/* PM
v1x := 9088
v2x := 5120
v3x := 3712

v1y := 15000
v2y := 5120
v3y := 3712

v1yhigh := 9216
v2yhigh := 5248
v3yhigh := 3712

xlowstart := 3456
xhighstart := 29376

ylowstart := 3328
yhighstart := 29312
*/

/*
; Melee
l0 := 8000
l1 := 13800
l2 := 11000
l3 := 9300

r0 := 25150
r1 := 19150
r2 := 22000
r3 := 23800

u0 := 7900
u1 := 13800
u2 := 11230
u3 := 9200

d0 := 25300
d1 := 19200
d2 := 21820
d3 := 24000
*/

; alt Melee
l0 := 5400  ;42
l1 := 12900 ;101
l2 := 9300  ;73
l3 := 7000  ;55

r0 := 27600 ;215
r1 := 19900 ;155
r2 := 23500 ;183
r3 := 25800 ;201

u0 := 5300  ;214
u1 := 12900 ;154
u2 := 9600  ;180
u3 := 6900  ;201

d0 := 27600 ;40
d1 := 19900 ;100
d2 := 23200 ;74
d3 := 25900 ;53

; Gives stick input based on stick variables


stickx() {
  global
  if ((l and r) or ((not l) and (not r))) {
    myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(50),1)
  } 
  else if (l) {
    if (x1 and x2) {
      myStick.SetAxisByIndex(l3,1)
    }
    else if (x1) {
      myStick.SetAxisByIndex(l1,1)
    }
    else if (x2) {
      myStick.SetAxisByIndex(l2,1)
    }
    else {
      myStick.SetAxisByIndex(l0,1)
    }
  }
  else {
    if (x1 and x2) {
      myStick.SetAxisByIndex(r3,1)
    }
    else if (x1) {
      myStick.SetAxisByIndex(r1,1)
    }
    else if (x2) {
      myStick.SetAxisByIndex(r2,1)
    }
    else {
      myStick.SetAxisByIndex(r0,1)
    }
  }
  return
}



sticky() {
  global
  if ((u and d) or ((not u) and (not d))) {
    myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(50),2)
  } 
  else if (u) {
    if (y1 and y2) {
      myStick.SetAxisByIndex(u3,2) 
    }
    else if (y1) {
      myStick.SetAxisByIndex(u1,2) 
    }
    else if (y2) {
      myStick.SetAxisByIndex(u2,2) 
    }
    else {
      myStick.SetAxisByIndex(u0,2) 
    }
  }
  else {
    if (y1 and y2) {
      myStick.SetAxisByIndex(d3,2) ;53
    }
    else if (y1) {
      myStick.SetAxisByIndex(d1,2) ;100
    }
    else if (y2) {
      myStick.SetAxisByIndex(d2,2) ;74
    }
    else {
      myStick.SetAxisByIndex(d0,2) ;40 ;25250
    }
  }
  return
}

validateHK(GuiControl) {
 global lastHK
 Gui, Submit, NoHide
 lastHK := %GuiControl%                     ;Backup the hotkey, in case it needs to be reshown.
 num := SubStr(GuiControl,3)                ;Get the index number of the hotkey control.
 If (HK%num% != "") {                       ;If the hotkey is not blank...
  StringReplace, HK%num%, HK%num%, SC15D, AppsKey      ;Use friendlier names,
  StringReplace, HK%num%, HK%num%, SC154, PrintScreen  ;  instead of these scan codes.
  ;If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
   ;HK%num% := "#" HK%num%
  If (!CB%num% && !RegExMatch(HK%num%,"[#!\^\+]"))       ;  If the new hotkey has no modifiers, add the (~) modifier.
   HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
  checkDuplicateHK(num)
 }
 If (savedHK%num% || HK%num%)               ;Unless both are empty,
  setHK(num, savedHK%num%, HK%num%)         ;  update INI/GUI
}

checkDuplicateHK(num) {
 global #ctrls
 Loop,% #ctrls
  If (HK%num% = savedHK%A_Index%) {
   dup := A_Index
   TrayTip, Smashbox, Hotkey Already Taken, 3, 0
   Loop,6 {
    GuiControl,% "Disable" b:=!b, HK%dup%   ;Flash the original hotkey to alert the user.
    Sleep,200
   }
   GuiControl,,HK%num%,% HK%num% :=""       ;Delete the hotkey and clear the control.
   break
  }
}

setHK(num,INI,GUI) {
 If INI{                          ;If previous hotkey exists,
  Hotkey, %INI%, Label%num%, Off  ;  disable it.
  Hotkey, %INI% UP, Label%num%_UP, Off  ;  disable it.
}
 If GUI{                           ;If new hotkey exists,
  Hotkey, %GUI%, Label%num%, On   ;  enable it.
  Hotkey, %GUI% UP, Label%num%_UP, On   ;  enable it.
}
 IniWrite,% GUI ? GUI:null, Hotkeys.ini, Hotkeys, %num%
 savedHK%num%  := HK%num%
 ;TrayTip, Label%num%,% !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
 *AppsKey::                       ;Add support for these special keys,
 *BackSpace::                     ;  which the hotkey control does not normally allow.
 *Delete::
 *Enter::
 *Escape::
 *Pause::
 *PrintScreen::
 *Space::
 *Tab::
  modifier := ""
  If GetKeyState("Shift","P")
   modifier .= "+"
  If GetKeyState("Ctrl","P")
   modifier .= "^"
  If GetKeyState("Alt","P")
   modifier .= "!"
  Gui, Submit, NoHide             ;If BackSpace is the first key press, Gui has never been submitted.
  If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)   ;If the control has text but no modifiers held,
   GuiControl,,%ctrl%                                       ;  allow BackSpace to clear that text.
  Else                                                     ;Otherwise,
   GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2)  ;  show the hotkey.
  validateHK(ctrl)
 return
#If

HotkeyCtrlHasFocus() {
 GuiControlGet, ctrl, Focus       ;ClassNN
 If InStr(ctrl,"hotkey") {
  GuiControlGet, ctrl, FocusV     ;Associated variable
  Return, ctrl
 }
}


;----------------------------Labels

;Show GUI from tray Icon
ShowGui:
    Gui, show,, Dynamic Hotkeys
    GuiControl, Focus, LB1 ; this puts the windows "focus" on the checkbox, that way it isn't immediately waiting for input on the 1st input box
return

GuiLabel:
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
  return
 If InStr(%A_GuiControl%,"vk07")            ;vk07 = MenuMaskKey (see below)
  GuiControl,,%A_GuiControl%, % lastHK      ;Reshow the hotkey, because MenuMaskKey clears it.
 Else
  validateHK(A_GuiControl)
return

;-------macros

Pause::Suspend
^!r:: Reload
SetKeyDelay, 0
#MaxHotkeysPerInterval 200


;a::
; ListVars

;; KEYS
; m,.k op[] 90-\

^!s::
  Suspend
    If A_IsSuspended
        TrayTip, Smashbox, Hotkeys Disabled, 3, 0
    Else
        TrayTip, Smashbox, Hotkeys Enabled, 3, 0
  Return

Label9:
  myStick.SetBtn(1,1)
  Return

Label9_UP:
  myStick.SetBtn(0,1)
  Return

Label10:
  myStick.SetBtn(1,2)
  Return

Label10_UP:
  myStick.SetBtn(0,2)
  Return

Label11:
  myStick.SetBtn(1,3)
  Return

Label11_UP:
  myStick.SetBtn(0,3)
  Return

Label13:
  myStick.SetBtn(1,5)
  Return

Label13_UP:
  myStick.SetBtn(0,5)
  Return

Label14:
  myStick.SetBtn(1,6)
  Return

Label14_UP:
  myStick.SetBtn(0,6)
  Return

Label15:
  myStick.SetBtn(1,7)
  Return

Label15_UP:
  myStick.SetBtn(0,7)
  Return

Label16:
  myStick.SetBtn(1,8)
  Return

Label16_UP:
  myStick.SetBtn(0,8)
  Return

Label18:
  myStick.SetBtn(1,9)
  Return

Label18_UP:
  myStick.SetBtn(0,9)
  Return

Label19:
  myStick.SetBtn(1,10)
  Return

Label19_UP:
  myStick.SetBtn(0,10)
  Return

Label20:
  myStick.SetBtn(1,11)
  Return
;comma
Label20_UP:
  myStick.SetBtn(0,11)
  Return

Label17:
  myStick.SetBtn(1,12)
  Return

Label17_UP:
  myStick.SetBtn(0,12)
  Return

Label21:
  myStick.SetBtn(1,4)
  Return

Label21_UP:
  myStick.SetBtn(0,4)
  Return

Label22:
  myStick.SetBtn(1,13)
  Return

Label22_UP:
  myStick.SetBtn(0,13)
  Return

Label23:
  myStick.SetBtn(1,14)
  Return

Label23_UP:
  myStick.SetBtn(0,14)
  Return

Label24:
  myStick.SetBtn(1,15)
  Return

Label24_UP:
  myStick.SetBtn(0,15)
  Return

Label25:
  myStick.SetBtn(1,16)
  Return

Label25_UP:
  myStick.SetBtn(0,16)
  Return


; STICK
;2qwe dxcv


Label4:
  r := true
  stickx()
  return

Label4_UP:
  r := false
  stickx()
  return

Label2:
  l := true
  stickx()
  return

Label2_UP:
  l := false
  stickx()
  return

Label1:
  u := true
  sticky()
  return

Label1_UP:
  u := false
  sticky()
  return

Label3:
  d := true
  sticky()
  return
Label3_UP:
  d := false
  sticky()
  return

Label5:
  x1 := true
  stickx()
  return

Label5_UP:
  x1 := false
  stickx()
  return

Label6:
  x2 := true
  stickx()
  return

Label6_UP:
  x2 := false
  stickx()
  return

Label7:
  y1 := true
  sticky()
  return
Label7_UP:
  y1 := false
  sticky()
  return

Label8:
  y2 := true
  sticky()
  return
Label8_UP:
  y2 := false
  sticky()
  return

;; Lightshield

Label12:
  myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(59),3)
  Return

Label12_UP:
  myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(0),3)
  return

;----------------------------end macros

/*
TODO:
make suspend, refresh, and quit all be user-assignable hotkeys
make it so there is a way users can choose to disable certain keys (that they're not using in macros, but don't want to be in the way like DF said)
make a master button or checkbox that will check all / uncheck all of the checkboxes
*/
