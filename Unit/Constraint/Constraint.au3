#include-once
#include "..\ExpectationFailedException.au3"

Global Const $Au3UnitConstraintCount = 1 ;https://github.com/sebastianbergmann/phpunit/blob/7.2/src/Framework/Constraint/Constraint.php#L72

Func Au3UnitConstraintConstraint_Evaluate($constraint, $other, $description = "", $returnResult = false, $line = Null, $passedToContraint = Null)
	Local $success = False
	Local $comparisonFailure = Null

	Local $matches = Call("Au3UnitConstraint" & $constraint & "_Matches", $other, $passedToContraint, $description)
	If @error = 0xDEAD And @extended = 0xBEEF Then $matches = Call("Au3UnitConstraint" & $constraint & "_Matches", $other, $passedToContraint)
	If @error = 0xDEAD And @extended = 0xBEEF Then $matches = Call("Au3UnitConstraint" & $constraint & "_Matches", $other)
	If @error = 0xDEAD And @extended = 0xBEEF Then $matches = Call("Au3UnitConstraintConstraint_Matches", $other)
	Local $error = @error
	If $error <> 0 And Is_Au3UnitExpectationFailedException($matches) Then
		Local $e = Call($matches[0]&"_getComparisonFailure", $matches)
		$comparisonFailure = $e
		;ConsoleWrite(Call($e[0]&"_toString", $e)&@CRLF)
		;ConsoleWrite($e[0]&@CRLF)
	EndIf
	If (IsBool($matches) And $matches) Or (Not IsBool($matches)) And $comparisonFailure = Null Then $success = True
	If $returnResult Then Return ($comparisonFailure = Null) ? $success : SetError(1, 0, $matches)

	If Not $success Then
		Local $e = Call("Au3UnitConstraint" & $constraint & "_Fail", $other, $description, $comparisonFailure, $line)
		If @error = 0xDEAD And @extended = 0xBEEF Then $e = Call("Au3UnitConstraintConstraint_Fail", $constraint, $other, $description, $comparisonFailure, $line, $passedToContraint)
		If @error = 0xDEAD And @extended = 0xBEEF Then Exit MsgBox(0, "Au3Unit", "Au3UnitConstraintConstraint_Fail function is missing"&@CRLF&"Exitting") + 1
		Return SetError(@error, 0, $e)
	EndIf
EndFunc

Func Au3UnitConstraintConstraint_Fail($constraint, $other, $description, $comparisonFailure = Null, $line = Null, $passedToContraint = Null)
	Local $failureDescription = Call("Au3UnitConstraint" & $constraint & "_FailureDescription", $other, $passedToContraint)
	If @error = 0xDEAD And @extended = 0xBEEF Then $failureDescription = Call("Au3UnitConstraint" & $constraint & "_FailureDescription", $other)
	If @error = 0xDEAD And @extended = 0xBEEF Then $failureDescription = Call("Au3UnitConstraintConstraint_FailureDescription", $constraint, $other, $passedToContraint)
	$failureDescription = StringFormat("Failed asserting that %s.", $failureDescription)

	If Not ($comparisonFailure = Null) Then
		$failureDescription = StringRegExpReplace(Call($comparisonFailure[0]&"_toString", $comparisonFailure), "\n$", "")
		If @error = 0xDEAD And @extended = 0xBEEF Then ConsoleWriteError(StringFormat("Constraint.au3:%s ERROR: function %s call failure!\n", @ScriptLineNumber, $comparisonFailure[0]&"_toString"))
	EndIf

	Local $additionalFailureDescription = Call("Au3UnitConstraint" & $constraint & "_AdditionalFailureDescription", $other)
	If @error = 0xDEAD And @extended = 0xBEEF Then $additionalFailureDescription = Call("Au3UnitConstraintConstraint_AdditionalFailureDescription", $other)

	If $additionalFailureDescription Then $failureDescription &= @CRLF & $additionalFailureDescription

	If Not ($description = "") Then $failureDescription = $description & @CRLF & $failureDescription

	ConsoleWriteError($failureDescription&@CRLF&@ScriptFullPath&":"&$line&@CRLF)
	;Return SetError(1, 0, Au3UnitExpectationFailedException($failureDescription, $comparisonFailure))
	Return SetError(1)
EndFunc

Func Au3UnitConstraintConstraint_Matches($other)
	Return False
EndFunc

#include "..\..\Exporter\Exporter.au3"
Func Au3UnitConstraintConstraint_FailureDescription($constraint, $other, $passedToContraint = Null)
	Local $toString =  Call("Au3UnitConstraint" & $constraint & "_ToString", $other)
	If @error = 0xDEAD And @extended = 0xBEEF Then $toString = Call("Au3UnitConstraintConstraint_ToString", $other)
	Return Au3ExporterExporter_Export(@NumParams=3?$passedToContraint:$other) & " " & $toString
EndFunc

Func Au3UnitConstraintConstraint_AdditionalFailureDescription($other)
	Return ""
EndFunc

Func Au3UnitConstraintConstraint_ToString()
	ConsoleWriteError(StringFormat("Constraint.au3:%s ERROR: _ToString not defined for constraint!\n", @ScriptLineNumber))
	Return ""
EndFunc
