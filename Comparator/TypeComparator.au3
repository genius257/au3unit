;Au3ComparatorTypeComparator

#include-once
#include "..\Exporter\Exporter.au3"

Global $Au3ComparatorTypeComparatorFactory
Global $Au3ComparatorTypeComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorTypeComparator_setFactory($factory)
    $Au3ComparatorResourceComparatorFactory = $factory
EndFunc

Func Au3ComparatorTypeComparator_accepts($expected, $actual)
    Return True
EndFunc

Func Au3ComparatorTypeComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = false, $ignoreCase = false)
    If Not (VarGetType($expected) = VarGetType($actual)) Then Return SetError(1, 0, Au3ComparatorComparisonFailure( _
        $expected, _
        $actual, _
        '', _; we don't need a diff
        '', _
        False, _
        StringFormat('%s does not match expected type "%s".', Call($Au3ComparatorTypeComparatorExporter&"_shortenedExport", $actual), VarGetType($expected)) _
    ))
EndFunc
