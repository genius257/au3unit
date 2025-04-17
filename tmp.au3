Global $a[]
$a['a'] = 1
$a['b'] = 2

For $x In MapKeys($a)
    consolewrite($x&@crlf)
Next

Exit

#include <WinAPIHObj.au3>
#include <WinAPI.au3>
ConsoleWrite("hello"&@CRLF)
;FileWrite(_WinAPI_GetStdHandle(1), "hello"&@CRLF)
ConsoleWrite(_WinAPI_WriteConsole(_WinAPI_GetStdHandle(1), "hello"&@CRLF)&@crlf)
Exit 1

#include <Array.au3>
#include "au3pm\StringRegExpSplit\StringRegExpSplit.au3"

;$aResult = StringRegExpSplit("resource(1) of type (Ptr)", "(.*\R)", 0, BitOR($PREG_SPLIT_DELIM_CAPTURE, $PREG_SPLIT_NO_EMPTY))
;_ArrayDisplay($aResult)

ConsoleWrite((Not "a" = "")&@CRLF)
ConsoleWrite((Not ("a" = ""))&@CRLF)
ConsoleWrite((Not "a" == "")&@CRLF)
ConsoleWrite((Not ("a" == ""))&@CRLF)

Local $a = [1,2,3]
Local $b = [1,2,3]

ConsoleWrite(($a = $a)&@CRLF)

Func test($error = @error, $extended = @extended)
    Local $e = [$error, $extended]
    Return $e
EndFunc

setError(0xDEAD, 0xBEEF)
_arrayDisplay(test())

Func x()
    return setError(1, 1, 1)
EndFunc

Func y()
    Return ErrorAsValue(x())
EndFunc

Func ErrorAsValue($return, $error = @error, $extended = @extended)
    Local $a = [$return, $error, $extended]
    Return SetError(@error, @extended, $a)
EndFunc

$a = y()
_arraydisplay($a)
consolewrite(@error&@CRLF)

;----------------------------------------------------------------------


#include <WinAPIHObj.au3>
#include <NamedPipes.au3>
$hStdOut = _WinAPI_GetStdHandle(1)
ConsoleWrite($hStdOut&@CRLF)

Func SetStdHandle($nStdHandle, $hHandle) ;returns BOOL
    ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686244%28v=vs.85%29.aspx
    Local $aRet = DllCall("kernel32.dll", "BOOL", "SetStdHandle", "DWORD", $nStdHandle, "HANDLE", $hHandle)
    If @error <> 0 Then Return SetError(@error, 0, False)
    Return $aRet[0] <> 0
EndFunc

;$hConOut = CreateFile("CONOUT$", BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), Null, $OPEN_EXISTING, $FILE_ATTRIBUTE_NORMAL)
;$hConOut = CreateFile("CONOUT$", BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), Null, $OPEN_EXISTING, $FILE_ATTRIBUTE_NORMAL)
Local $hReadPipe, $hWritePipe
_NamedPipes_CreatePipe($hReadPipe, $hWritePipe)

Global Const $STD_INPUT_HANDLE = -10
Global Const $STD_OUTPUT_HANDLE = -11
Global Const $STD_ERROR_HANDLE = -12

SetStdHandle($STD_OUTPUT_HANDLE, $hWritePipe)

ConsoleWrite(_WinAPI_GetStdHandle(1)&@crlf)

;SetStdHandle(STD_OUTPUT_HANDLE, 0)

ConsoleWrite("test"&@crlf)