#SingleInstance Force
SetTitleMatchMode 2
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global TrackerName:="Armored Warfare PvE Mission Rotation Tracker"
global TrackerVersion:="v2.3"

If Not (InStr(FileExist(config), "D"))
	FileCreateDir, config

IfNotExist, config\cfg.ini
{
	IniWrite, 0, config\cfg.ini, Timer Offset, OffsetMinVar
	IniWrite, 0, config\cfg.ini, Timer Offset, OffsetSecVar
	IniWrite, 0, config\cfg.ini, Window Position, xPos
	IniWrite, 0, config\cfg.ini, Window Position, yPos
}

;Controls timer offset
Global OffsetMinVar := 0
IniRead, OffsetMinVar, config\cfg.ini, Timer Offset, OffsetMinVar,
Global OffsetSecVar := 0
IniRead, OffsetSecVar, config\cfg.ini, Timer Offset, OffsetSecVar,

;Global OpacityVar:=255 ;Controls window opacity

MissionList=
IfNotExist config/Missions.txt
{
	FileAppend, Albatross`nAnvil`nBanshee`nBasilisk`nCavalry`nCerberus`nDire Wolf, config/Missions.txt
	FileAppend,`nErebos`nFrostbite`nGhost Hunter`nHarbinger`nHydra`nKodiak`nLeviathan, config/Missions.txt
	FileAppend,`nLife Jacket`nMeltdown`nOnyx`nPerseus, config/Missions.txt
	FileAppend,`nPhalanx`nPrometheus`nQuarterback`nRaiding Party`nRed Opossum`nRicochet, config/Missions.txt
	FileAppend,`nRolling Thunder`nSapphire`nScorpio`nSnake Bite`nSpearhead, config/Missions.txt
	FileAppend,`nStarry Night`nStormy Winter`nTiger Claw`nTsunami`nUmbrella, config/Missions.txt
	FileAppend,`nWatchdog`nWildfire`nZero Hour, config/Missions.txt
}
Loop, Read, config/Missions.txt	;Missions.txt contains a list of all missions separated by newlines
	MissionList=%MissionList%%A_LoopReadLine%|

;Menu items

;Menu, EditMenu, Add, &Set Opacity, SetOpacityButton
;Menu, EditMenu, Add, &Toggle Overlay Mode, OverlayButton
Menu, EditMenu, Add, &Clear All Missions, ClearList

Menu, HelpMenu, Add, &Help, HelpButton
Menu, HelpMenu, Add, &About, AboutButton

Menu, MenuBar, Add, &Edit, :EditMenu
Menu, MenuBar, Add, &Help, :HelpMenu

Gui, Menu, MenuBar

;Menu end

Gui, Font, s10
yVar:=4
newTime := A_Hour * 60 + A_Min - OffsetMinVar + 150
Transform, rVar, Mod, %newTime%, 30

;Headers
HEADER_LOW_EASY := "T1-3 Standard"
;HEADER_LOW_HARD := "T1-3 Hardcore"
HEADER_MID_EASY := "T4-6 Standard"
HEADER_MID_HARD := "T3-6 Hardcore"
HEADER_HIGH_EASY := "T7-10 Standard"
HEADER_HIGH_HARD := "T7-10 Hardcore"

Gui, Add, ComboBox, vHeader1 W120 X5 Y%yVar%, %HEADER_LOW_EASY%||
;Gui, Add, ComboBox, vHeader2 W120 X128 Y%yVar%, %HEADER_LOW_HARD%||
Gui, Add, ComboBox, vHeader3 W120 X128 Y%yVar%, %HEADER_MID_EASY%||
Gui, Add, ComboBox, vHeader4 W120 X250 Y%yVar%, %HEADER_MID_HARD%||
Gui, Add, ComboBox, vHeader5 W120 X372 Y%yVar%, %HEADER_HIGH_EASY%||
Gui, Add, ComboBox, vHeader6 W120 X494 Y%yVar%, %HEADER_HIGH_HARD%||
;Lock lists button
Gui, Add, Checkbox, vLockMaps gCheckLockMaps X617 Y%yVar%, Lock lists

