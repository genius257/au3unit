#include-once
#include "..\Exporter\Exporter.au3"

Global $Au3ComparatorObjectComparatorFactory
Global $Au3ComparatorObjectComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorObjectComparator_setFactory($factory)
    $Au3ComparatorResourceComparatorFactory = $factory
EndFunc

Func Au3ComparatorObjectComparator_accepts($expected, $actual)
    Return IsObj($expected) And IsObj($actual)
EndFunc

Func Au3ComparatorObjectComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = false, $ignoreCase = false)
    If Not (Ptr($expected) = Ptr($actual)) Then Return SetError(1, 0, Au3ComparatorComparisonFailure( _
        $expected, _
        $actual, _
        '', _;Call($Au3ComparatorObjectComparatorExporter&"_export", $expected), _
        '', _;Call($Au3ComparatorObjectComparatorExporter&"_export", $actual), _
        False, _
        'Failed asserting that two objects are equal.' _
    ))
EndFunc
