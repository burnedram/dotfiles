Set WshShell = CreateObject("Wscript.shell")

If WScript.Arguments.length = 0 Then
    Set oShell = CreateObject("Shell.Application")
    oShell.ShellExecute Chr(34) & WshShell.ExpandEnvironmentStrings("%WinDir%") & "\System32\wscript.exe" & Chr(34), Chr(34) & WScript.ScriptFullName & Chr(34) & " elevated", "", "RunAs", 1
Else
    Set oStart = WshShell.CreateShortcut(WshShell.SpecialFolders("AllUsersPrograms") & "\terminal.lnk")
    oStart.WindowStyle = 4
    oStart.IconLocation = "%ProgramFiles%\wsl-terminal\open-wsl.exe,0"
    oStart.TargetPath = Chr(34) & "%WinDir%\System32\wscript.exe" & Chr(34)
    oStart.Arguments = Chr(34) & "%ProgramFiles%\wsl-terminal\WSLNew.vbs" & Chr(34)
    oStart.WorkingDirectory = Chr(34) & "%ProgramFiles%\wsl-terminal" & Chr(34)
    oStart.Save

    Set oTask = WshShell.CreateShortcut(WshShell.ExpandEnvironmentStrings("%AppData%") & "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\terminal.lnk")
    oTask.WindowStyle = 4
    oStart.IconLocation = "%ProgramFiles%\wsl-terminal\open-wsl.exe,0"
    oStart.TargetPath = Chr(34) & "%WinDir%\System32\wscript.exe" & Chr(34)
    oStart.Arguments = Chr(34) & "%ProgramFiles%\wsl-terminal\WSLNew.vbs" & Chr(34)
    oStart.WorkingDirectory = Chr(34) & "%ProgramFiles%\wsl-terminal" & Chr(34)
    oTask.Save
End If