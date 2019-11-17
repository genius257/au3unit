#include-once
#include "..\Diff\Differ.au3"
#include "..\Diff\Output\UnifiedDiffOutputBuilder.au3"

Global Enum $Au3ComparatorComparisonFailure_CLASS, $Au3ComparatorComparisonFailure_expected, $Au3ComparatorComparisonFailure_actual, $Au3ComparatorComparisonFailure_expectedAsString, $Au3ComparatorComparisonFailure_actualAsString, $Au3ComparatorComparisonFailure_identical, $Au3ComparatorComparisonFailure_message, $Au3ComparatorComparisonFailure_COUNT

Func Au3ComparatorComparisonFailure($expected, $actual, $expectedAsString, $actualAsString, $identical = false, $message = '')
    Local $this[$Au3ComparatorComparisonFailure_COUNT]

    $this[$Au3ComparatorComparisonFailure_CLASS] = "Au3ComparatorComparisonFailure"
    $this[$Au3ComparatorComparisonFailure_expected] = $expected
    $this[$Au3ComparatorComparisonFailure_actual] = $actual
    $this[$Au3ComparatorComparisonFailure_expectedAsString] = $expectedAsString
    $this[$Au3ComparatorComparisonFailure_actualAsString] = $actualAsString
    $this[$Au3ComparatorComparisonFailure_message] = $message

    Return $this
EndFunc

Func Au3ComparatorComparisonFailure_getActual($this)
    Return $this[$Au3ComparatorComparisonFailure_actual]
EndFunc

Func Au3ComparatorComparisonFailure_getExpected($this)
    Return $this[$Au3ComparatorComparisonFailure_expected]
EndFunc

Func Au3ComparatorComparisonFailure_getActualAsString($this)
    Return $this[$Au3ComparatorComparisonFailure_actualAsString]
EndFunc

Func Au3ComparatorComparisonFailure_getExpectedAsString($this)
    Return $this[$Au3ComparatorComparisonFailure_expectedAsString]
EndFunc

Func Au3ComparatorComparisonFailure_getDiff($this)
    If (Not $this[$Au3ComparatorComparisonFailure_actualAsString]) And (Not $this[$Au3ComparatorComparisonFailure_expectedAsString]) Then Return ''

    $differ = Au3DiffDiffer(Au3DiffOutputUnifiedDiffOutputBuilder(StringFormat("\n--- Expected\n+++ Actual\n")))

    Return Call($differ[0]&"_diff", $differ, $this[$Au3ComparatorComparisonFailure_expectedAsString], $this[$Au3ComparatorComparisonFailure_actualAsString])
EndFunc

Func Au3ComparatorComparisonFailure_toString($this)
    Return $this[$Au3ComparatorComparisonFailure_message] & Au3ComparatorComparisonFailure_getDiff($this)
EndFunc
