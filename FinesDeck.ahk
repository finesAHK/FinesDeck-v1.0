#NoEnv
#SingleInstance Force
SetBatchLines, -1

ConfigDir := A_MyDocuments "\Fines Deck"
if !InStr(FileExist(ConfigDir), "D")
    FileCreateDir, %ConfigDir%

ConfigFile := ConfigDir "\settings.ini"
IniRead, CustomBrand, %ConfigFile%, Main, BrandName, FINES DECK

UiHtmlPath := A_Temp "\fines_deck_ui.html"
MicMuted := 0
SysMuted := 0
TimerRunning := 0
TimerSec := 300
FocusMuted := 0

Menu, Tray, NoStandard
Menu, Tray, Add, Показать / Скрыть панель (Alt + D), ToggleDeck
Menu, Tray, Add
Menu, Tray, Add, Выход, GuiClose

htmlCode =
( %
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<style>
    body {
        background-color: #121212;
        color: #ffffff;
        font-family: 'Segoe UI', sans-serif;
        margin: 0;
        padding: 16px;
        overflow: hidden;
        -ms-user-select: none;
        user-select: none;
        border: 1px solid #2e2e2e;
        box-sizing: border-box;
        height: 100vh;
    }
    .top-bar {
        height: 28px;
        margin-bottom: 14px;
        cursor: move;
    }
    .brand {
        float: left;
        font-size: 16px;
        font-weight: 900;
        letter-spacing: 1.5px;
        color: #87CEEB;
        text-shadow: 0 0 8px rgba(135, 206, 235, 0.5);
        line-height: 26px;
    }
    .top-btns {
        float: right;
    }
    .icon-btn {
        display: inline-block;
        width: 26px;
        height: 26px;
        line-height: 24px;
        text-align: center;
        background-color: #1e1e1e;
        border: 1px solid #3a3a3a;
        border-radius: 6px;
        color: #cccccc;
        font-size: 13px;
        font-weight: bold;
        cursor: pointer;
        margin-left: 5px;
    }
    .icon-btn:hover {
        border-color: #87CEEB;
        color: #87CEEB;
    }
    .grid {
        width: 348px;
        margin: 0 auto;
    }
    .pad {
        float: left;
        width: 108px;
        height: 92px;
        background-color: #191919;
        border: 2px solid #323232;
        border-radius: 10px;
        margin: 0 12px 12px 0;
        box-sizing: border-box;
        padding: 10px 6px;
        text-align: center;
        cursor: pointer;
        position: relative;
    }
    .pad:hover {
        border-color: #87CEEB;
        background-color: #202426;
    }
    .pad-last {
        margin-right: 0;
    }
    .pad-active {
        background-color: #87CEEB !important;
        border-color: #ffffff !important;
        color: #121212 !important;
    }
    .pad-danger {
        background-color: #3a1818 !important;
        border-color: #ff4444 !important;
        color: #ff6666 !important;
    }
    .pad-num {
        position: absolute;
        top: 5px;
        left: 8px;
        font-size: 10px;
        font-weight: bold;
        color: #666666;
    }
    .pad-active .pad-num { color: #121212; }
    .pad-icon {
        font-size: 20px;
        margin-top: 8px;
        margin-bottom: 6px;
    }
    .pad-title {
        font-size: 11px;
        font-weight: 800;
        line-height: 1.2;
    }
    .settings-panel {
        display: none;
        background-color: #181818;
        border: 1px solid #333333;
        border-radius: 8px;
        padding: 14px;
        margin-top: 10px;
    }
    .set-lbl {
        font-size: 12px;
        color: #87CEEB;
        font-weight: bold;
        margin-bottom: 8px;
    }
    .set-input {
        width: 100%;
        padding: 8px;
        background-color: #121212;
        border: 1px solid #444444;
        border-radius: 6px;
        color: #ffffff;
        font-size: 13px;
        font-weight: bold;
        box-sizing: border-box;
        margin-bottom: 12px;
        outline: none;
    }
    .set-input:focus { border-color: #87CEEB; }
    .save-btn {
        background-color: #87CEEB;
        color: #121212;
        padding: 7px 16px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 800;
        cursor: pointer;
        display: inline-block;
    }
</style>

<script>
    var newBrandName = "";

    function sendCmd(c) {
        document.title = "cmd:" + c;
    }
    function startDrag() {
        document.title = "cmd:drag";
    }
    function setBrand(name) {
        document.getElementById('brandTitle').innerHTML = name;
        document.getElementById('brandInput').value = name;
    }
    function toggleSettings() {
        var g = document.getElementById('mainGrid');
        var s = document.getElementById('setBox');
        if (s.style.display === 'block') {
            s.style.display = 'none';
            g.style.display = 'block';
        } else {
            g.style.display = 'none';
            s.style.display = 'block';
        }
    }
function saveBrand() {
    var val = document.getElementById('brandInput').value;
    document.title = "cmd:savebrand:" + val;
    toggleSettings();
}
    function setPadState(id, stateClass, titleText) {
        var el = document.getElementById(id);
        if (!el) return;
        el.className = el.className.replace(' pad-active', '').replace(' pad-danger', '');
        if (stateClass) el.className += ' ' + stateClass;
        if (titleText) document.getElementById(id + '_txt').innerHTML = titleText;
    }
</script>
</head>
<body>
    <div class="top-bar" onmousedown="startDrag()">
        <div id="brandTitle" class="brand">FINES DECK</div>
        <div class="top-btns" onmousedown="event.stopPropagation()">
            <span class="icon-btn" title="Настроить имя" onclick="toggleSettings()">⚙</span>
            <span class="icon-btn" title="Скрыть (Alt+D)" onclick="sendCmd('hide')">—</span>
        </div>
    </div>

    <div id="mainGrid" class="grid">
        <div id="pad1" class="pad" onclick="sendCmd('pad1')">
            <div class="pad-num">NUM 1</div>
            <div class="pad-icon">🎙️</div>
            <div id="pad1_txt" class="pad-title">Микрофон<br>ВКЛ</div>
        </div>
        <div id="pad2" class="pad" onclick="sendCmd('pad2')">
            <div class="pad-num">NUM 2</div>
            <div class="pad-icon">🔊</div>
            <div id="pad2_txt" class="pad-title">Звук ПК<br>ВКЛ</div>
        </div>
        <div id="pad3" class="pad pad-last" onclick="sendCmd('pad3')">
            <div class="pad-num">NUM 3</div>
            <div class="pad-icon">⏯️</div>
            <div id="pad3_txt" class="pad-title">Пауза /<br>Плей</div>
        </div>
        <div id="pad4" class="pad" onclick="sendCmd('pad4')">
            <div class="pad-num">NUM 4</div>
            <div class="pad-icon">🎲</div>
            <div id="pad4_txt" class="pad-title">Рандом<br>1 – 100</div>
        </div>
        <div id="pad5" class="pad" onclick="sendCmd('pad5')">
            <div class="pad-num">NUM 5</div>
            <div class="pad-icon">📸</div>
            <div id="pad5_txt" class="pad-title">Скриншот<br>области</div>
        </div>
        <div id="pad6" class="pad pad-last" onclick="sendCmd('pad6')">
            <div class="pad-num">NUM 6</div>
            <div class="pad-icon">⚡</div>
            <div id="pad6_txt" class="pad-title">Очистить<br>RAM</div>
        </div>

        <div id="pad7" class="pad" onclick="sendCmd('pad7')">
            <div class="pad-num">NUM 7</div>
            <div class="pad-icon">🖥️</div>
            <div id="pad7_txt" class="pad-title">Свернуть<br>все окна</div>
        </div>
        <div id="pad8" class="pad" onclick="sendCmd('pad8')">
            <div class="pad-num">NUM 8</div>
            <div class="pad-icon">⏱️</div>
            <div id="pad8_txt" class="pad-title">Таймер<br>05:00</div>
        </div>
        <div id="pad9" class="pad pad-last" onclick="sendCmd('pad9')">
            <div class="pad-num">NUM 9</div>
            <div class="pad-icon">🔕</div>
            <div id="pad9_txt" class="pad-title">Уведомл.<br>ВКЛ</div>
        </div>
    </div>

    <div id="setBox" class="settings-panel">
        <div class="set-lbl">Твоё имя / Название панели:</div>
        <input id="brandInput" class="set-input" type="text" maxlength="20" placeholder="Например: FINES DECK">
        <div class="save-btn" onclick="saveBrand()">Сохранить название</div>
    </div>
</body>
</html>
)

FileDelete, %UiHtmlPath%
FileAppend, %htmlCode%, %UiHtmlPath%, UTF-8

Gui, -DPIScale -Caption +AlwaysOnTop +ToolWindow
Gui, Color, 121212
Gui, Margin, 0, 0
Gui, Add, ActiveX, w380 h400 vWB, Shell.Explorer
WB.Silent := True
WB.Navigate(UiHtmlPath)
while WB.ReadyState != 4
    Sleep, 10

try WB.Document.parentWindow.setBrand(CustomBrand)

SetTimer, WatchDeckCmd, 60
Gui, Show, w380 h400 Center, FinesDeck
return

!d::
ToggleDeck:
    if WinExist("FinesDeck")
        Gui, Hide
    else {
        Gui, Show
        WinActivate, FinesDeck
    }
return

Numpad1::GoSub, ActionPad1
Numpad2::GoSub, ActionPad2
Numpad3::GoSub, ActionPad3
Numpad4::GoSub, ActionPad4
Numpad5::GoSub, ActionPad5
Numpad6::GoSub, ActionPad6
Numpad7::GoSub, ActionPad7
Numpad8::GoSub, ActionPad8
Numpad9::GoSub, ActionPad9

WatchDeckCmd:
    try {
        t := WB.Document.title
        if (t = "" || t = "about:blank")
            return
        if InStr(t, "cmd:") {
            cmd := SubStr(t, 5)
            WB.Document.title := ""

            if (cmd = "drag")
                PostMessage, 0xA1, 2,,, FinesDeck
            else if (cmd = "hide")
                Gui, Hide
            else if InStr(cmd, "savebrand:") {
                val := Trim(SubStr(cmd, 11))
                if (val = "")
                    val := "FINES DECK"
                CustomBrand := val
                IniWrite, %CustomBrand%, %ConfigFile%, Main, BrandName
                try WB.Document.parentWindow.setBrand(CustomBrand)
                SoundBeep, 1000, 90
            }
            else if (cmd = "pad1")
                GoSub, ActionPad1
            else if (cmd = "pad2")
                GoSub, ActionPad2
            else if (cmd = "pad3")
                GoSub, ActionPad3
            else if (cmd = "pad4")
                GoSub, ActionPad4
            else if (cmd = "pad5")
                GoSub, ActionPad5
            else if (cmd = "pad6")
                GoSub, ActionPad6
            else if (cmd = "pad7")
                GoSub, ActionPad7
            else if (cmd = "pad8")
                GoSub, ActionPad8
            else if (cmd = "pad9")
                GoSub, ActionPad9
        }
    }
return

ActionPad1:
    MicMuted := !MicMuted
    SoundSet, %MicMuted%, MICROPHONE, MUTE
    if (ErrorLevel) {
        Loop, 10 {
            SoundSet, %MicMuted%, MASTER, MUTE, %A_Index%
        }
    }
    if (MicMuted = 1) {
        try WB.Document.parentWindow.setPadState("pad1", "pad-danger", "Микрофон<br>ВЫКЛ (MUTE)")
        SoundBeep, 500, 120
    } else {
        try WB.Document.parentWindow.setPadState("pad1", "", "Микрофон<br>ВКЛ")
        SoundBeep, 1100, 90
    }
return

ActionPad2:
    SysMuted := !SysMuted
    SoundSet, %SysMuted%, MASTER, MUTE
    if (SysMuted = 1) {
        try WB.Document.parentWindow.setPadState("pad2", "pad-danger", "Звук ПК<br>ВЫКЛ (MUTE)")
    } else {
        try WB.Document.parentWindow.setPadState("pad2", "", "Звук ПК<br>ВКЛ")
        SoundBeep, 1100, 90
    }
return

ActionPad3:
    Send, {Media_Play_Pause}
    try WB.Document.parentWindow.setPadState("pad3", "pad-active", "Пауза /<br>Плей")
    Sleep, 180
    try WB.Document.parentWindow.setPadState("pad3", "", "Пауза /<br>Плей")
return

ActionPad4:
    ; Анимация прокрутки рулетки (12 шагов с замедлением)
    Loop, 12
    {
        Random, FakeNum, 1, 100
        try WB.Document.parentWindow.setPadState("pad4", "", "Крутим...<br><span style='font-size:15px;color:#87CEEB;'>" . FakeNum . "</span>")
        SoundBeep, % (600 + A_Index * 40), 25
        Sleep, % (30 + A_Index * 12)
    }
    Random, FinalNum, 1, 100
    Clipboard := FinalNum
    try WB.Document.parentWindow.setPadState("pad4", "pad-active", "Выпало:<br><span style='font-size:16px;'>" . FinalNum . "</span>")
    SoundBeep, 1250, 140
    Sleep, 3000
    try WB.Document.parentWindow.setPadState("pad4", "", "Рандом<br>1 – 100")
return

ActionPad5:
    Gui, Hide
    Sleep, 150
    Send, #+s
return

ActionPad6:
    try WB.Document.parentWindow.setPadState("pad6", "pad-active", "Очистка<br>RAM...")
    for process in ComObjGet("winmgmts:").ExecQuery("Select ProcessId from Win32_Process") {
        if (process.ProcessId > 4) {
            hProc := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "UInt", process.ProcessId)
            if (hProc) {
                DllCall("psapi.dll\EmptyWorkingSet", "UInt", hProc)
                DllCall("CloseHandle", "UInt", hProc)
            }
        }
    }
    SoundBeep, 1200, 100
    try WB.Document.parentWindow.setPadState("pad6", "", "RAM<br>Очищена!")
    Sleep, 900
    try WB.Document.parentWindow.setPadState("pad6", "", "Очистить<br>RAM")
return

ActionPad7:
    WinMinimizeAll
    SoundBeep, 900, 80
return

ActionPad8:
    if (TimerRunning = 0) {
        TimerRunning := 1
        TimerSec := 300
        SetTimer, TickStreamTimer, 1000
        try WB.Document.parentWindow.setPadState("pad8", "pad-active", "Запущено<br>05:00")
        SoundBeep, 1000, 90
    } else {
        TimerRunning := 0
        SetTimer, TickStreamTimer, Off
        try WB.Document.parentWindow.setPadState("pad8", "", "Таймер<br>05:00")
        SoundBeep, 600, 90
    }
return

TickStreamTimer:
    TimerSec--
    if (TimerSec <= 0) {
        TimerRunning := 0
        SetTimer, TickStreamTimer, Off
        try WB.Document.parentWindow.setPadState("pad8", "pad-danger", "Время<br>вышло!")
        SoundBeep, 1200, 200
        Sleep, 1500
        try WB.Document.parentWindow.setPadState("pad8", "", "Таймер<br>05:00")
        return
    }
    mins := Format("{:02}", TimerSec // 60)
    secs := Format("{:02}", Mod(TimerSec, 60))
    try WB.Document.parentWindow.setPadState("pad8", "pad-active", "Запущено<br>" . mins . ":" . secs)
return

ActionPad9:
    FocusMuted := !FocusMuted
    if (FocusMuted = 1) {
        RegWrite, REG_DWORD, HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings, NOC_GLOBAL_SETTING_TOASTS_ENABLED, 0
        RegWrite, REG_DWORD, HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications, ToastEnabled, 0
        try WB.Document.parentWindow.setPadState("pad9", "pad-danger", "Не беспок.<br>АКТИВЕН")
        SoundBeep, 500, 120
    } else {
        RegWrite, REG_DWORD, HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings, NOC_GLOBAL_SETTING_TOASTS_ENABLED, 1
        RegWrite, REG_DWORD, HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications, ToastEnabled, 1
        try WB.Document.parentWindow.setPadState("pad9", "", "Уведомл.<br>ВКЛ")
        SoundBeep, 1100, 90
    }
return

GuiClose:
    if (FocusMuted = 1) {
        RegWrite, REG_DWORD, HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings, NOC_GLOBAL_SETTING_TOASTS_ENABLED, 1
        RegWrite, REG_DWORD, HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications, ToastEnabled, 1
    }
    ExitApp