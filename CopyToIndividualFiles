
; The {1} is replaced with the name of the method.
Path := A_ScriptDir '\single_files\Array_{1}.ahk'
if MsgBox('This script will overwrite existing files. Click OK to continue') == 'Cancel'
    ExitApp()

Content := FileRead('Array.ahk')
Pattern := 's)(?<=[\r\n])Array.Prototype.DefineProp\(`'(?<name>[^`']+).+?/\*\*.+?\*/.+?\R\}'

Str := '
(
/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-Array/edit/main/Array.ahk
    Author: Nich-Cebolla
    Version: 1.0.0
    License: MIT
*/
)'


Result := []
while Pos := RegExMatch(Content, Pattern, &Match, Pos ?? 1) {
    Result.Push(Match)
    Pos := Match.Pos + Match.Len
}

for Match in Result {
    f := FileOpen(Format(Path, Match['name']), 'w')
    f.Write(Str '`n`n' Match[0] '`n')
    f.Close()
}
