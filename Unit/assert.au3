#include-once
; https://github.com/sebastianbergmann/phpunit/blob/7.2/src/Framework/Assert.php
; WARNING 7.2 is missing some wanted assert function and creates special assertions that makes class istances with options passed to constraint constructors.
; As a result, 12.1.2 will be used as a reference from now on:
; https://github.com/sebastianbergmann/phpunit/blob/12.1.2/src/Framework/Assert.php

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

Func assertLessThanOrEqual($maximum, $actual, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = [["IsEqual", $actual],["LessThan", $actual]]
	assertThat($maximum, "LogicalOr", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\IsNull.au3"
Func assertNull($actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsNull", $message, $line)
EndFunc

Func assertNotNull($actual, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["IsNull", $actual]
	assertThat($actual, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\String\StringMatchesFormatDescription.au3"
Func assertStringMatchesFormat($format, $string, $message = "", $line = @ScriptLineNumber)
	assertThat($string, "StringMatchesFormatDescription", $message, $line, $format)
EndFunc

#include "Constraint\IsIdentical.au3"
Func assertSame($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsIdentical", $message, $line, $expected)
EndFunc

Func assertNotSame($expected, $actual, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["IsIdentical", $expected]
	assertThat($actual, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\String\StringEndsWith.au3"
Func assertStringEndsWith($suffix, $string, $message = "", $line = @ScriptLineNumber)
	assertThat($string, "StringEndsWith", $message, $line, $suffix)
EndFunc

Func assertStringEndsNotWith($suffix, $string, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["StringEndsWith", $suffix]
	assertThat($string, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\String\StringStartsWith.au3"
Func assertStringStartsWith($prefix, $string, $message = "", $line = @ScriptLineNumber)
	assertThat($string, "StringStartsWith", $message, $line, $prefix)
EndFunc

Func assertStringStartsNotWith($prefix, $string, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["StringStartsWith", $prefix]
	assertThat($string, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\Boolean\IsTrue.au3"
Func assertTrue($condition, $message = "", $line = @ScriptLineNumber)
	assertThat($condition, "IsTrue", $message, $line, $condition)
EndFunc

Func assertNotTrue($condition, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = ["IsTrue", $condition]
	assertThat($condition, "LogicalNot", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\Equality\IsEqualCanonicalizing.au3"
Func assertEqualsCanonicalizing($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsEqualCanonicalizing", $message, $line, $expected)
EndFunc

#include "Constraint\Equality\IsEqualIgnoringCase.au3"
Func assertEqualsIgnoringCase($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsEqualIgnoringCase", $message, $line, $expected)
EndFunc

#include "Constraint\Equality\IsEqualWithDelta.au3"
Func assertEqualsWithDelta($expected, $actual, $delta, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = [$expected, $delta]
	assertThat($actual, "IsEqualWithDelta", $message, $line, $passedToContraint)
EndFunc

Func assertFileEquals($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertFileExists($expected, $message, $line)
	assertFileExists($actual, $message, $line)

	assertThat(FileRead($actual), "IsEqual", $message, $line, FileRead($expected))
EndFunc

#include "Constraint\Filesystem\FileExists.au3"
Func assertFileExists($filename, $message = "", $line = @ScriptLineNumber)
	assertThat($filename, "FileExists", $message = "", $line)
EndFunc

#include "Constraint\Traversable\MapHasKey.au3"
Func assertMapHasKey($key, $map, $message = "", $line = @ScriptLineNumber)
	assertThat($map, "MapHasKey", $message, $line, $key)
EndFunc

#include "Constraint\Cardinality\Count.au3"
Func assertCount($expectedCount, $haystack, $dimension = 1, $message = "", $line = @ScriptLineNumber)
	Local $passedToContraint = [$expectedCount, $dimension]
	assertThat($haystack, "Count", $message, $line, $passedToContraint)
EndFunc

#include "Constraint\Cardinality\SameSize.au3"
Func assertSameSize($expected, $actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "SameSize", $message, $line, $expected)
EndFunc

#include "Constraint\Cardinality\IsEmpty.au3"
Func assertEmpty($actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsEmpty", $message, $line)
EndFunc

Func assertIsArray($actual, $message = "", $line = @ScriptLineNumber)
	assertThat($actual, "IsType", $message, $line, "array")
EndFunc
