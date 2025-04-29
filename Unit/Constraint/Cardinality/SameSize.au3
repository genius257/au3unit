#include-once

Func Au3UnitConstraintSameSize_Matches($other, $expected)
    For $i = 0 To UBound($expected, 0)
        If UBound($other, $i) <> UBound($expected, $i) Then
            Return False
        EndIf
    Next

    return True
EndFunc

Func Au3UnitConstraintSameSize_ToString($value)
    Local $otherString = ""
    For $i = 1 To UBound($value, 0)
        $otherString &= '[' & UBound($value, $i) & ']'
    Next
    Return StringFormat('count matches %d', $otherString)
EndFunc

Func Au3UnitConstraintSameSize_FailureDescription($other, $expected)
    Local $otherString = ""
    For $i = 1 To UBound($expected, 0)
        $otherString &= '[' & UBound($other, $i) & ']'
    Next
    
    Local $expectedString = ""
    For $i = 1 To UBound($expected, 0)
        $expectedString &= '[' & UBound($expected, $i) & ']'
    Next

    Return StringFormat('actual size %s matches expected size %s', $otherString, $expectedString)
EndFunc