yVar+=27

;Populate and read from rotation lists
Loop 10 {
	Gui, Add, ComboBox, vLOW_EASY%A_Index% W120 X5 Y%yVar% gSaveList R50, %MissionList%
	IniRead, TempVar, config/rotation_lists.ini, T1-3 Standard, %A_Index%, %A_Space%
	GuiControl, ChooseString, LOW_EASY%A_Index%, %TempVar%
	
	/*
	Gui, Add, ComboBox, vLOW_HARD%A_Index% W120 X128 Y%yVar% gSaveList R50, %MissionList%
	IniRead, TempVar, config/rotation_lists.ini, T1-3 Hardcore, %A_Index%, %A_Space%
	GuiControl, ChooseString, LOW_HARD%A_Index%, %TempVar%	
	*/
	
	Gui, Add, ComboBox, vMID_EASY%A_Index% W120 X128 Y%yVar% gSaveList R50, %MissionList%
	IniRead, TempVar, config/rotation_lists.ini, T4-6 Standard, %A_Index%, %A_Space%
	GuiControl, ChooseString, MID_EASY%A_Index%, %TempVar%
	
	Gui, Add, ComboBox, vMID_HARD%A_Index% W120 X250 Y%yVar% gSaveList R50, %MissionList%
	IniRead, TempVar, config/rotation_lists.ini, T3-6 Hardcore, %A_Index%, %A_Space%
	GuiControl, ChooseString, MID_HARD%A_Index%, %TempVar%
	
	Gui, Add, ComboBox, vHIGH_EASY%A_Index% W120 X372 Y%yVar% gSaveList R50, %MissionList%
	IniRead, TempVar, config/rotation_lists.ini, T7-10 Standard, %A_Index%, %A_Space%
	GuiControl, ChooseString, HIGH_EASY%A_Index%, %TempVar%
	
	Gui, Add, ComboBox, vHIGH_HARD%A_Index% W120 X494 Y%yVar% gSaveList R50, %MissionList%
	IniRead, TempVar, config/rotation_lists.ini, T7-10 Hardcore, %A_Index%, %A_Space%
	GuiControl, ChooseString, HIGH_HARD%A_Index%, %TempVar%
	
	yVar+=3
	Gui, Add, Text, vCD%A_Index% X617 Y%yVar% W100, 00:00

	yVar+=20
}

;Timer offset stuff
yVar+=2
Gui, Add, Edit, X5 W45 vMinBox Y%yVar% Number, %OffsetMinVar%
Gui, Add, UpDown, Range-6-6 gSetTimeOffset Wrap, %OffsetMinVar%
Gui, Add, Edit, X51 W45 vSecBox Y%yVar% Number, %OffsetSecVar%
Gui, Add, UpDown, Range0-59 gSetTimeOffset Wrap, %OffsetSecVar%
yVar--
Gui, Add, Button, X98 W160 H25 Y%yVar% gSetTimeOffset, Set Time Offset (Min/Sec)

;Let slip the dogs of war
IniRead, xPos, config\cfg.ini, Window Position, xPos, 0
IniRead, yPos, config\cfg.ini, Window Position, yPos, 0
Gui, Show, W700 H290 X%xPos% Y%yPos%, %TrackerName%
GoSub EverySecond
SetTimer EverySecond, 1000
return

;Subroutines

