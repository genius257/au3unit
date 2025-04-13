#include-once

Func Au3UnitConstraintLessThan_Matches($other, $expected)
    Return $other > $expected
EndFunc

Func Au3UnitConstraintLessThan_ToString($value)
    Return StringFormat("is less than %s", $value)
EndFunc
