#include-once

;https://github.com/sebastianbergmann/phpunit/blob/5c7620ef0c30d16e352cd71d9a36b91c6fd5af29/src/Framework/Exception/ExpectationFailedException.php

Global Enum $Au3UnitExpectationFailedException_CLASS, $Au3UnitExpectationFailedException_message, $Au3UnitExpectationFailedException_comparisonFailure, $Au3UnitExpectationFailedException_COUNT

Func Au3UnitExpectationFailedException($message, $comparisonFailure = null, $previous = null)
    Local $this[$Au3UnitExpectationFailedException_COUNT]

    $this[$Au3UnitExpectationFailedException_CLASS] = "Au3UnitExpectationFailedException"
    $this[$Au3UnitExpectationFailedException_message] = $message
    $this[$Au3UnitExpectationFailedException_comparisonFailure] = $comparisonFailure

    Return $this
EndFunc

Func Au3UnitExpectationFailedException_getComparisonFailure($this)
    Return $this[$Au3UnitExpectationFailedException_comparisonFailure]
EndFunc

Func Au3UnitExpectationFailedException_getMessage($this)
    Return $this[$Au3UnitExpectationFailedException_message]
EndFunc

Func Au3UnitExpectationFailedException_toString($this)
    Return Au3UnitExpectationFailedException_getMessage($this)
EndFunc