EverySecond:
newTime := A_Hour * 3600 + A_Min * 60 + A_Sec - OffsetMinVar * 60 - OffsetSecVar + 9000
Loop 10 {
	newTime -= 180
	Transform, rVar, Mod, %newTime%, 1800
	cVar:=1800-rVar
	if(cVar < 180){
		mVar:=AZ(floor(cVar/60))
		sVar:=AZ(mod(cVar,60))
		Gui, Font, cRed
		GuiControl, Text, CD%A_Index%, %mVar%:%sVar% - Active
		GuiControl, Font, CD%A_Index%
	}
	else{
		cVar -= 180
		nextTime =
		nextTime += %cVar%, seconds
		FormatTime, nextTime, %nextTime%, HH:mm
		mVar:=AZ(floor(cVar/60))
		sVar:=AZ(mod(cVar,60))
		Gui, Font, cBlack
		GuiControl, Text, CD%A_Index%, %mVar%:%sVar% - %nextTime%
		GuiControl, Font, CD%A_Index%
	}
}
return

AZ(x){
	return SubStr( "0" x, -1)
}

SaveList:
	Loop 10 {
		GuiControlGet TempVar,, LOW_EASY%A_Index%
		IniWrite, %TempVar%, config/rotation_lists.ini, T1-3 Standard, %A_Index%
		;GuiControlGet TempVar,, LOW_HARD%A_Index%
		;IniWrite, %TempVar%, config/rotation_lists.ini, T1-3 Hardcore, %A_Index%
		GuiControlGet TempVar,, MID_EASY%A_Index%
		IniWrite, %TempVar%, config/rotation_lists.ini, T4-6 Standard, %A_Index%
		GuiControlGet TempVar,, MID_HARD%A_Index%
		IniWrite, %TempVar%, config/rotation_lists.ini, T3-6 Hardcore, %A_Index%
		GuiControlGet TempVar,, HIGH_EASY%A_Index%
		IniWrite, %TempVar%, config/rotation_lists.ini, T7-10 Standard, %A_Index%
		GuiControlGet TempVar,, HIGH_HARD%A_Index%
		IniWrite, %TempVar%, config/rotation_lists.ini, T7-10 Hardcore, %A_Index%
	}
return

ClearList:
	GuiControlGet, LockMaps
	if(LockMaps)
	{
		MsgBox Maps are locked! Unlock maps to clear maps!

	}
	else
	{
		MsgBox, 4,, Are you sure you want to clear all missions?
		IfMsgBox Yes
			Loop 10	{
				GuiControl, Choose, LOW_EASY%A_Index%, 0
				;GuiControl, Choose, LOW_HARD%A_Index%, 0
				GuiControl, Choose, MID_EASY%A_Index%, 0
				GuiControl, Choose, MID_HARD%A_Index%, 0
				GuiControl, Choose, HIGH_EASY%A_Index%, 0
				GuiControl, Choose, HIGH_HARD%A_Index%, 0
			}
	}
return

SetTimeOffset:
	GuiControlGet OffsetMinVar,, MinBox
	GuiControlGet OffsetSecVar,, SecBox
	if(OffsetMinVar > 29)
	{
		Transform, OffsetMinVar, Mod, %OffsetMinVar%, 30
		GuiControl,,MinBox,%OffsetMinVar%
	}
	if(OffsetSecVar > 59)
	{
		Transform, OffsetSecVar, Mod, %OffsetSecVar%, 60
		GuiControl,,SecBox,%OffsetSecVar%
	}
	IniWrite, %OffsetMinVar%, config\cfg.ini, Timer Offset, OffsetMinVar
	IniWrite, %OffsetSecVar%, config\cfg.ini, Timer Offset, OffsetSecVar
return

;OverlayButton:
;return

/*
SetOpacityButton:
	InputBox, OpacityVar, Set Opacity, Please input an opacity value (150-255):
	if(OpacityVar < 150)
	{
		OpacityVar:=150
	}
	else if(OpacityVar > 255)
	{
		OpacityVar:=255
	}

	if !ErrorLevel
		GoSub, SetOpacity

return

SetOpacity:
	if(OpacityVar < 150) ;extra sanity check
	{
		OpacityVar:=150
	}
	else if(OpacityVar > 255)
	{
		OpacityVar:=255
	}
;	if(OpacityVar > 150) and (OpacityVar <= 255) ;Final sanity check
;	{
;		GuiControl,, OpacityBox, %OpacityVar%
;		WinSet, Transparent, %OpacityVar%, %TrackerName%
;	}
	GuiControl,, OpacityBox, %OpacityVar%
	WinSet, Transparent, %OpacityVar%, %TrackerName%
return

*/

