#include-once
; https://github.com/sebastianbergmann/phpunit/blob/7.2/src/Framework/Assert.php

#include <WinAPI.au3>
#include <WinAPIFiles.au3>

Global $Au3UnitAssertCount = 0
Global Const $AU3UNIT_EXITCODE_FAIL = 0x3DE2

#include "Constraint\Constraint.au3"
#include "Constraint\IsType.au3"
#include "Constraint/LogicalOr.au3"
#include "Constraint\LogicalNot.au3"

If $CmdLine[0]>1 And $CmdLine[1] == "external" Then Opt("TrayIconHide", 0)

Func assertThat($value, $constraint, $message = "", $line = @ScriptLineNumber, $passedToContraint = Null)
	Local $constraintCount = "Au3UnitConstraint" & $constraint & "Count"
	$Au3UnitAssertCount += IsDeclared($constraintCount) ? Eval($constraintCount) : $Au3UnitConstraintCount

	If $CmdLine[0]>1 And $CmdLine[1] == "external" Then
		Local $hMapping = _WinAPI_OpenFileMapping($CmdLine[2])
		Local $pMapping = _WinAPI_MapViewOfFile($hMapping)
		Local $tMapping = DllStructCreate("UINT64 count", $pMapping)
		$tMapping.count += 1
		$tMapping = Null
		_WinAPI_UnmapViewOfFile($pMapping)
		_WinAPI_CloseHandle($hMapping)
	EndIf

	Local $e = Call("Au3UnitConstraint" & $constraint & "_Evaluate", $value, $message, False, $line, $passedToContraint)
	If @error==0xDEAD And @extended==0xBEEF Then $e = Call("Au3UnitConstraintConstraint_Evaluate", $constraint, $value, $message, False, $line, $passedToContraint)
	$error = @error
	If $error <> 0 And $CmdLine[0]>0 And $CmdLine[1] == "external" Then Exit $AU3UNIT_EXITCODE_FAIL
	;if $error <> 0 Then ConsoleWriteError(Call($e[0]&"_ToString", $e)&@CRLF)
	Return SetError($error)
EndFunc

; Func assertObjectHasAttribute($attributeName, $object, $message = "")
	;
; EndFunc

#include "Constraint\IsEqual.au3"
Func assertEquals($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsEqual", $message, $line, $expected)
EndFunc

Func assertNotEquals($expected, $actual, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["IsEqual", $expected]
	assertThat($actual, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\Boolean\IsFalse.au3"
Func assertFalse($condition, $message = "", $line = @ScriptLineNumber)
	assertThat($condition, "IsFalse", $message, $line, $condition)
EndFunc

Func assertNotFalse($condition, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["IsFalse", $condition]
	assertThat($condition, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\Cardinality\GreaterThan.au3"
Func assertGreaterThan($minimum, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($minimum, "GreaterThan", $message, $line, $actual)
EndFunc

Func assertGreaterThanOrEqual($minimum, $actual, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = [["IsEqual", $actual],["GreaterThan", $actual]]
	assertThat($minimum, "LogicalOr", $message, $line, $passedToContraint)
EndFunc

; Func assertInfinite($variable, $message = "")

; EndFunc

; Func assertFinite($variable, $message = "")

; EndFunc

#include "Constraint\IsIdentical.au3"
Func assertInternalType($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsType", $message, $line, $expected)
EndFunc

Func assertIsNumber($actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsType", $message, $line, "Number")
EndFunc

Func assertIsInt($actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsType", $message, $line, "Int")
EndFunc

Func assertNotInternalType($expected, $actual, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["IsType", $expected]
	assertThat($actual, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\Cardinality\LessThan.au3"
Func assertLessThan($maximum, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($maximum, "LessThan", $message, $line, $actual)
EndFunc

; Func assertLessThanOrEqual($expected, $actual, $message = "")

; EndFunc

#include "Constraint\IsNull.au3"
Func assertNull($actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsNull", $message, $line)
EndFunc

#cs
Func assertNotNull()
	assertThat($actual, logicalNot("isNull"), $message)
EndFunc


Func assertStringMatchesFormat($format, $string, $message = "")

EndFunc
#ce

#include "Constraint\IsIdentical.au3"
Func assertSame($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsIdentical", $message, $line, $expected)
EndFunc
#cs
Func assertNotSame($expected, $actual, $message = "")

EndFunc
#ce
#cs
Func assertStringEndsWith($suffix, $string, $message = "")

EndFunc

Func assertStringEndsNotWith($suffix, $string, $message = "")

EndFunc
#ce
#cs
Func assertStringStartsWith($prefix, $string, $message = "")

EndFunc

Func assertStringStartsNotWith($prefix, $string, $message = "")

EndFunc
#ce
#include "Constraint\Boolean\IsTrue.au3"
Func assertTrue($condition, $message = "", $line = @ScriptLineNumber)
	assertThat($condition, "IsTrue", $message, $line, $condition)
EndFunc

Func assertNotTrue($condition, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["IsTrue", $condition]
	assertThat($condition, "LogicalNot", $message, $line, $passedToContraint)
EndFunc
