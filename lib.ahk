; This file contains shared library files used both in my main scripts and HotkeylessAHK scripts.
#Requires AutoHotkey v2.0

isExplorerActive() {
    return !!WinActive("ahk_class CabinetWClass")
}

; isPremiereActive() {
;     return !!WinActive("ahk_exe Adobe Premiere Pro.exe")
; }

; isMinecraftActive() {
;     return !!WinActive("Minecraft* 1.") || !!WinActive("Minecraft 1.") || !!WinActive("FTB")
; }

getTrimmedExplorerWindowTitle() {
    if (isExplorerActive()) {
        title := WinGetTitle("ahk_class CabinetWClass")
        if (InStr(title, "weitere Registerkarten")) {
            return SubStr(title, 1, -1 * (40)) ; Remove "und n weitere Registerkarten"
        } else if (InStr(title, "weitere Registerkarte")) {
            return SubStr(title, 1, -1 * (39)) ; Remove "und 1 weitere Registerkarte"
        } else if (InStr(title, "Datei-Explorer")) {
            return SubStr(title, 1, -1 * (17)) ; Remove "- Datei-Explorer"
        } else {
            return title
        }
    } else {
        return ""
    }
}

getCurrentPath() {
    try {
        for window in ComObject("Shell.Application").Windows {
            if (window.HWND == WinGetID("A")) {
                return window.Document.Folder.Self.Path
            }
        }
    }
    return ""
}