CheckLockMaps:
	GuiControlGet, LockMaps
	if(LockMaps)
	{
		Loop 10 {
			GuiControl, Disable, LOW_EASY%A_Index%
			;GuiControl, Disable, LOW_HARD%A_Index%
			GuiControl, Disable, MID_EASY%A_Index%
			GuiControl, Disable, MID_HARD%A_Index%
			GuiControl, Disable, HIGH_EASY%A_Index%
			GuiControl, Disable, HIGH_HARD%A_Index%
		}
	}
	else
	{
		Loop 10 {
			GuiControl, Enable, LOW_EASY%A_Index%
			;GuiControl, Enable, LOW_HARD%A_Index%
			GuiControl, Enable, MID_EASY%A_Index%
			GuiControl, Enable, MID_HARD%A_Index%
			GuiControl, Enable, HIGH_EASY%A_Index%
			GuiControl, Enable, HIGH_HARD%A_Index%
		}
	}
return

HelpButton:
	MessageText=Use the drop-down lists to select the missions that are currently active.
	MessageText=%MessageText%`nYou can also type anything in the list boxes if you so desire.
	MessageText=%MessageText%`nAny changes made to the drop-down lists are automatically saved.
	MessageText=%MessageText%`nUse the "Lock lists" checkbox to lock or unlock the lists.
	MessageText=%MessageText%`n`nYou can use "Clear All Missions" under Edit when the map rotation
	MessageText=%MessageText%`nchanges to clear all existing rotation lists.
	MessageText=%MessageText%`n`nTo adjust the time to match the mission deadline timer:
	MessageText=%MessageText%`n1) Enter a minute value in the 1st bottom left input text box
	MessageText=%MessageText%`n2) Enter a second value in the 2nd bottom left input text box
	MessageText=%MessageText%`n3) Press the "Set Time Offset" button
	MessageText=%MessageText%`n`nEdit the Missions.txt file in the config directory to add new missions.
	MsgBox,,Help, %MessageText%
return

AboutButton:
	MessageText=%TrackerName% %TrackerVersion%
	MessageText=%MessageText%`n© 2016-2019 Wiser Guy
	MessageText=%MessageText%`n© 2019 Haswell (Kasuobes)
	MessageText=%MessageText%`n`nContributors & Supporters:
	MessageText=%MessageText%`ngrassman66
	MessageText=%MessageText%`nTheHawkGer
	MessageText=%MessageText%`nXJDHDR
	MessageText=%MessageText%`n`nThis program is free software: you can redistribute it and/or modify
	MessageText=%MessageText%`nit under the terms of the GNU General Public License as published by
	MessageText=%MessageText%`nthe Free Software Foundation, either version 3 of the License, or
	MessageText=%MessageText%`n(at your option) any later version.
	MessageText=%MessageText%`n`nThis program is distributed in the hope that it will be useful, but
	MessageText=%MessageText%`nWITHOUT ANY WARRANTY; without even the implied warranty of
	MessageText=%MessageText%`nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	MessageText=%MessageText%`nGNU General Public License for more details.
	MessageText=%MessageText%`n`nYou should have received a copy of the GNU General Public License
	MessageText=%MessageText%`nalong with this program.  If not, see <https://www.gnu.org/licenses/>.
	MsgBox,,About, %MessageText%
return

GuiClose:
	WinGetPos, tx, ty,,,%TrackerName%
	IniWrite, %tx%, config\cfg.ini, Window Position, xPos
	IniWrite, %ty%, config\cfg.ini, Window Position, yPos
ExitApp