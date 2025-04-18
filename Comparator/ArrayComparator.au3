#include-once
#include <Array.au3>
#include "..\Exporter\Exporter.au3"
#include "..\Unit\Constraint\IsEqual.au3"
#include "ComparisonFailure.au3"

; https://github.com/sebastianbergmann/comparator/blob/2256ef8e824cc494ddeebaa00fabe7ab4d83fc75/src/ArrayComparator.php

Global $Au3ComparatorArrayComparatorFactory
Global $Au3ComparatorArrayComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorArrayComparator_setFactory($factory)
    $Au3ComparatorArrayComparatorFactory = $factory
EndFunc

Func Au3ComparatorArrayComparator_accepts($expected, $actual)
    Return IsArray($expected) And IsArray($actual)
EndFunc

Func Au3ComparatorArrayComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = false, $ignoreCase = false);, ByRef $processed = 0)
    If $canonicalize Then
        _ArraySort($expected)
        _ArraySort($actual)
    EndIf

    Local $remaining = $actual
    Local $actualAsString = StringFormat("Array (\n")
    Local $expectedAsString = StringFormat("Array (\n")
    Local $equal = true

    Local $count = 0
    Local $i
    Local $index[UBound($expected, 0)]
    Local $val
    For $i = 0 To UBound($index)-1
        $index[$i] = 0
    Next

    While 1
        $key = _ArrayToString($index, "][")
        $val2 = Execute(StringFormat("$expected[%s]", $key))
        If @error <> 0 Then
            ConsoleWrite("ArrayComparator.au3 ERROR: failed generating key")
            Return SetError(1, 0, False); this only happens if there is an error generating the array key!
        EndIf
        $val1 = Execute(StringFormat("$actual[%s]", $key))
        If @error <> 0 Then
            $expectedAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorArrayComparatorExporter&"_export", Au3ComparatorArrayComparator_exportKey($key)), _
                Call($Au3ComparatorArrayComparatorExporter&"_shortenedExport", $val2) _
            )
            $equal = False

            ;increment array index start
            Local $innerIndex = UBound($index, 1)
            While 1
                $innerIndex-=1
                If $innerIndex < 0 Then ExitLoop
                $index[$innerIndex] += 1
                If Not ($index[$innerIndex] >= UBound($expected, $innerIndex + 1)) Then
                    ExitLoop
                EndIf
                If $innerIndex = 0 And $index[$innerIndex] = UBound($expected, 1) Then ExitLoop 2
                $index[$innerIndex] = 0
            WEnd
            $count += 1
            ;increment array index end

            ContinueLoop
        EndIf
        $comparator = Au3ComparatorFactory_getComparatorFor($val2, $val1)
        If @error <> 0 Then ConsoleWriteError(StringFormat("ArrayComparator.au3:%s ERROR: no comparator found!\n", @ScriptLineNumber))
        $e = Call($comparator&"_assertEquals", $val2, $val1)
        If @error = 0xDEAD And @extended = 0xBEEF Then ConsoleWriteError($comparator&"_assertEquals function is missing"&@CRLF)
        Local $error = @error
        If $error <> 0 And Is_Au3ComparatorComparisonFailure($e) Then
            $expectedAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorArrayComparatorExporter&"_export", Au3ComparatorArrayComparator_exportKey($key)), _
                Call($e[0]&"_getExpectedAsString", $e) ? Au3ComparatorArrayComparator_indent(Call($e[0]&"_getExpectedAsString", $e)) : Call($Au3ComparatorArrayComparatorExporter&"_shortenedExport", Call($e[0]&"_getExpected", $e)) _
            )

            $actualAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorArrayComparatorExporter&"_export", Au3ComparatorArrayComparator_exportKey($key)), _
                Call($e[0]&"_getActualAsString", $e) ? Au3ComparatorArrayComparator_indent(Call($e[0]&"_getActualAsString", $e)) : Call($Au3ComparatorArrayComparatorExporter&"_shortenedExport", Call($e[0]&"_getActual", $e)) _
            )

            $equal = False
        ElseIf $error = 0 Then
            $expectedAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorArrayComparatorExporter&"_export", Au3ComparatorArrayComparator_exportKey($key)), _
                Call($Au3ComparatorArrayComparatorExporter&"_shortenedExport", $val2) _
            )

            $actualAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorArrayComparatorExporter&"_export", Au3ComparatorArrayComparator_exportKey($key)), _
                Call($Au3ComparatorArrayComparatorExporter&"_shortenedExport", $val1) _
            )
        Else
            ConsoleWriteError(StringFormat("ArrayComparator.au3:%s ERROR: @error was <> 0 but no Eception was found!\n", @ScriptLineNumber))
        EndIf
        ;If Not Au3UnitConstraintIsEqual_Matches($val1, $val2) Then Return SetError(1, 0, False)

        Local $innerIndex = UBound($index, 1)
        While 1
            $innerIndex-=1
            If $innerIndex < 0 Then ExitLoop
            $index[$innerIndex] += 1
            If Not ($index[$innerIndex] >= UBound($expected, $innerIndex + 1)) Then
                ExitLoop
            EndIf
            If $innerIndex = 0 And $index[$innerIndex] = UBound($expected, 1) Then ExitLoop 2
            $index[$innerIndex] = 0
        WEnd

        $count += 1
    WEnd

    ;If UBound($expected, $innerIndex + 1) < UBound($remaining, $innerIndex + 1) Then $index[$innerIndex] -= 1
    ;$index[$innerIndex] -= 1
    Local $more = UBound($expected, $innerIndex + 1) < UBound($remaining, $innerIndex + 1)

    While $more
        $count += 1
        $key = _ArrayToString($index, "][")
        $val1 = Execute(StringFormat("$remaining[%s]", $key))
        $actualAsString &= StringFormat( _
            "    %s => %s\n", _
            Call($Au3ComparatorArrayComparatorExporter&"_export", Au3ComparatorArrayComparator_exportKey($key)), _
            Call($Au3ComparatorArrayComparatorExporter&"_shortenedExport", $val1) _
        )
        $equal = False

        Local $innerIndex = UBound($index, 1)
        While 1
            $innerIndex-=1
            If $innerIndex < 0 Then ExitLoop
            $index[$innerIndex] += 1
            If Not ($index[$innerIndex] = UBound($remaining, $innerIndex + 1)) Then
                ExitLoop
            EndIf
            If $innerIndex = 0 And $index[$innerIndex] >= UBound($remaining, 1) Then ExitLoop 2
            $index[$innerIndex] = 0
        WEnd
    WEnd

    $expectedAsString &= ')'
    $actualAsString &= ')'

    If Not $equal Then
        Return SetError(1, 0, Au3ComparatorComparisonFailure( _
            $expected, _
            $actual, _
            $expectedAsString, _
            $actualAsString, _
            False, _
            'Failed asserting that two arrays are equal.' _
        ))
    EndIf
EndFunc

Func Au3ComparatorArrayComparator_indent($lines)
    Return StringRegExpReplace(StringRegExpReplace($lines, "\n", "\0    "), "(?(DEFINE)(?<range>[ \t\n\r\0\x0B]*))(^(?&range)|(?&range)$)", "")
EndFunc

Func Au3ComparatorArrayComparator_exportKey($key)
    Return StringIsDigit($key) ? Number($key) : '[' & $key & ']'
EndFunc
