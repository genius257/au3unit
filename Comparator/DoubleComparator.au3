#include-once
#include "NumericComparator.au3"

; https://github.com/sebastianbergmann/comparator/blob/2256ef8e824cc494ddeebaa00fabe7ab4d83fc75/src/DoubleComparator.php

Global $Au3ComparatorDoubleComparatorFactory
Global $Au3ComparatorDoubleComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorDoubleComparator_setFactory($factory)
    $Au3ComparatorDoubleComparatorFactory = $factory
EndFunc

Func Au3ComparatorDoubleComparator_accepts($expected, $actual)
    Return (IsFloat($expected) or IsFloat($actual)) And Au3ComparatorNumericComparator_isNumeric($expected) And Au3ComparatorNumericComparator_isNumeric($actual)
EndFunc

Func Au3ComparatorDoubleComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = False, $ignoreCase = False)
    Local Const $EPSILON = 0.0000000001

    If $delta = 0 Then
        $delta = $EPSILON
    EndIf

    $return = Au3ComparatorNumericComparator_assertEquals($expected, $actual, $delta, $canonicalize, $ignoreCase)
    Return SetError(@error, @extended, $return)
EndFunc
