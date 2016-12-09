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

v1x := 9088
v2x := 5120
v3x := 3712

v1y := 9088
v2y := 5120
v3y := 3712

v1yhigh := 9216
v2yhigh := 5248
v3yhigh := 3712

xlowstart := 3456
xhighstart := 29376

ylowstart := 3328
yhighstart := 29312

; Gives stick input based on stick variables

stick() {
  global
  if ((l and r) or ((not l) and (not r))) {
    myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(50),1)
  } 
  else if (l) {
    if (x1 > 0 and x2 > 0) {
      myStick.SetAxisByIndex(xlowstart + v3x,1)
    }
    else {
      myStick.SetAxisByIndex(xlowstart + x1 + x2,1)
    }
  }
  else {
    if (x1 > 0 and x2 > 0) {
      myStick.SetAxisByIndex(xhighstart - v3x,1)
    }
    else {
      myStick.SetAxisByIndex(xhighstart - x1 - x2,1)
    }
  }

  if ((u and d) or ((not u) and (not d))) {
    myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(50),2)
  } 
  else if (u) {
    if (y1 > 0 and y2 > 0) {
      myStick.SetAxisByIndex(ylowstart + v3y,2)
    }
    else {
      if(y1 > 0)
        y1 := v1y
      if(y2 > 0)
        y2 := v2y
      myStick.SetAxisByIndex(ylowstart + y1 + y2,2)
    }
  }
  else {
    if (y1 > 0 and y2 > 0) {
      myStick.SetAxisByIndex(yhighstart - v3y,2)
    }
    else {
      ;For whatever reason y1 and y2 were off by 1 dolphin unit for the down direction, so we adjust here
      if(y1 > 0)
        y1 := v1yhigh
      if(y2 > 0)
        y2 := v2yhigh
      myStick.SetAxisByIndex(yhighstart - y1 - y2,2)
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
  global r := true
  stick()
  return

Label4_UP:
  global r := false
  stick()
  return

Label2:
  global l := true
  stick()
  return

Label2_UP:
  global l := false
  stick()
  return

Label1:
  global u := true
  stick()
  return

Label1_UP:
  global u := false
  stick()
  return

Label3:
  global d := true
  stick()
  return
Label3_UP:
  global d := false
  stick()
  return

Label5:
  global x1 := global v1x
  stick()
  return

Label5_UP:
  global x1 := 0
  stick()
  return

Label6:
  global x2 := global v2x
  stick()
  return

Label6_UP:
  global x2 := 0
  stick()
  return

Label7:
  global y1 := global v1y
  stick()
  return
Label7_UP:
  global y1 := 0
  stick()
  return

Label8:
  global y2 := global v2y
  stick()
  return
Label8_UP:
  global y2 := 0
  stick()
  return

;; Lightshield

Label12:
  myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(60),3)
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
