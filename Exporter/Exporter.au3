#include-once
#include <String.au3>
;https://github.com/sebastianbergmann/exporter/blob/2.0/src/Exporter.php

Func Au3ExporterExporter_export($value, $indentation = 0)
	Return Au3ExporterExporter_RecursiveExport($value, $indentation)
EndFunc

Func Au3ExporterExporter_recursiveExport(ByRef $value, $indentation, $processed = Null)
	If $value == Null Then Return "null"

	If $value == True Then Return "true"

	If $value == False Then Return "false"

	If VarGetType($value) == "Double" And Int($value) == $value Then Return StringFormat("%s.0", $value)

	If IsPtr($value) Or IsHWnd($value) Then Return StringFormat("resource(0x%.8X) of type (%s)", $value, VarGetType($value))

	if IsString($value) Then
		Return Au3ExporterExporter_exportString($value)
	EndIf

	Local $whitespace = _StringRepeat(" ", 4 * $indentation)

;~ 	If Not $processed Then $processed = new Context

	;Local $key = $processed->contains($value)
	If IsArray($value) Then
		#cs
		If Not $key == False Then Return "Array &" & $key

		Local $array = $value
		$key = $processed->add($value)
		$values = ""

		If UBound($array) > 0 Then
			Local $k
			For $k=0 To UBound($array)-1
				Local $v = $array[$k]
				$values &= StringFormat("%s    %s => %s" & @CRLF, $whitespace, Au3ExporterExporter_RecursiveExport($k, $indentation), Au3ExporterExporter_RecursiveExport($value($k), $indentation + 1, $processed))
			Next
			Local $values = "\n" & $values & $whitespace
		EndIf
		Return StringFormat("Array &%s (%s)", $key, $values)
		#ce
	EndIf

	If IsObj($value) Then
		#cs
		Local $class = get_class($value)

		Local $hash = $processed->contains($value)
		If $hash Then Return StringFormat("%s Object &%s", $class, $hash)

		$hash = $processed->add($value)
		$values = ""
		$array = $this->toArray($value)

		If UBound($array) > 0 Then
			Local $k
			For $k=0 To UBound($array)-1
				Local $v = $array[$k]
				$values &= StringFormat("%s    %s => %s" & @CRLF, $whitespace, Au3ExporterExporter_RecursiveExport($k, $indentation), Au3ExporterExporter_RecursiveExport($v, $indentation + 1, $processed))
			Next
			$values = @CRLF & $value & $whitespace
		EndIf
		Return StringFormat("%s Object &%s (%s)", $class, $hash, $values)
		#ce
	EndIf

	;Return var_export($value)
	$return = String($value)
	Return $return?$return:VarGetType($value)
EndFunc

Func Au3ExporterExporter_shortenedRecursiveExport()
	;FIXME
EndFunc

Func Au3ExporterExporter_shortenedExport($value, $maxLengthForStrings = 40)
	If IsString($value) Then
		Local $string = StringReplace(Au3ExporterExporter_exportString($value), @LF, "")
		If StringLen($string) > $maxLengthForStrings Then $string = StringMid($string, 1, $maxLengthForStrings - 10) & '...' & StringRight($string, 7)
		Return $string
	EndIf

	If IsArray($value) Then
		Return StringFormat( _
			"Array (%s)", _
			UBound($value) > 0 ? '...' : '' _
		)
	EndIf

	Return Au3ExporterExporter_export($value)
EndFunc

; https://github.com/sebastianbergmann/exporter/blob/7.0.0/src/Exporter.php#L365-L383
Func Au3ExporterExporter_exportString($value)
	; Match for most non-printable chars somewhat taking multibyte chars into account
	If StringRegExp($value, "[^\x09-\x0d\x1b\x20-\xff]") Then Return 'Binary String: ' & StringToBinary($value)

	Local $replacePairs = [ _
		[StringFormat("\r\n"), '\r\n' & @LF], _
		[StringFormat("\n\r"), '\n\r' & @LF], _
		[StringFormat("\r"), '\r' & @LF], _
		[StringFormat("\n"), '\n' & @LF] _
	]

	For $i = 0 To UBound($replacePairs, 1) - 1 Step +1
		$value = StringReplace($value, $replacePairs[$i][0], $replacePairs[$i][1])
	Next

	Return "'" & $value & "'"
EndFunc
