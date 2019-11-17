#include-once
#include <Array.au3>
#include "..\Exporter\Exporter.au3"

Global $Au3ComparatorScalarComparatorFactory
Global $Au3ComparatorScalarComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorScalarComparator_setFactory($factory)
    $Au3ComparatorScalarComparatorFactory = $factory
EndFunc

Func Au3ComparatorScalarComparator_isScalar($variable)
    ; https://www.php.net/manual/en/function.is-scalar.php

    Return IsInt($variable) Or IsFloat($variable) Or IsString($variable) Or IsBool($variable)
EndFunc

Func Au3ComparatorScalarComparator_accepts($expected, $actual)
    Return ((Au3ComparatorScalarComparator_isScalar($expected) Or $expected == Null) And (Au3ComparatorScalarComparator_isScalar($actual) Or $actual == Null))
EndFunc

Func Au3ComparatorScalarComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = false, $ignoreCase = false);, ByRef $processed = 0)
    $expectedToCompare = $expected;
    $actualToCompare   = $actual;
    ; always compare as strings to avoid strange behaviour
    ; otherwise 0 == 'Foobar'
    if (isString($expected) Or isString($actual)) Then
        $expectedToCompare = String($expectedToCompare);
        $actualToCompare   = String($actualToCompare);
        If ($ignoreCase) Then
            $expectedToCompare = StringLower($expectedToCompare);
            $actualToCompare   = StringLower($actualToCompare);
        EndIf
    EndIf
    if ((Not $expectedToCompare == $actualToCompare) And isString($expected) And isString($actual)) Then
        Return SetError(1, 0, 'idk')
        #cs
        throw new ComparisonFailure(
            $expected,
            $actual,
            $this->exporter->export($expected),
            $this->exporter->export($actual),
            false,
            'Failed asserting that two strings are equal.'
        );
        #ce
    EndIf
    if Not ($expectedToCompare = $actualToCompare) Then
        Return SetError(1, 0, 'idk')
        #cs
        throw new ComparisonFailure(
            $expected,
            $actual,
            // no diff is required
            '',
            '',
            false,
            \sprintf(
                'Failed asserting that %s matches expected %s.',
                $this->exporter->export($actual),
                $this->exporter->export($expected)
            )
        );
        #ce
    EndIf
EndFunc
#cs
Func Au3ComparatorArrayComparator_indent($lines)
    ;FIXME
    Return StringRegExpReplace(StringRegExpReplace($lines, "\n", "\0    "), "(?(DEFINE)(?<range>[ \t\n\r\0\x0B]*))(^(?&range)|(?&range)$)", "")
EndFunc
#ce
