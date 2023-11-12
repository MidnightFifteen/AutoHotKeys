; autoexecute section:
MyGui := GUI "-Caption"
MyGui.Add("ListBox", "vMyListBox r50 w200")


; autoexecute section:
Gui, -Caption
Gui, Add, ListBox, vMyListBox r50 w200
Loop, Read, %A_ScriptFullpath%
{
	If !InStr(A_LoopReadLine, ":: `;")
		continue	
	StringReplace, ReadLine, A_LoopReadLine, %A_Space%`;, %A_Tab%
	GuiControl,, MyListBox, %ReadLine%
}
; ...
return  ; end of autoexecute section

; Hotkey to show|hide the GUI:
F2:: ; Gui hotkeys
If (toggle := !toggle)
    Gui, Show, x0 y0
else
    Gui, cancel
return