; HAUPT-FUNKTION: CMD im aktuellen Explorer-Pfad
openTerminalInCurrentExplorerDirectory() {
    if (isExplorerActive()) {
        path := getCurrentPath()
        if (path != "" && DirExist(path)) {
            Run("cmd /k cd /d `"" . path . "`"")
            return
        }
    }
    ; Fallback: CMD auf C:\ starten
    Run("cmd /k cd /d C:\")
}

callExplorer() {
    if !WinExist("ahk_class CabinetWClass") {
        Run("explorer.exe")
    }

    GroupAdd("explorersgroup", "ahk_class CabinetWClass")
    try {
        if WinActive("ahk_exe explorer.exe")
            GroupActivate("explorersgroup", "r")
        else
            WinActivate("ahk_class CabinetWClass")
    }
    catch {
        ; ignore error
    }

}

getVSCodeExePath() {
    ; Hole LOCALAPPDATA über EnvGet (v2-Syntax)
    localAppData := EnvGet("LOCALAPPDATA")
    programFiles := EnvGet("PROGRAMFILES")
    programFilesX86 := EnvGet("PROGRAMFILES(X86)")
    userName := EnvGet("USERNAME")
    
    ; Mögliche VS Code-Pfade mit korrekten Variablen
    possiblePaths := [
        localAppData . "\Programs\Microsoft VS Code\Code.exe",
        programFiles . "\Microsoft VS Code\Code.exe",
        programFilesX86 . "\Microsoft VS Code\Code.exe",
        "C:\Users\" . userName . "\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    ]
    
    ; Prüfe welcher existiert
    for path in possiblePaths {
        if (FileExist(path)) {
            return path
        }
    }
    
    return ""  ; Nicht gefunden
}

; Korrigierte Funktion mit vollständigem VS Code-Pfad
openVSCodeInCurrentExplorerDirectory() {
    vscPath := getVSCodeExePath()
    
    if (vscPath == "") {
        MsgBox("VS Code nicht automatisch gefunden!`nVerwende die manuelle Version.")
        return
    }
    
    try {
        if (isExplorerActive()) {
            for window in ComObject("Shell.Application").Windows {
                if (window.HWND == WinGetID("A")) {
                    path := window.Document.Folder.Self.Path
                    if (path != "" && DirExist(path)) {
                        Run("`"" . vscPath . "`" `"" . path . "`"")
                        return
                    }
                }
            }
        }
        
        Run("`"" . vscPath . "`"")
    } catch Error as e {
        MsgBox("Fehler: " . e.Message)
    }
}

; Hauptfunktion: VS Code aktivieren/starten mit Tab-Wechsel
callVSCode() {
    try {
        ; Starte VS Code falls nicht läuft
        if (!WinExist("ahk_exe Code.exe")) {
            Run("code")
            return
        }
        
        ; VS Code läuft bereits
        if (WinActive("ahk_exe Code.exe")) {
            Send("^{PgDn}")  ; Nächster Tab
        } else {
            WinActivate("ahk_exe Code.exe")
        }
    } catch {
        Run("code")
    }
}

callVivaldi() {
    try {
        ; Prüfe ob Vivaldi läuft
        if (!ProcessExist("vivaldi.exe")) {
            Run("vivaldi.exe")
            WinWait("ahk_exe vivaldi.exe", , 10)
            return
        }
        
        if (WinExist("ahk_exe vivaldi.exe")) {
            if (WinActive("ahk_exe vivaldi.exe")) {
                ; Bereits aktiv -> neuer Tab
                Send("^t")
            } else {
                ; Nicht aktiv -> aktivieren
                WinActivate("ahk_exe vivaldi.exe")
            }
        }
    } catch {
        Run("vivaldi.exe")
    }
}

; switchActiveStreamDeckConfig() {
;     if (!WinActive("ahk_exe StreamDeck.exe")) {
;         return
;     }

;     ; Color of the "XL" in the Stream Deck name
;     coordX := 179
;     coordY := 43
;     color := PixelGetColor(coordX, coordY)

;     BlockInput("MouseMove")
;     MouseGetPos(&mouseX, &mouseY)

;     MouseClick("left", coordX, coordY, , 0)
;     Sleep(100)

;     if (color = "0xE6E6E6") {
;         ; Switch from XL to +
;         MouseClick("left", coordX, coordY + 40, , 0)
;     } else {
;         ; Switch from + to XL
;         MouseClick("left", coordX, coordY + 60, , 0)
;     }

;     MouseMove(mouseX, mouseY, 0)
;     BlockInput("MouseMoveOff")
; }

switchVSCodeWindowSize() {
    smallX := 1264
    smallY := 135
    smallWidth := 1537
    smallHeight := 1133
    largeX := 860
    largeY := 135
    largeWidth := 1941
    largeHeight := 1133

    WinGetPos(&x, &y, &width, &height, "ahk_exe Code.exe")
    if (x = smallX && y = smallY) {
        WinMove(largeX, largeY, largeWidth, largeHeight, "ahk_exe Code.exe")
    } else {
        WinMove(smallX, smallY, smallWidth, smallHeight, "ahk_exe Code.exe")
    }
}

; global chatWindowForegroundState := 0 ; 0 = Twitch, 1 = Chatterino
; switchForegroundChatWindow() {
;     global
;     twitchWindowName := "skate702 – Chat - Twitch"
;     otherWindowName := "Chatterino"

;     if (chatWindowForegroundState = 0) {
;         if (WinExist(twitchWindowName)) {
;             WinActivate(twitchWindowName)
;         }
;         chatWindowForegroundState := 1
;     } else {
;         if (WinExist(otherWindowName)) {
;             WinActivate(otherWindowName)
;         }
;         chatWindowForegroundState := 0
;     }
; }

; fancyZonesLayout(layout) {
;     CoordMode("Mouse", "Screen")
    
;     BlockInput("MouseMove")
;     MouseGetPos(&mouseX, &mouseY)

;     if (layout == "Standard") {
;         MouseMove(300, 300, 0)
;         Sleep(50)
;         Send("{Ctrl down}{LWin down}{Alt down}1")
;         Send("{Ctrl up}{LWin up}{Alt up}")
;         Sleep(300)
;         MouseMove(5000, 300, 0)
;         Sleep(50)
;         Send("{Ctrl down}{LWin down}{Alt down}2")
;         Send("{Ctrl up}{LWin up}{Alt up}")
;         Sleep(300)
;     } else if (layout == "Streaming") {
;         MouseMove(300, 300, 0)
;         Sleep(50)
;         Send("{Ctrl down}{LWin down}{Alt down}3")
;         Send("{Ctrl up}{LWin up}{Alt up}")
;         Sleep(300)
;         MouseMove(5000, 300, 0)
;         Sleep(50)
;         Send("{Ctrl down}{LWin down}{Alt down}4")
;         Send("{Ctrl up}{LWin up}{Alt up}")
;         Sleep(300)
;     }

;     MouseMove(mouseX, mouseY, 0)
;     BlockInput("MouseMoveOff")
; }
