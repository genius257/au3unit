#include-once

Global Enum $Au3UnitExpectationFailedException_CLASS, $Au3UnitExpectationFailedException_comparisonFailure, $Au3UnitExpectationFailedException_COUNT

Func Au3UnitExpectationFailedException($message, $comparisonFailure = null, $previous = null)
    Local $this[$Au3UnitExpectationFailedException_COUNT]

    $this[$Au3UnitExpectationFailedException_CLASS] = "Au3UnitExpectationFailedException"
    $this[$Au3UnitExpectationFailedException_comparisonFailure] = $comparisonFailure

    Return $this
EndFunc

Func Au3UnitExpectationFailedException_getComparisonFailure($this)
    Return $this[$Au3UnitExpectationFailedException_comparisonFailure]
EndFunc

Func Au3UnitExpectationFailedException_toString($this)
    ;Return $this[message]
EndFunc
