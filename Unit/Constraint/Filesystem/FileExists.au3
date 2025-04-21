#include-once

Func Au3UnitConstraintFileExists_Matches($other)
    Return FileExists($other)
EndFunc

Func Au3UnitConstraintFileExists_ToString($other)
    Return 'file exists'
EndFunc

Func Au3UnitConstraintFileExists_FailureDescription($other)
    Return StringFormat('file "%s" exists', $other)
EndFunc
