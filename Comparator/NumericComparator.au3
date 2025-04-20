#include-once

Global $Au3ComparatorNumericComparatorFactory
Global $Au3ComparatorNumericComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorNumericComparator_setFactory($factory)
    $Au3ComparatorNumericComparatorFactory = $factory
EndFunc

Func Au3ComparatorNumericComparator_accepts($expected, $actual)
    ; all numerical values, but not if one of them is a double
    ; or both of them are strings
    Return Au3ComparatorNumericComparator_isNumeric($expected) And Au3ComparatorNumericComparator_isNumeric($actual) And _
        Not (IsFloat($expected) Or IsFloat($actual)) And _
        Not (IsString($expected) And IsString($actual))
EndFunc

Func Au3ComparatorNumericComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = False, $ignoreCase = False)
    If Au3ComparatorNumericComparator_isInfinite($actual) And Au3ComparatorNumericComparator_isInfinite($expected) Then Return

    If (BitXOR(Au3ComparatorNumericComparator_isInfinite($actual), Au3ComparatorNumericComparator_isInfinite($expected))) Or _
        (Au3ComparatorNumericComparator_isNan($actual) Or Au3ComparatorNumericComparator_isNan($expected)) Or _
        Abs($actual - $expected) > $delta _
    Then Return SetError(1, 0, Au3ComparatorComparisonFailure( _
            $expected, _
            $actual, _
            '', _
            '', _
            False, _
            StringFormat('Failed asserting that %s matches expected %s.', _
                Call($Au3ComparatorNumericComparatorExporter&"_export", $actual), _
                Call($Au3ComparatorNumericComparatorExporter&"_export", $expected) _
            ) _
        ))
    
EndFunc

Func Au3ComparatorNumericComparator_isNumeric($value)
    Return IsNumber($value) Or (IsString($value) And StringIsDigit($value))
EndFunc

Func Au3ComparatorNumericComparator_isInfinite($value)
    Local Const $POSITIVE_INFINITY = 1/0
    Local Const $NEGATIVE_INFINITY = -1/0

    Return $value = $POSITIVE_INFINITY Or $value = $NEGATIVE_INFINITY
EndFunc

Func Au3ComparatorNumericComparator_isNan($value)
    If VarGetType($value) == "Double" Then
        Local $y = DllStructCreate("double")
        Local $z = DllStructCreate("long[2]", DllStructGetPtr($y))
        DllStructSetData($y, 1, $value)
        Return DllStructGetData($z, 1, 1) = 0x00000000 And DllStructGetData($z, 1, 2) = 0x7ff80000
    EndIf
    Return False
EndFunc
