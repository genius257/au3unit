#include <File.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <WinAPIShPath.au3>
#include <ProcessConstants.au3>
#include ".\Unit\assert.au3"

Global Const $FOREGROUND_BLUE =      0x0001
Global Const $FOREGROUND_GREEN =     0x0002
Global Const $FOREGROUND_RED =       0x0004
Global Const $FOREGROUND_INTENSITY = 0x0008
Global Const $BACKGROUND_BLUE =      0x0010
Global Const $BACKGROUND_GREEN =     0x0020
Global Const $BACKGROUND_RED =       0x0040
Global Const $BACKGROUND_INTENSITY = 0x0080

Global Enum $AU3UNIT_RESULT_PASSED = 0, $AU3UNIT_RESULT_FAILED, $AU3UNIT_RESULT_ERROR, $AU3UNIT_RESULT_SKIPPED, $AU3UNIT_RESULT_COUNT
Global $aResults[$AU3UNIT_RESULT_COUNT + 1]

$aFiles = _FileListToArrayRec(@WorkingDir, '*Test.au3', $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)
;_ArrayDisplay($aFiles)
;Exit

$aRet = DllCall("kernel32.dll", "hwnd", "GetStdHandle", "dword", -11)
;If @error Or (Not IsArray($aRet)) Or ($aRet[0] = -1) Then Return SetError(1, 0, False)
$hConsole = $aRet[0]

$tConsoleScreenBufferInfo = DllStructCreate("DWORD dwSize;DWORD dwCursorPosition;WORD wAttributes;DOUBLE srWindow;DWORD dwMaximumWindowSize;")
$aRet = DllCall("Kernel32.dll", "BOOL", "GetConsoleScreenBufferInfo", "PTR", $hConsole, "PTR", DllStructGetPtr($tConsoleScreenBufferInfo))

Global $output = ""

For $i = 1 To UBound($aFiles, 1)-1 Step +1
    $sFile = $aFiles[$i]

    $workingDir = _WinAPI_PathRemoveFileSpec($sFile)

    $iPID = Run(@ScriptDir & "\..\au3pm\autoit\AutoIt3.exe /ErrorStdOut " & '"' & $sFile & '"' & " external", $workingDir, @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD + $RUN_CREATE_NEW_CONSOLE)

    Global $hProcess
    If _WinAPI_GetVersion() >= 6.0 Then
        $hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, 0, $iPID)
    Else
        $hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION, 0, $iPID)
    EndIf
    ProcessWaitClose($iPID)
    $output &= StderrRead($iPID)
    $output &= StdoutRead($iPID) ; Capture any remaining output
    Global $exitCode = DllCall("kernel32.dll", "bool", "GetExitCodeProcess", "HANDLE", $hProcess, "dword*", -1)[2]
    _WinAPI_CloseHandle($hProcess)

    $aResults[$AU3UNIT_RESULT_COUNT] += 1

    Switch $exitCode
        Case 0
            $aResults[$AU3UNIT_RESULT_PASSED] += 1
            $aRet = DllCall("Kernel32.dll", "BOOL", "SetConsoleTextAttribute", "PTR", $hConsole, "DWORD", $tConsoleScreenBufferInfo.wAttributes)
            ConsoleWrite(".")
        Case $AU3UNIT_EXITCODE_FAIL
            $aResults[$AU3UNIT_RESULT_FAILED] += 1
            DllCall("Kernel32.dll", "BOOL", "SetConsoleTextAttribute", "PTR", $hConsole, "DWORD", BitOR($FOREGROUND_INTENSITY, $BACKGROUND_RED))
            ConsoleWrite("F")
        Case Else
            $aResults[$AU3UNIT_RESULT_ERROR] += 1
            DllCall("Kernel32.dll", "BOOL", "SetConsoleTextAttribute", "PTR", $hConsole, "DWORD", BitOR($FOREGROUND_INTENSITY, $BACKGROUND_GREEN, $BACKGROUND_RED))
            ConsoleWrite("E")
    EndSwitch

    ;ConsoleWrite($exitCode&@CRLF)
Next

DllCall("Kernel32.dll", "BOOL", "SetConsoleTextAttribute", "PTR", $hConsole, "DWORD", $tConsoleScreenBufferInfo.wAttributes)

ConsoleWrite(@CRLF)
ConsoleWrite($output&@CRLF)
ConsoleWrite(@CRLF)
ConsoleWrite(StringFormat("%i Total tests run.", $aResults[$AU3UNIT_RESULT_COUNT])&@CRLF)
ConsoleWrite(StringFormat("%i Passed - %i Failed - %i Errors", $aResults[$AU3UNIT_RESULT_PASSED], $aResults[$AU3UNIT_RESULT_FAILED], $aResults[$AU3UNIT_RESULT_ERROR])&@CRLF)
