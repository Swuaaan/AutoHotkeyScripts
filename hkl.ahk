; This file contains all functions I use with HotkeylessAHK.
; It relies on the shared library file "lib.ahk" to work properly.
#Include "lib.ahk"

; This class contains all functions for normal desktop use
class DesktopFunctions {

    KillOrOpenDiscord() {
        if WinExist("ahk_exe Discord.exe") {
            ProcessClose("Discord.exe")
            CoordMode("Mouse", "Screen")
            BlockInput("MouseMove")
            MouseGetPos(&mouseX, &mouseY)
            MouseMove(2630, 1415, 0)
            MouseMove(3350, 1415, 30)
            MouseMove(mouseX, mouseY, 0)
            BlockInput("MouseMoveOff")
        } else {
            Run("C:\Users\Sebastian\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk")
        }
    }

    ; OpenAndMoveCuttingFolder() {
    ;     Run("explorer.exe E:\cutting")
    ;     Sleep(1000)
    ;     hWnd := WinExist("E:\cutting")
    ;     WinMove(3433, 247, 974, 1087, "ahk_id " hwnd)
    ; }

    ; OpenAndMoveCamFolder() {
    ;     Run("explorer.exe K:\cam")
    ;     Sleep(1000)
    ;     hWnd := WinExist("K:\cam")
    ;     WinMove(4393, 247, 974, 1087, "ahk_id " hwnd)
    ; }

    ; RunCompress() {
    ;     title := getTrimmedExplorerWindowTitle()
    ;     Run("D:\Dokumente\WindowsMods\crf24_hevc.bat /E:ON `"" title "`" /E:ON", "`"" title "`"")
    ; }

    RunVSCodeInCurrentFolder() {
        openVSCodeInCurrentExplorerDirectory()
    }

    SwitchVSCodeWindowSize() {
        switchVSCodeWindowSize()
    }

    ; SwitchForegroundChatWindow() {
    ;     switchForegroundChatWindow()
    ; }

    ; OpenNotionDashboard() {
    ;     Run("notion://Dashboard-1731742e7e8380f4a2abd2ff29b5d9b8")
    ; }

    ; FancyZonesStandardLayout() {
    ;     fancyZonesLayout("Standard")
    ; }

    ; FancyZonesStreamingLayout() {
    ;     fancyZonesLayout("Streaming")
    ; }
    
}

