#include-once

#include "..\au3pm\StringRegExpSplit\StringRegExpSplit.au3"

Global Enum $Au3DiffDiffer_CLASS, $Au3DiffDiffer_outputBuilder, $Au3DiffDiffer_COUNT

;https://github.com/sebastianbergmann/diff/blob/6cf5ca93a200e009dc974f040fef5d282cf2d876/src/Differ.php

Func Au3DiffDiffer($outputBuilder = null)
    Local $this[$Au3DiffDiffer_COUNT]

    $this[$Au3DiffDiffer_CLASS] = "Au3DiffDiffer"

    If Execute("$outputBuilder[0]") = "Au3DiffOutputUnifiedDiffOutputBuilder" Then
        $this[$Au3DiffDiffer_outputBuilder] = $outputBuilder
    ElseIf $outputBuilder == Null Then
        $this[$Au3DiffDiffer_outputBuilder] = Au3DiffOutputUnifiedDiffOutputBuilder()
    Else
        ConsoleWriteError(StringFormat( _
            'Expected builder to be an instance of DiffOutputBuilderInterface, <null> or a string, got %s.', _
            IsArray($outputBuilder) ? 'instance of "' & Execute('$outputBuilder[0]') & '"' : VarGetType($outputBuilder) _
        )&@CRLF)

        Return SetError(1)
    EndIf

    Return $this
EndFunc

Func Au3DiffDiffer_diff($this, $from, $to, $lcs = null)
    Local $diff = Au3DiffDiffer_diffToArray($this, Au3DiffDiffer_normalizeDiffInput($this, $from), Au3DiffDiffer_normalizeDiffInput($this, $to), $lcs)

    Return Call(($this[$Au3DiffDiffer_outputBuilder])[0]&"_getDiff", $this[$Au3DiffDiffer_outputBuilder], $diff)
EndFunc

Func Au3DiffDiffer_diffToArray($this, $from, $to, $lcs = Null); https://github.com/sebastianbergmann/diff/blob/6cf5ca93a200e009dc974f040fef5d282cf2d876/src/Differ.php#L95
    If IsString($from) Then
        Au3DiffDiffer_splitStringByLines($this, $from)
    ElseIf Not IsArray($from) Then
        ConsoleWriteError('InvalidArgumentException: "from" must be an array or string.')
    EndIf

    If IsString($to) Then
        Au3DiffDiffer_splitStringByLines($this, $to)
    ElseIf Not IsArray($to) Then
        ConsoleWriteError('InvalidArgumentException: "to" must be an array or string.')
    EndIf

    Local $_list = Au3DiffDiffer_getArrayDiffParted($from, $to); STATIC call
    Local $from = $_list[0]
    Local $to = $_list[1]
    Local $start = $_list[2]
    Local $end = $_list[3]

    If $lcs == Null Then $lcs = Au3DiffDiffer_selectLcsImplementation($this, $from, $to)

    Local $common = Call($lcs[0]&"_calculate", $lcs, $from, $to)
    Local $diff[0]

    For $token In $start
        Redim $diff[UBound($diff, 1) + 1]
        Local $_val = [$token, $Au3DiffDiffer_OLD]
        $diff[UBound($diff, 1) - 1] = $_val
    Next

    $dynamicIndex = 0
    $dynamicIndex2 = 0
    For $token In $common
        While Not (Execute('$from[$dynamicIndex]') == $token)
            Redim $diff[UBound($diff, 1) + 1]
            Local $_val = [Execute('$from[$dynamicIndex]'), $Au3DiffDiffer_REMOVED]
            $diff[UBound($diff, 1) - 1] = $_val
            $dynamicIndex += 1
        WEnd

        While Not (Execute('$to[$dynamicIndex2]') == $token)
            Redim $diff[UBound($diff, 1) + 1]
            Local $_val = [Execute('$to[$dynamicIndex2]'), $Au3DiffDiffer_ADDED]
            $diff[UBound($diff, 1) - 1] = $_val
            $dynamicIndex2 += 1
        WEnd

        Redim $diff[UBound($diff, 1) + 1]
        Local $_val = [$token, $Au3DiffDiffer_OLD]
        $diff[UBound($diff, 1) - 1] = $_val

        $dynamicIndex += 1
        $dynamicIndex2 += 1
    Next

    While Not (Execute('$from[$dynamicIndex]') == Null)
        Redim $diff[UBound($diff, 1) + 1]
        Local $_val = [Execute('$to[$dynamicIndex]'), $Au3DiffDiffer_REMOVED]
        $diff[UBound($diff, 1) - 1] = $_val
        $dynamicIndex += 1
    WEnd

    While Not (Execute('$to[$dynamicIndex2]') == Null)
        Redim $diff[UBound($diff, 1) + 1]
        Local $_val = [Execute('$to[$dynamicIndex2]'), $Au3DiffDiffer_ADDED]
        $diff[UBound($diff, 1) - 1] = $_val
        $dynamicIndex2 += 1
    WEnd

    For $token In $end
        Redim $diff[UBound($diff, 1) + 1]
        Local $_val = [$token, $Au3DiffDiffer_OLD]
        $diff[UBound($diff, 1) - 1] = $_val
    Next

    ;If Au3DiffDiffer_detectUnmatchedLineEndings($self, $diff) Then array_unshift($diff, ["#Warning: Strings contain different line endings!\n", self::DIFF_LINE_END_WARNING]);

    Return $diff
EndFunc

Func Au3DiffDiffer_normalizeDiffInput($this, $input)
    If (Not IsArray($input)) And (Not IsString($input)) Then Return String($input)

    Return $input
EndFunc

Func Au3DiffDiffer_splitStringByLines($this, $input)
    Return StringRegExpSplit($input, "(.*\R)", 0, BitOR($PREG_SPLIT_DELIM_CAPTURE, $PREG_SPLIT_NO_EMPTY))
EndFunc
