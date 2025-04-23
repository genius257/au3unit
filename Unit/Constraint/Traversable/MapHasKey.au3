#include-once
#include "..\..\..\Exporter\Exporter.au3"

Func Au3UnitConstraintMapHasKey_ToString($key)
    Return 'has the key ' & Au3ExporterExporter_export($key)
EndFunc

Func Au3UnitConstraintMapHasKey_Matches($other, $key, $description)
    If IsMap($other) Then Return Not Not MapExists($other, $key)

    Return False
EndFunc

Func Au3UnitConstraintMapHasKey_FailureDescription($other, $key)
    Return 'a map ' & Au3UnitConstraintMapHasKey_ToString($key)
EndFunc
