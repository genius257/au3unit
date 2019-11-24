#include-once
#include <Array.au3>
#include "..\..\Comparator\Factory.au3"
#include "..\ExpectationFailedException.au3"
#include "..\..\Exporter\Exporter.au3"

;https://github.com/sebastianbergmann/phpunit/blob/master/src/Framework/Constraint/IsEqual.php
;shallow implementation

Func Au3UnitConstraintIsEqual_Matches($other, $exspected, $description)
	; If $exspected and $other are identical, they are also equal.
	; This is the most common path and will allow us to skip
	; initialization of all the comparators.
	;If $exspected == $other Then return True

	$comparator = Au3ComparatorFactory_getComparatorFor($exspected, $other)
	If @error <> 0 Then ConsoleWriteError("no comparator found!"&@CRLF)
	$e = Call($comparator&"_assertEquals", $exspected, $other) ;FIXME: expect array, to allow comparator to return messsage and assertion result
	If @error = 0xDEAD And @extended = 0xBEEF Then ConsoleWriteError($comparator&"_assertEquals function is missing"&@CRLF)
	If @error <> 0 And Execute("$e[0]") = "Au3ComparatorComparisonFailure" Then
		Return SetError(1, 0, Au3UnitExpectationFailedException(StringRegExpReplace($description & @CRLF & Call($e[0]&"_getMessage", $e), "(?(DEFINE)(?<range>[ \t\n\r\0\x0B]*))(^(?&range)|(?&range)$)", ""), $e))
	ElseIf @error <> 0 Then
		;ConsoleWriteError()
		Return False
	EndIf
	Return True
EndFunc

Func Au3UnitConstraintIsEqual_ToString($a)
	Local $delta = ''
	
	If IsString($a) Then
		If StringRegExp($a, "\n") Then Return 'is equal to <text>'

		Return StringFormat("is equal to '%s'", $a)
	EndIf

	;NOTE: does not support delta, currently. Would require the entire Unit framework to support the class model

	Return StringFormat("is equal to %s%s", Au3ExporterExporter_export($a), $delta)
EndFunc
#cs
#include <Array.au3>

Dim $aArray[3][1][2] = [[['a','a1']],[['b','b1']],[['c','c1']]]

$count = 0
Dim $index[UBound($aArray, 0)]
For $i = 0 To UBound($index)-1
	$index[$i] = 0
Next

While 1
	ConsoleWrite($index[0])

	$val = Execute(StringFormat("$aArray[%s]", _ArrayToString($index, "][")))
	ConsoleWrite(StringFormat('index: [%s] = %s', _ArrayToString($index, "]["), $val)&@CRLF)

	$innerIndex = UBound($index, 1)
	While 1
		$innerIndex-=1
		If $innerIndex < 0 Then ExitLoop
		$index[$innerIndex] += 1
		If Not ($index[$innerIndex] >= UBound($aArray, $innerIndex + 1)) Then
			ExitLoop
		EndIf
		If $innerIndex = 0 And $index[$innerIndex] = UBound($aArray, 1) Then ExitLoop 2
		$index[$innerIndex] = 0
	WEnd

	$count += 1
WEnd
#ce