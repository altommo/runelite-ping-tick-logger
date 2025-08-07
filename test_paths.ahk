; Test script to debug file paths
pingPath := A_UserProfile . "\.runelite\ping.txt"
tickPath := A_UserProfile . "\.runelite\tick.txt"

MsgBox, UserProfile: %A_UserProfile%
MsgBox, Ping Path: %pingPath%
MsgBox, Ping File Exists: % FileExist(pingPath) ? "YES" : "NO"

if FileExist(pingPath) {
    FileRead, pingData, %pingPath%
    MsgBox, Ping Data: %pingData%
} else {
    MsgBox, File not found at: %pingPath%
}
