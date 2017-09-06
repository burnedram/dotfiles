Set oShell = CreateObject("Shell.Application")
oShell.ShellExecute "C:\Windows\System32\bash.exe", "-c 'exec sleep 100000d'", , "Open", 0