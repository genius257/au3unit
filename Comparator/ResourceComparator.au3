#include-once
#include "..\Exporter\Exporter.au3"

Global $Au3ComparatorResourceComparatorFactory
Global $Au3ComparatorResourceComparatorExporter = "Au3ExporterExporter"

Func Au3ComparatorResourceComparator_setFactory($factory)
    $Au3ComparatorResourceComparatorFactory = $factory
EndFunc

Func Au3ComparatorResourceComparator_isResource($variable)
    ; https://www.php.net/manual/en/function.is-resource.php

    Return IsPtr($variable) Or IsHWnd($variable)
EndFunc

Func Au3ComparatorResourceComparator_accepts($expected, $actual)
    Return (Au3ComparatorResourceComparator_isResource($expected) And Au3ComparatorResourceComparator_isResource($actual))
EndFunc

Func Au3ComparatorResourceComparator_assertEquals($expected, $actual, $delta = 0.0, $canonicalize = false, $ignoreCase = false)
    If Not ($expected = $actual) Then Return SetError(1, 0, Au3ComparatorComparisonFailure( _
        $expected, _
        $actual, _
        Call($Au3ComparatorResourceComparatorExporter&"_export", $expected), _
        Call($Au3ComparatorResourceComparatorExporter&"_export", $actual) _
    ))
EndFunc
