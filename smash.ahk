; Simplest usage example.
; Minimal error checking (Just check if DLL loaded), just the bare essentials code-wise.

#SingleInstance, force
#include <CvJoyInterface>

; Create an object from vJoy Interface Class.
vJoyInterface := new CvJoyInterface()

; Was vJoy installed and the DLL Loaded?
if (!vJoyInterface.vJoyEnabled()){
	; Show log of what happened
	Msgbox % vJoyInterface.LoadLibraryLog
	ExitApp
}

myStick := vJoyInterface.Devices[1]


; End Startup Sequence
;Return

; Stick variables
l := false
r := false
u := false
d := false

x1 := 0
x2 := 0
y1 := 0
y2 := 0

v1 := 37
v2 := 33
v3 := 29

; Gives stick input based on stick variables

stick() {
	global
	if ((l and r) or ((not l) and (not r))) {
		myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(50),1)
	}	
	else if (l) {
		if (x1 > 0 and x2 > 0) {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(v3),1)
		}
		else {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(x1 + x2),1)
		}
	}
	else {
		if (x1 > 0 and x2 > 0) {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(100 - v3),1)
		}
		else {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(100 - x1 - x2),1)
		}
	}

	if ((u and d) or ((not u) and (not d))) {
		myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(50),2)
	}	
	else if (u) {
		if (y1 > 0 and y2 > 0) {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(v3),2)
		}
		else {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(0 + y1 + y2),2)
		}
	}
	else {
		if (y1 > 0 and y2 > 0) {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(100 - v3),2)
		}
		else {
			myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(100 - y1 - y2),2)
		}
	}
	return
}


Pause::Suspend
;r:: Reload
SetKeyDelay, 0
#MaxHotkeysPerInterval 200


;a::
;	ListVars

;; KEYS
; m,.k op[] 90-\


9::
	myStick.SetBtn(1,1)
	Return

9 up::
	myStick.SetBtn(0,1)
	Return

0::
	myStick.SetBtn(1,2)
	Return

0 up::
	myStick.SetBtn(0,2)
	Return

-::
	myStick.SetBtn(1,3)
	Return

- up::
	myStick.SetBtn(0,3)
	Return
/*
=::
	myStick.SetBtn(1,4)
	Return

= up::
	myStick.SetBtn(0,4)
	Return
*/
o::
	myStick.SetBtn(1,5)
	Return

o up::
	myStick.SetBtn(0,5)
	Return

p::
	myStick.SetBtn(1,6)
	Return

p up::
	myStick.SetBtn(0,6)
	Return

[::
	myStick.SetBtn(1,7)
	Return

[ up::
	myStick.SetBtn(0,7)
	Return

]::
	myStick.SetBtn(1,8)
	Return

] up::
	myStick.SetBtn(0,8)
	Return

n::
	myStick.SetBtn(1,9)
	Return

n up::
	myStick.SetBtn(0,9)
	Return

m::
	myStick.SetBtn(1,10)
	Return

m UP::
	myStick.SetBtn(0,10)
	Return

SC033::
	myStick.SetBtn(1,11)
	Return
;comma
SC033 up::
	myStick.SetBtn(0,11)
	Return

k::
	myStick.SetBtn(1,12)
	Return

k up::
	myStick.SetBtn(0,12)
	Return

F5::
	myStick.SetBtn(1,4)
	Return

F5 up::
	myStick.SetBtn(0,4)
	Return

Up::
	myStick.SetBtn(1,13)
	Return

Up up::
	myStick.SetBtn(0,13)
	Return

Left::
	myStick.SetBtn(1,14)
	Return

Left up::
	myStick.SetBtn(0,14)
	Return

Down::
	myStick.SetBtn(1,15)
	Return

Down up::
	myStick.SetBtn(0,15)
	Return

Right::
	myStick.SetBtn(1,16)
	Return

Right up::
	myStick.SetBtn(0,16)
	Return


; STICK
;2qwe dxcv


e::
	global r := true
	stick()
	return

e UP::
	global r := false
	stick()
	return

q::
	global l := true
	stick()
	return

q UP::
	global l := false
	stick()
	return

2::
	global u := true
	stick()
	return

2 UP::
	global u := false
	stick()
	return

w::
	global d := true
	stick()
	return
w UP::
	global d := false
	stick()
	return

x::
	global x1 := global v1
	stick()
	return
x UP::
	global x1 := 0
	stick()
	return

c::
	global x2 := global v2
	stick()
	return

c UP::
	global x2 := 0
	stick()
	return

d::
	global y1 := global v1
	stick()
	return
d UP::
	global y1 := 0
	stick()
	return

v::
	global y2 := global v2
	stick()
	return
v UP::
	global y2 := 0
	stick()
	return

;; Lightshield

=::
	myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(60),3)
	Return

= up::
	myStick.SetAxisByIndex(vJoyInterface.PercentTovJoy(0),3)
	Return
