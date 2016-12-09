# smashbox-AHK

This is an autohotkey script that lets you set up your keyboard to act like the smashbox in dolphin. Since dolphin does not let you bind keys to specific joystick values, I wrote this script.

The script works by using autohotkey to read the keyboard inputs, then converts them into a virtual joystick called vjoy. Vjoy is then used to control the inputs in dolphin.

Personally I am in favor of legalizing the smashbox for competitive play. Hopefully this script can show people what the smashbox can and can't do.

I have no relation with Hitbox, I do like their products though and plan on buying the Smashbox. 

# Requirments
1. Windows. Autohotkey only works on windows. This script was tested on widows 10.
2. Ishurka v 4.3. Otherwise known as faster melee. Other dolphin versions might work, but I tested with dolphin version 5 and the control stick values work slightly differently. https://www.smashladder.com/download/dolphin/fm
3. A keyboard with high n-key rollover. This is how many keys can be pressed at the same time without errors. Most gaming and mechanical keyboards will allow at least 6 keys which should be enough for every advanced technique.
4. Autohotkey. This is a scripting language for remapping keyboard keys. Download the installer here: https://autohotkey.com/
5. Vjoy: a joystick emulator. Download and install here: https://sourceforge.net/projects/vjoystick/?source=typ_redirect
6. After installing vjoy, run configure vjoy (can be found by searching in the start menu) Set the number of buttons to 16 and hit apply.
7. AHK-CvJoyInterface: a library for linking Autohotkey and Vjoy. Download CvJoyInterface.ahk from https://github.com/evilC/AHK-CvJoyInterface Place CvJoyInterface.ahk inside the Lib folder where you installed autohotkey (for me C:\Program Files\AutoHotkey\Lib) You may have to make the Lib folder if it is not already there. 

# Setup
1. Place the smashbox.ini file inside your dolphin-folder-name\User\Config\Profiles\GCPad folder. 
2. In dolphin, open up controller config. Set player 1 to a standard controller, then hit configure. Under profile, select smashbox and hit load. After, Set device to vjoy. Then hit ok.
3. Run the smashbox-gui.ahk script. You should be able to do this by double clicking on the file after installing autohotkey.
4. If you want to pause the script, hit the pause key. If you want to exit the script, open up hidden icons, right click the green H and hit exit.
6. To change the controls, go to the task bar in the bottom right and either double click the green "A" icon, or right click and press "Show GUI".
7. Changes are automatically saved to Hotkeys.ini in the same directory and reflected in realtime.

# Default Controls
2qwe : up left down right

x : x1

c : x2

d : y1

v : y2

9 : L

0 : Y

dash : R

= : Lightshield

o : B

p : A

[ : X

] : Z

knm, : cstick up left down right

f5 : start

pause : pause and unpause script. Used if you want to type without exiting autohotkey.

To change controls, you have to edit the smash.ahk script. In the future I would like to make this easier.

# Useful Analog Inputs

down + side + y1 : Perfect wavedash, 18 degree firefox angle

down + shield + y2 : Shield drop

up + y1 + a : uptilt

side + x1 + b : neutral b in held direction
