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
		Case "numeric"
			; RegExp based on pattern from https://www.php.net/manual/en/language.types.numeric-strings.php
			If $expected = "String" Then Return StringRegExp($sString, _
				"(?(DEFINE)" & _
				"(?<WHITESPACES>\s*)" & _
				"(?<LNUM>[0-9]+)" & _
				"(?<DNUM>([0-9]*\.(?&LNUM))|((?&LNUM)\.[0-9]*))" & _
				"(?<EXPONENT_DNUM>(((?&LNUM)|(?&DNUM))[eE][+-]?(?&LNUM)))" & _
				"(?<INT_NUM_STRING>(?&WHITESPACES)[+-]?(?&LNUM)(?&WHITESPACES))" & _
				"(?<FLOAT_NUM_STRING>(?&WHITESPACES)[+-]?((?&EXPONENT_DNUM)|(?&DNUM))(?&WHITESPACES))" & _
				"(?<NUM_STRING>((?&FLOAT_NUM_STRING)|(?&INT_NUM_STRING)))" & _
				")^(?&NUM_STRING)$" _; WARNING: PCRE v1 does not handle recursion as well as PCRE2. False negatives are possible, because of this.
			)
			ContinueCase
		Case "number"
			Return $actual = "Int32" Or $actual = "Int64" Or $actual = "Double"
		Case "callable"
			If $actual = "String" And StringRegExp($other, "^[a-zA-Z_][a-zA-Z0-9_]*$") Then $actual = VarGetType(Execute($other)) ; Try to resolve function name
			Return $actual = "Function" Or $actual = "UserFunction"
		Case "float"
			$expected = "Double"
			ContinueCase
		Case Else
			Return $expected = $actual
	EndSwitch
EndFunc
