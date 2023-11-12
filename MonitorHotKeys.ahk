; AHK v2
ControlMyMonitorExe := '"' . A_Desktop . '\[螢幕]ControlMyMonitor\ControlMyMonitor.exe"'
MonitorName := "\\.\DISPLAY1\Monitor0"

DisplayFusionExe := '"' . A_ProgramFiles . '\DisplayFusion\DisplayFusionCommand.exe"'

#HotIf GetKeyState("Alt", "P")
S & 1::
{
	; alt+s+1: 切換訊號源-DP(電腦/主要)
	Run ControlMyMonitorExe . ' /SetValue ' . MonitorName . ' 60 15'
}
S & 2::
{
	; alt+s+2: 切換訊號源-HDMI
	Run ControlMyMonitorExe . ' /SetValue ' . MonitorName . ' 60 17'
}

A & 1::
{
	; alt+a+1: 切換顯示模式-預設模式 (文書)
	Run ControlMyMonitorExe . ' /SetValue ' . MonitorName . ' DC 0'
}

A & 2::
{
	; alt+a+2: 切換顯示模式-自訂模式2 (娛樂)
	Run ControlMyMonitorExe . ' /SetValue ' . MonitorName . ' DC 15'
}

X & E::
{
	; alt+x+e: 順時針旋轉螢幕
	ChangeScreenOrientation("Clockwise")
}
X & Q::
{
	; alt+x+e: 逆時針旋轉螢幕
	ChangeScreenOrientation("CounterClockwise")
}

ChangeScreenOrientation(Orientation:='Landscape', MonNumber:=1) {
	; code from https://www.autohotkey.com/boards/viewtopic.php?p=525211#p525211
    static DMDO_DEFAULT := 0, DMDO_90 := 1, DMDO_180 := 2, DMDO_270 := 3, dmSize := 220
    NumPut('Short', dmSize, DEVMODE := Buffer(dmSize, 0), 68)
    display := '\\.\DISPLAY' MonNumber
    DllCall('EnumDisplaySettings', 'Str', display, 'Int', -1, 'Ptr', DEVMODE)
    n0 := NumGet(DEVMODE, 172, 'UInt')
    n1 := NumGet(DEVMODE, 176, 'UInt')
    b := n0 < n1
    dimension1 := n% b% | n%!b% << 32
    dimension2 := n%!b% | n% b% << 32
    currentOrientation := NumGet(DEVMODE, 84, 'Int')
    switch Orientation, false {
        case 'Clockwise':
            Orientation := (--currentOrientation) < DMDO_DEFAULT ? DMDO_270 : currentOrientation
            i := (Orientation&1) + 1
        case 'CClockwise', 'CounterClockwise':
            Orientation := (++currentOrientation) > DMDO_270 ? DMDO_DEFAULT : currentOrientation
            i := (Orientation&1) + 1
        case 'Landscape'          ,   0: i := 1, orientation := DMDO_DEFAULT
        case 'Portrait'           ,  90: i := 2, orientation := DMDO_90
        case 'Landscape (flipped)', 180: i := 1, orientation := DMDO_180
        case 'Portrait (flipped)' , 270: i := 2, orientation := DMDO_270
        default:                         i := 1, orientation := DMDO_DEFAULT
    }
    NumPut('Int'  , orientation , DEVMODE,  84)
    NumPut('Int64', dimension%i%, DEVMODE, 172)
    DllCall('ChangeDisplaySettingsEx', 'Str', display, 'Ptr', DEVMODE, 'Ptr', 0, 'Int', 0, 'Int', 0)
}

#HotIf
!W::
{
	; alt+w: 將主要視窗恢復成Landscape模式的大小
	;MsgBox DisplayFusionExe . ' -windowpositionprofileload "Landscape"'
	Run DisplayFusionExe . ' -windowpositionprofileload "Landscape"'
}