#include-once


#include-once

Func Au3UnitConstraintStringStartsWith_ToString($other)
    Return StringFormat('starts with "%s"', $other)
EndFunc

Func Au3UnitConstraintStringStartsWith_Matches($other, $suffix)
    Return StringRight($other, StringLen($suffix)) == $suffix
EndFunc
