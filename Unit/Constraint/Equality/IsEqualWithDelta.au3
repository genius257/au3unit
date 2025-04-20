#include-once

#include-once

; https://github.com/sebastianbergmann/phpunit/blob/12.1.2/src/Framework/Constraint/Equality/IsEqualWithDelta.php
; https://github.com/sebastianbergmann/phpunit/blob/6f2775cc4b7b19ba5a411c188e855eb0cc78a711/src/Framework/Constraint/Equality/IsEqualWithDelta.php

; Modified to use matches method instead of evaluate, since my shallow class implementation would require rewriting all logic, to work with evaluate...

Func Au3UnitConstraintIsEqualWithDelta_Matches($other, $exspected, $description)
    ; If $expected and $other are identical, they are also equal.
    ; This is the most common path and will allow us to skip
    ; initialization of all the comparators.
    If Au3UnitConstraintIsEqualWithDelta_StrictEquals($other, $exspected[0]) Then
        Return True
    EndIf

    Local $comparator = Au3ComparatorFactory_getComparatorFor($exspected[0], $other)
    If @error <> 0 Then ConsoleWriteError("no comparator found!"&@CRLF)
    Local $e = Call($comparator&"_assertEquals", $exspected[0], $other, $exspected[1])
    Local $error = @error
    If $error = 0xDEAD And @extended = 0xBEEF Then ConsoleWriteError($comparator&"_assertEquals function is missing"&@CRLF)
    If $error <> 0 And Is_Au3ComparatorComparisonFailure($e) Then
        Return SetError(1, 0, Au3UnitExpectationFailedException(StringRegExpReplace($description & @CRLF & Call($e[0]&"_getMessage", $e), "(?(DEFINE)(?<range>[ \t\n\r\0\x0B]*))(^(?&range)|(?&range)$)", ""), $e))
    ElseIf $error <> 0 Then
        Return False
    EndIf
    Return True
EndFunc

Func Au3UnitConstraintIsEqualWithDelta_StrictEquals($a, $b)
    If Not (VarGetType($b) == VarGetType($b)) Then Return False
    Return (IsString($a) And $a == $b) Or $a = $b
EndFunc

Func Au3UnitConstraintIsEqualWithDelta_ToString($value)
    If IsString($value) Then
        If StringRegExp($value, "\n") Then Return 'is equal to <text>'

        Return StringFormat("is equal to '%s'", $value)
    EndIf

    Return StringFormat('is equal to %s', Au3ExporterExporter_export($value))
EndFunc
