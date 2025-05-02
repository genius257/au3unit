Func Au3UnitConstraintIsType_ToString($value)
	Return StringFormat('is of type %s', $value)
EndFunc

Func Au3UnitConstraintIsType_FailureDescription($other, $exspected)
	Local $toString =  Call("Au3UnitConstraintIsType_ToString", $exspected)
	If @error = 0xDEAD And @extended = 0xBEEF Then $toString = Call("Au3UnitConstraintConstraint_ToString", $other)
	Return Au3ExporterExporter_Export($other) & " " & $toString
EndFunc

Func Au3UnitConstraintIsType_Matches($other, $expected)
	$expected = StringLower($expected)
	$actual = StringLower(VarGetType($other))

	Switch $expected
		Case "int"
			Return $actual = "Int32" Or $actual = "Int64"
		Case "number"
			Return $actual = "Int32" Or $actual = "Int64" Or $actual = "Double"
		Case "callable"
			If $actual = "String" And StringRegExp($other, "^[a-zA-Z_][a-zA-Z0-9_]*$") Then $actual = VarGetType(Execute($other)) ; Try to resolve function name
			Return $actual = "Function" Or $actual = "UserFunction"
		Case Else
			Return $expected = $actual
	EndSwitch
EndFunc
