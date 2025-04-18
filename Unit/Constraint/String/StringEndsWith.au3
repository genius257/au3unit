#include-once

Func Au3UnitConstraintStringEndsWith_ToString($other)
    Return StringFormat('ends with "%s"', $other)
EndFunc

Func Au3UnitConstraintStringEndsWith_Matches($other, $suffix)
    Return StringRight($other, StringLen($suffix)) == $suffix
EndFunc
