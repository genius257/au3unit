Func Au3UnitConstraintIsType_ToString($value)
	Return StringFormat('is of type %s', $value)
EndFunc

Func Au3UnitConstraintIsType_FailureDescription($other, $exspected)
	Local $toString =  Call("Au3UnitConstraintIsType_ToString", $exspected)
	If @error = 0xDEAD And @extended = 0xBEEF Then $toString = Call("Au3UnitConstraintConstraint_ToString", $other)
	Return Au3ExporterExporter_Export($other) & " " & $toString
EndFunc

Func Au3UnitConstraintIsType_Matches($other, $expected)
	Return VarGetType($other) == $expected
EndFunc
