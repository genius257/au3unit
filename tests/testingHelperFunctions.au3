Func evaluate($sConstraint, $vValue, $vPassedToContraint = Null)
    $line = 123;
    $message = Null
    Local $e = Call("Au3UnitConstraint" & $sConstraint & "_Evaluate", $vValue, $message, True, $line, $vPassedToContraint)
    If @error==0xDEAD And @extended==0xBEEF Then $e = Call("Au3UnitConstraintConstraint_Evaluate", $sConstraint, $vValue, $message, True, $line, $vPassedToContraint)
    Return $e
EndFunc

Func fail($sConstraint, $vValue, $vPassedToContraint = Null, $comparisonFailure = Null)
    $line = 123;
    $message = Null
    
    Local $failureDescription = Call("Au3UnitConstraint" & $sConstraint & "_FailureDescription", $vValue, $vPassedToContraint)
	If @error = 0xDEAD And @extended = 0xBEEF Then $failureDescription = Call("Au3UnitConstraint" & $sConstraint & "_FailureDescription", $vValue)
	If @error = 0xDEAD And @extended = 0xBEEF Then $failureDescription = Call("Au3UnitConstraintConstraint_FailureDescription", $sConstraint, $vValue, $vPassedToContraint)
	$failureDescription = StringFormat("Failed asserting that %s.", $failureDescription)

	If Not ($comparisonFailure = Null) Then
		$failureDescription = StringRegExpReplace(Call($comparisonFailure[0]&"_toString", $comparisonFailure), "\n$", "")
		If @error = 0xDEAD And @extended = 0xBEEF Then ConsoleWriteError(StringFormat("Constraint.au3:%s ERROR: function %s call failure!\n", @ScriptLineNumber, $comparisonFailure[0]&"_toString"))
	EndIf

	Local $additionalFailureDescription = Call("Au3UnitConstraint" & $sConstraint & "_AdditionalFailureDescription", $vValue)
	If @error = 0xDEAD And @extended = 0xBEEF Then $additionalFailureDescription = Call("Au3UnitConstraintConstraint_AdditionalFailureDescription", $vValue)

	If $additionalFailureDescription Then $failureDescription &= @CRLF & $additionalFailureDescription

    Return $failureDescription
EndFunc

Func equal($a, $b)
    Switch VarGetType($a)
        Case 'Array'
            If Not IsArray($b) Then Return False
            If Not (UBound($a, 0) = UBound($b, 0)) Then Return False
            If Not (UBound($a, 1) = UBound($b, 1)) Then Return False
            For $i = 0 To UBound($a) - 1
                If Not equal($a[$i], $b[$i]) Then Return False
            Next
        Case 'String'
            If Not IsString($b) Then Return False
            Return $a == $b
        Case Else
            Return $a = $b
    EndSwitch

    Return True
EndFunc

Func export($value)
    If IsArray($value) Then
        $return = '['
        For $i = 0 To UBound($value) - 1
            $return &= export($value[$i])
            If $i < UBound($value) - 1 Then $return &= ','
        Next
        Return $return & ']'
    EndIf

    return StringRegExpReplace(StringRegExpReplace(Au3ExporterExporter_export($value), "\r?\n", "\\n"), "(?!^)'(?!$)", "\\'")
EndFunc

Func assert($value, $expected, $message = Null, $line = @ScriptLineNumber)
    $evaluation = equal($value, $expected)

    If Not $evaluation Then
        $bSuccess = False
        If Not ($message = Null) Then ConsoleWriteError($message&@LF)
        ConsoleWriteError(StringFormat("Assertion failed at line %s\n    Expected: %s\n    Actual:   %s\n", $line, export($expected), export($value)))
    EndIf
EndFunc

Func array($v1 = Null, $v2 = Null, $v3 = Null, $v4 = Null, $v5 = Null, $v6 = Null, $v7 = Null, $v8 = Null, $v9 = Null, $v10 = Null)
    Local $array[@NumParams]
    For $i = 1 To @NumParams
        $array[$i - 1] = Execute(StringFormat("$v%s", $i))
    Next
    Return $array
EndFunc
