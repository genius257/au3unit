#include-once
#include "..\Exporter\Exporter.au3"
#include "..\Unit\Constraint\IsEqual.au3"
#include "ComparisonFailure.au3"

Global $Au3ComparatorMapComparatorFactory
Global $Au3ComparatorMapComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorMapComparator_setFactory($factory)
    $Au3ComparatorMapComparatorFactory = $factory
EndFunc

Func Au3ComparatorMapComparator_accepts($expected, $actual)
    Return IsMap($expected) And IsMap($actual)
EndFunc

Func Au3ComparatorMapComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = false, $ignoreCase = false);, ByRef $processed = 0)
    Local $remaining = $actual
    Local $actualAsString = StringFormat("Map (\n")
    Local $expectedAsString = StringFormat("Map (\n")
    Local $equal = true

    Local $comparator, $e

    Local $value
    For $key in MapKeys($expected)
        $value = $expected[$key]
        MapRemove($remaining, $key)

        If Not MapExists($actual, $key) then
            $expectedAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorMapComparatorExporter&"_export", $key), _
                Call($Au3ComparatorMapComparatorExporter&"_shortenedExport", $value) _
            )

            $equal = false

            ContinueLoop
        EndIf

        $comparator = Au3ComparatorFactory_getComparatorFor($value, $actual[$key])
        If @error <> 0 Then ConsoleWriteError(StringFormat("MapComparator.au3:%s ERROR: no comparator found!\n", @ScriptLineNumber))
        $e = Call($comparator&"_assertEquals", $value, $actual[$key], $delta, $canonicalize, $ignoreCase);, $processed)
        If @error = 0xDEAD And @extended = 0xBEEF Then ConsoleWriteError($comparator&"_assertEquals function is missing"&@CRLF)
        Local $error = @error

        If $error <> 0 And Is_Au3ComparatorComparisonFailure($e) Then
            $expectedAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorMapComparatorExporter&"_export", $key), _
                Call($e[0]&"_getExpectedAsString", $e) ? Au3ComparatorMapComparator_indent(Call($e[0]&"_getExpectedAsString", $e)) : Call($Au3ComparatorMapComparatorExporter&"_shortenedExport", Call($e[0]&"_getExpected", $e)) _
            )

            $actualAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorMapComparatorExporter&"_export", $key), _
                Call($e[0]&"_getActualAsString", $e) ? Au3ComparatorMapComparator_indent(Call($e[0]&"_getActualAsString", $e)) : Call($Au3ComparatorMapComparatorExporter&"_shortenedExport", Call($e[0]&"_getActual", $e)) _
            )

            $equal = False
        ElseIf $error = 0 Then
            $expectedAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorMapComparatorExporter&"_export", $key), _
                Call($Au3ComparatorMapComparatorExporter&"_shortenedExport", $value) _
            )

            $actualAsString &= StringFormat( _
                "    %s => %s\n", _
                Call($Au3ComparatorMapComparatorExporter&"_export", $key), _
                Call($Au3ComparatorMapComparatorExporter&"_shortenedExport", $actual[$value]) _
            )
        Else
            ConsoleWriteError(StringFormat("MapComparator.au3:%s ERROR: @error was <> 0 but no Eception was found!\n", @ScriptLineNumber))
        EndIf
    Next

    For $key In MapKeys($remaining)
        $value = $remaining[$key]

        $actualAsString &= StringFormat( _
            "    %s => %s\n", _
            Call($Au3ComparatorMapComparatorExporter&"_export", $key), _
            Call($Au3ComparatorMapComparatorExporter&"_shortenedExport", $value) _
        )

        $equal = False
    Next

    $expectedAsString &= ')'
    $actualAsString &= ')'

    If Not $equal Then
        Return SetError(1, 0, Au3ComparatorComparisonFailure( _
            $expected, _
            $actual, _
            $expectedAsString, _
            $actualAsString, _
            False, _
            'Failed asserting that two maps are equal.' _
        ))
    EndIf
EndFunc

Func Au3ComparatorMapComparator_indent($lines)
    Return StringRegExpReplace(StringRegExpReplace($lines, "\n", "\0    "), "(?(DEFINE)(?<range>[ \t\n\r\0\x0B]*))(^(?&range)|(?&range)$)", "")
EndFunc
