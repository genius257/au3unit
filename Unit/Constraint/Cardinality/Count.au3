#include-once

Func Au3UnitConstraintCount_ToString($passedToContraint)
    Local $expectedCount = $passedToContraint[0]
    Return StringFormat('count matches %d', $expectedCount)
EndFunc

Func Au3UnitConstraintCount_Matches($other, $passedToContraint)
    Local $expectedCount = $passedToContraint[0]
    Local $dimension = $passedToContraint[1]
    Return UBound($other) = $expectedCount
EndFunc

Func Au3UnitConstraintCount_FailureDescription($other, $passedToContraint)
    Local $expectedCount = $passedToContraint[0]
    Local $dimension = $passedToContraint[1]
    Return StringFormat('actual size %d matches expected size %d', Au3UnitConstraintCount_GetCountOf($other), $expectedCount)
EndFunc

Func Au3UnitConstraintCount_GetCountOf($haystack, $dimension = 1)
    Return UBound($haystack, $dimension)
EndFunc
