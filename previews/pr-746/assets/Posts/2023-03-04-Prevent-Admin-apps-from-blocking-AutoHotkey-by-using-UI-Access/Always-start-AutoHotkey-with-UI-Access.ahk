; Ensure the script is running as Admin, as it must be admin to modify the registry.
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
	try
	{
		if A_IsCompiled
			Run *RunAs "%A_ScriptFullPath%" /restart
		else
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
	}
	ExitApp
}

; Use the UI Access executable as the default executable to run AHK scripts.
; This copies the command value used to run AHK scripts with UI Access to the default Open command value.
RegRead, UiAccessCommandKeyValue, HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\uiAccess\Command
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Open\Command,, %UiAccessCommandKeyValue%
