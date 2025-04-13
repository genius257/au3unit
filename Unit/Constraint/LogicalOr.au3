#include-once

Func Au3UnitConstraintLogicalOr_Evaluate($other, $description = "", $returnResult = false, $line = Null, $expected = Null)
    Local $comparisonFailure = Null
    Local $success = false

    Local $x, $error, $comparisonFailures[UBound($expected)], $comparisonFailureCount = 0
    For $i = 0 To UBound($expected) - 1
        $x = Call("Au3UnitConstraint" & $expected[$i][0] & "_Evaluate", $other, $description, True, $line, $expected[$i][1])
        If @error = 0xDEAD And @extended = 0xBEEF Then $x = Call("Au3UnitConstraint" & $expected[$i][0] & "_Evaluate", $other, $description, True, $line)
        If @error = 0xDEAD And @extended = 0xBEEF Then $x = Call("Au3UnitConstraintConstraint_Evaluate", $expected[$i][0], $other, $description, True, $line, $expected[$i][1])
        $error = @error

        If $error <> 0 And Is_Au3UnitExpectationFailedException($x) Then
            $e = Call($x[0]&"_getComparisonFailure", $x)
            $comparisonFailures[$comparisonFailureCount] = $e
            $comparisonFailureCount += 1
            ContinueLoop
        EndIf
        If $x Then
            $success = true
            ExitLoop
        EndIf
    Next

    If $comparisonFailureCount = UBound($expected) Then
        ;TODO: this might need to be implemented!
        ;$comparisonFailure = Au3UnitExpectationFailedException("test")
    EndIf

    If $returnResult Then Return ($comparisonFailure = Null) ? $success : SetError(0, 0, $x)

    if Not $success Then
        If (Not $success) Or ($comparisonFailure = Null) Then
            Call("Au3UnitConstraintLogicalOr_Fail", $other, $description, $comparisonFailure, $line, $expected)
            ; If @error = 0xDEAD And @extended = 0xBEEF Then Call("Au3UnitConstraintConstraint_Fail", "LogicalOr", $other, $description, $comparisonFailure, $line, $expected)
            If @error = 0xDEAD And @extended = 0xBEEF Then Call("Au3UnitConstraintConstraint_Fail", "LogicalOr", $other, $description, Null, $line, $expected)
            If @error = 0xDEAD And @extended = 0xBEEF Then Exit MsgBox(0, "Au3Unit", "Au3UnitConstraintConstraint_Fail function is missing"&@CRLF&"Exitting") + 1
            Return SetError(@error)
        EndIf
        return setError(1)
    EndIf
EndFunc

Func Au3UnitConstraintLogicalOr_FailureDescription($other, $passedToContraint = Null)
    Local $constraint = "LogicalOr"
    Local $toString =  Call("Au3UnitConstraint" & $constraint & "_ToString", $other, $passedToContraint)
    If @error = 0xDEAD And @extended = 0xBEEF Then $toString = Call("Au3UnitConstraint" & $constraint & "_ToString", $other)
    If @error = 0xDEAD And @extended = 0xBEEF Then $toString = Call("Au3UnitConstraintConstraint_ToString", $other)
    Return Au3ExporterExporter_Export(@NumParams=2?$passedToContraint[0][1]:$other) & " " & $toString ; WARNING: $passedToContraint[0][1] may not always be correct! This is a limitation of this psudo-class implementation. So without redesigning the implementation this is the best we can do
EndFunc

Func Au3UnitConstraintLogicalOr_ToString($other, $constraints = Null)
    Local $text = ''

    Local $constraint, $failureDescription
    For $key = 0 To UBound($constraints) - 1
        $constraint = $constraints[$key][0]

        If $key > 0 Then $text &= ' or '

        $failureDescription = Call("Au3UnitConstraint" & $constraint & "_ToString", $other)
        If @error = 0xDEAD And @extended = 0xBEEF Then $failureDescription = Call("Au3UnitConstraintConstraint_ToString", $other)

        $text &= $failureDescription
    Next

    Return $text
EndFunc
