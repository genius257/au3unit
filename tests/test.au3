#include <AutoItConstants.au3>
#include <ProcessConstants.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include "..\Unit\assert.au3"

Global $tests = [ _
    ["constraints\True_Success.au3", "", 0], _
    ["constraints\True_Failure.au3", "Failed asserting that false is true.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\NotTrue_Success.au3", "", 0], _
    ["constraints\NotTrue_Failure.au3", "Failed asserting that true is not true.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\False_Success.au3", "", 0], _
    ["constraints\False_Failure.au3", "Failed asserting that true is false.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\NotFalse_Success.au3", "", 0], _
    ["constraints\NotFalse_Failure.au3", "Failed asserting that false is not false.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Same_Success.au3", "", 0], _
    ["constraints\Same_Failure.au3", "Failed asserting that 2204 is identical to '2204'.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\NotSame_Success.au3", "", 0], _
    ["constraints\NotSame_Failure.au3", "Failed asserting that 2204 is not identical to '2204'.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Equal_Success.au3", "", 0], _
    ["constraints\Equal_Failure.au3", "Failed asserting that 0 matches expected 1.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Equal_Failure2.au3", StringFormat("Failed asserting that two strings are equal.\n--- Expected\n+++ Actual\n@@ @@\n-'bar'\n+'baz'"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Equal_Failure3.au3", StringFormat("Failed asserting that two strings are equal.\n--- Expected\n+++ Actual\n@@ @@\n 'foo\\n\n-bar\\n\n+bah\\n\n baz\\n\n '"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Equal_Failure4.au3", StringFormat("Failed asserting that two maps are equal.\n--- Expected\n+++ Actual\n@@ @@\n Map (\n-    'foo' => 'foo'\n-    'bar' => 'bar'\n+    'foo' => 'bar'\n+    'baz' => 'bar'\n )"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Equal_Failure5.au3", StringFormat("Failed asserting that two arrays are equal.\n--- Expected\n+++ Actual\n@@ @@\n Array (\n     0 => 'a'\n-    1 => 'b'\n-    2 => 'c'\n+    1 => 'c'\n+    2 => 'd'\n )"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Equal_Failure6.au3", StringFormat("Failed asserting that two arrays are equal.\n--- Expected\n+++ Actual\n@@ @@\n Array (\n     [0][0] => 1\n-    [0][1] => 2\n-    [0][2] => 3\n+    [0][1] => 3\n+    [0][2] => 4\n )"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\NotEqual_Success.au3", "", 0], _
    ["constraints\NotEqual_Failure.au3", "Failed asserting that 0 does not match expected 0.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\EqualsCanonicalizing_Success.au3", "", 0], _
    ["constraints\EqualsCanonicalizing_Failure.au3", StringFormat("Failed asserting that two arrays are equal.\n--- Expected\n+++ Actual\n@@ @@\n Array (\n-    0 => 1\n-    1 => 2\n-    2 => 3\n+    0 => 0\n+    1 => 1\n+    2 => 2\n+    3 => 3\n )"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\NotEqualsCanonicalizing_Success.au3", "", 0], _
    ["constraints\NotEqualsCanonicalizing_Failure.au3", "Failed asserting that two arrays are not equal.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\EqualsIgnoringCase_Success.au3", "", 0], _
    ["constraints\EqualsIgnoringCase_Failure.au3", StringFormat("Failed asserting that two strings are equal.\n--- Expected\n+++ Actual\n@@ @@\n-'foo'\n+'BAR'"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\NotEqualsIgnoringCase_Success.au3", "", 0], _
    ["constraints\NotEqualsIgnoringCase_Failure.au3", "Failed asserting that two strings are not equal.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\EqualsWithDelta_Success.au3", "", 0], _
    ["constraints\EqualsWithDelta_Failure.au3", "Failed asserting that 1.5 matches expected 1.0.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\NotEqualsWithDelta_Success.au3", "", 0], _
    ["constraints\NotEqualsWithDelta_Failure.au3", "Failed asserting that 1.5 does not match expected 1.5.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\FileEquals_Success.au3", "", 0], _
    ["constraints\FileEquals_Failure.au3", StringFormat("Failed asserting that two strings are equal.\n--- Expected\n+++ Actual\n@@ @@\n-'expected\\n\n+'actual\\n\n '"), $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\FileNotEquals_Success.au3", "", 0], _
    ["constraints\FileNotEquals_Failure.au3", "Failed asserting that two strings are not equal.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\MapHasKey_Success.au3", "", 0], _
    ["constraints\MapHasKey_Failure.au3", "Failed asserting that a map has the key 'foo'.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Count_Success.au3", "", 0], _
    ["constraints\Count_Failure.au3", "Failed asserting that actual size 1 matches expected size 0.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\SameSize_Success.au3", "", 0], _
    ["constraints\SameSize_Failure.au3", "Failed asserting that actual size [1] matches expected size [2].", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\Empty_Success.au3", "", 0], _
    ["constraints\Empty_Failure.au3", "Failed asserting that an array is empty.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\GreaterThan_Success.au3", "", 0], _
    ["constraints\GreaterThan_Failure.au3", "Failed asserting that 1 is greater than 2.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\GreaterThanOrEqual_Success.au3", "", 0], _
    ["constraints\GreaterThanOrEqual_Failure.au3", "Failed asserting that 1 is equal to 2 or is greater than 2.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\LessThan_Success.au3", "", 0], _
    ["constraints\LessThan_Failure.au3", "Failed asserting that 2 is less than 1.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\LessThanOrEqual_Success.au3", "", 0], _
    ["constraints\LessThanOrEqual_Failure.au3", "Failed asserting that 2 is equal to 1 or is less than 1.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsArray_Success.au3", "", 0], _
    ["constraints\IsArray_Failure.au3", "Failed asserting that null is of type array.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsMap_Success.au3", "", 0], _
    ["constraints\IsMap_Failure.au3", "Failed asserting that null is of type map.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsBool_Success.au3", "", 0], _
    ["constraints\IsBool_Failure.au3", "Failed asserting that null is of type bool.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsCallable_Success.au3", "", 0], _
    ["constraints\IsCallable_Failure.au3", "Failed asserting that null is of type callable.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsFloat_Success.au3", "", 0], _
    ["constraints\IsFloat_Failure.au3", "Failed asserting that null is of type float.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsInt_Success.au3", "", 0], _
    ["constraints\IsInt_Failure.au3", "Failed asserting that null is of type int.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsNumeric_Success.au3", "", 0], _
    ["constraints\IsNumeric_Failure.au3", "Failed asserting that null is of type numeric.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsObject_Success.au3", "", 0], _
    ["constraints\IsObject_Failure.au3", "Failed asserting that null is of type object.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsResource_Success.au3", "", 0], _
    ["constraints\IsResource_Failure.au3", "Failed asserting that null is of type resource.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsScalar_Success.au3", "", 0], _
    ["constraints\IsScalar_Failure.au3", "Failed asserting that null is of type scalar.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsString_Success.au3", "", 0], _
    ["constraints\IsString_Failure.au3", "Failed asserting that null is of type string.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsNull_Success.au3", "", 0], _
    ["constraints\IsNull_Failure.au3", "Failed asserting that 'foo' is null.", $AU3UNIT_EXITCODE_FAIL], _
    ["constraints\IsNotNull_Success.au3", "", 0], _
    ["constraints\IsNotNull_Failure.au3", "Failed asserting that null is not null.", $AU3UNIT_EXITCODE_FAIL] _
]

Global $sMapping = 'au3unit'&au3unit_unixTimestamp()
Global $hMapping = _WinAPI_CreateFileMapping(-1, 8, $sMapping)
Global $pMapping = _WinAPI_MapViewOfFile($hMapping)
Global $tMapping = DllStructCreate("UINT64 count", $pMapping)

Global $failures = 0

Global $success = True
For $i = 0 To UBound($tests, 1) - 1 Step +1
    $file = @ScriptDir & "\" & $tests[$i][0]

    $iPID = Run(StringFormat('"%s" /ErrorStdOut "%s" external %s', @AutoItExe, $file, $sMapping), "", @SW_HIDE, BitOR($STDOUT_CHILD, $STDERR_CHILD, $STDERR_MERGED))

    If @error = 0 Then
        Global $hProcess
        If Number(_WinAPI_GetVersion()) >= 6.0 Then
            $hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, 0, $iPID)
        Else
            $hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION, 0, $iPID)
        EndIf

        ProcessWaitClose($iPID)

        $exitCode = _WinAPI_GetExitCodeProcess($hProcess)
        _WinAPI_CloseHandle($hProcess)

        $actual = StdoutRead($iPID)

        $expected = $tests[$i][1]

        If (Not ($exitCode = $tests[$i][2])) Or Not (extractActual($actual) == $expected) Then
            $failures += 1
            ConsoleWrite(StringFormat('"%s" Failed.\n', $file))
            If (Not ($exitCode = $tests[$i][2])) Then ConsoleWrite(stringformat("    Exit code %s, expected %s\n", $exitCode, $tests[$i][2]))
            If Not (extractActual($actual) == $expected) Then
                ConsoleWrite(StringFormat("    Expected: %s\n    Actual:   %s\n", export($expected), export(extractActual($actual))))
            EndIf
            $success = False
        EndIf
    Else
        ConsoleWrite(StringFormat("Problem when trying to run test script @error: %s, ""%s""\n", @error, $tests[$i][0]))
    EndIf
Next

ConsoleWrite(StringFormat("\nTests: %s, Assertions: %s, Failures:%s\n", UBound($tests, 1), $tMapping.count, $failures))

If Not $success Then Exit 1
Exit 0

Func extractActual($string)
    Return StringRegExpReplace($string, "\r?\n[^\n]+\r?\n$", "")
EndFunc

Func au3unit_unixTimestamp($sDateTime = 0)
    Local $aSysTimeInfo = _Date_Time_GetTimeZoneInformation()
    Local $utcTime = ""

    If Not $sDateTime Then $sDateTime = _NowCalc()

    If Int(StringLeft($sDateTime, 4)) < 1970 Then Return ""

    If $aSysTimeInfo[0] = 2 Then ; if daylight saving time is active
        $utcTime = _DateAdd('n', $aSysTimeInfo[1] + $aSysTimeInfo[7], $sDateTime) ; account for time zone and daylight saving time
    Else
        $utcTime = _DateAdd('n', $aSysTimeInfo[1], $sDateTime) ; account for time zone
    EndIf

    Return _DateDiff('s', "1970/01/01 00:00:00", $utcTime)
EndFunc

Func export($value)
    If IsArray($value) Then
        $return = '['
        For $i = 0 To UBound($value) - 1
            $return &= export($value[$i])
            If $i < UBound($value) - 1 Then $return &= ','
        Next
        Return $return & ']'
    EndIf

    return StringRegExpReplace(StringRegExpReplace(Au3ExporterExporter_export($value), "\r?\n", "\\n"), "(?!^)'(?!$)", "\\'")
EndFunc
