#include-once

Func Au3UnitConstraintIsEmpty_ToString()
    Return 'is empty'
EndFunc

Func Au3UnitConstraintIsEmpty_Matches($other)
    If Not IsArray($other) Then Return UBound($other) = 0 ; Assume Map (this allows backwards compatibility)

    For $i = 1 To UBound($other, 0)
        If UBound($other, $i) > 0 Then Return False
    Next

    Return True
EndFunc

Func Au3UnitConstraintIsEmpty_FailureDescription($other)
    Return StringFormat( _
        '%s %s %s', _
        IsArray($other) ? 'an' : 'a', _
        StringLower(VarGetType($other)), _
        Au3UnitConstraintIsEmpty_ToString() _
    )
EndFunc
