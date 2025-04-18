#include-once
#include <StringConstants.au3>
#include "../../../Diff/Differ.au3"
#include "../../../Diff/Output/UnifiedDiffOutputBuilder.au3"

; https://github.com/sebastianbergmann/phpunit/blob/f681fb1086ba6f97afb3d51880feddda4e993b27/src/Framework/Constraint/String/StringMatchesFormatDescription.php

Func Au3UnitConstraintStringMatchesFormatDescription_ToString($formatDescription)
    MsgBox(0, "", "")
    return StringFormat('matches format description:\n%s', $formatDescription);
EndFunc

Func Au3UnitConstraintStringMatchesFormatDescription_Matches($other, $formatDescription)
    $other = Au3UnitConstraintStringMatchesFormatDescription_ConvertNewlines($other)

    Local $matches = StringRegExp( _
        $other, _
        Au3UnitConstraintStringMatchesFormatDescription_RegularExpressionForFormatDescription( _
            Au3UnitConstraintStringMatchesFormatDescription_ConvertNewlines($formatDescription) _
        ) _
    )

    Return $matches > 0
EndFunc

Func Au3UnitConstraintStringMatchesFormatDescription_FailureDescription($other)
    return 'string matches format description'
EndFunc

Func Au3UnitConstraintStringMatchesFormatDescription_AdditionalFailureDescription($other, $formatDescription)
    Local $from = StringSplit($formatDescription, @LF, $STR_NOCOUNT)
    Local $to = StringSplit($other, @LF, $STR_NOCOUNT)

    Local $line
    For $index = 0 To UBound($from) - 1 Step +1
        $line = $from[$index]
        If UBound($to) <= $index And Not ($line == $to[$index]) Then
            $line = Au3UnitConstraintStringMatchesFormatDescription_RegularExpressionForFormatDescription($line)

            If (StringRegExp($to[$index], $line) > 0) Then $from[$index] = $to[$index]
        EndIf
    Next

    ;implode $from and $to
    Local $_from = "", $_to = ""
    For $i = 0 To UBound($from) - 1 Step +1
        If $i > 0 Then $_from &= @LF
        $_from &= $from[$i]
    Next

    For $i = 0 To UBound($to) - 1 Step +1
        If $i > 0 Then $_to &= @LF
        $_to &= $to[$i]
    Next

    Return Au3DiffDiffer_diff(Au3UnitConstraintStringMatchesFormatDescription_Differ(), $_from, $_to)
EndFunc

Func Au3UnitConstraintStringMatchesFormatDescription_RegularExpressionForFormatDescription($string)
    Local Static $replacePairs = [ _
        ['%%', '%'], _
        ['%e', '\/'], _ ; '%e' => preg_quote(DIRECTORY_SEPARATOR, '/')
        ['%s', '[^\r\n]+'], _
        ['%S', '[^\r\n]*'], _
        ['%a', '.+?'], _
        ['%A', '.*?'], _
        ['%w', '\s*'], _
        ['%i', '[+-]?\d+'], _
        ['%d', '\d+'], _
        ['%x', '[0-9a-fA-F]+'], _
        ['%f', '[+-]?(?:\d+|(?=\.\d))(?:\.\d+)?(?:[Ee][+-]?\d+)?'], _
        ['%c', '.'], _
        ['%0', '\x00'] _
    ]

    $string = StringRegExpReplace($string, '[.\\+*?[^\]$(){}=!<>|:\-#\/]', '\\$0') ; preg_quote($string, '/')
    For $i = 0 To UBound($replacePairs, 1) - 1 Step +1
        $string = StringRegExpReplace($string, $replacePairs[$i][0], $replacePairs[$i][1])
    Next

    Return '(?s)^' & $string & '$'
EndFunc

Func Au3UnitConstraintStringMatchesFormatDescription_ConvertNewlines($text)
    Return StringRegExpReplace($text, '\r\n', '\n')
EndFunc

Func Au3UnitConstraintStringMatchesFormatDescription_Differ()
    Return Au3DiffDiffer(Au3DiffOutputUnifiedDiffOutputBuilder(StringFormat("--- Expected\n+++ Actual\n")))
EndFunc
