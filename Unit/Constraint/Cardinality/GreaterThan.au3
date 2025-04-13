#include-once

Func Au3UnitConstraintGreaterThan_Matches($other, $expected)
    Return $other < $expected
EndFunc

Func Au3UnitConstraintGreaterThan_ToString($value)
    Return StringFormat("is greater than %s", $value)
EndFunc
