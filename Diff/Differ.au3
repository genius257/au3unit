#include-once

#include "..\au3pm\StringRegExpSplit\StringRegExpSplit.au3"

Global Enum $Au3DiffDiffer_CLASS, $Au3DiffDiffer_outputBuilder, $Au3DiffDiffer_COUNT
Global Const $Au3DiffDiffer_OLD = 0, $Au3DiffDiffer_ADDED = 1, $Au3DiffDiffer_REMOVED = 2, $Au3DiffDiffer_DIFF_LINE_END_WARNING = 3, $Au3DiffDiffer_NO_LINE_END_EOF_WARNING = 4

;https://github.com/sebastianbergmann/diff/blob/6cf5ca93a200e009dc974f040fef5d282cf2d876/src/Differ.php

Func Au3DiffDiffer($outputBuilder = null)
    Local $this[$Au3DiffDiffer_COUNT]

    $this[$Au3DiffDiffer_CLASS] = "Au3DiffDiffer"

    If Is_Au3DiffOutputUnifiedDiffOutputBuilder($outputBuilder) Then
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
        $from = Au3DiffDiffer_splitStringByLines($this, $from)
    ElseIf Not IsArray($from) Then
        ConsoleWriteError('InvalidArgumentException: "from" must be an array or string.')
    EndIf

    If IsString($to) Then
        $to = Au3DiffDiffer_splitStringByLines($this, $to)
    ElseIf Not IsArray($to) Then
        ConsoleWriteError('InvalidArgumentException: "to" must be an array or string.')
    EndIf

    Local $_list = Au3DiffDiffer_getArrayDiffParted($from, $to); STATIC call
    $from = $_list[0]
    $to = $_list[1]
    Local $start = $_list[2]
    Local $end = $_list[3]

    If $lcs == Null Then $lcs = Au3DiffDiffer_selectLcsImplementation($this, $from, $to)

    ;Local $common = Call($lcs[0]&"_calculate", $lcs, $from, $to)
    Local $common[0];FIXME?
    Local $diff[0]

    For $token In $start
        Redim $diff[UBound($diff, 1) + 1]
        Local $_val = [$token, $Au3DiffDiffer_OLD]
        $diff[UBound($diff, 1) - 1] = $_val
    Next

    Local $dynamicIndex = 0
    Local $dynamicIndex2 = 0
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

    While Not ((Execute('$from[$dynamicIndex]') == Null) Or (Execute('$from[$dynamicIndex]') == ""))
        Redim $diff[UBound($diff, 1) + 1]
        Local $_val = [Execute('$from[$dynamicIndex]'), $Au3DiffDiffer_REMOVED]
        $diff[UBound($diff, 1) - 1] = $_val
        $dynamicIndex += 1
    WEnd

    While Not ((Execute('$to[$dynamicIndex2]') == Null) Or (Execute('$to[$dynamicIndex2]') == ""))
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

Func Au3DiffDiffer_selectLcsImplementation($this, $from, $to);FIXME?
    ; We do not want to use the time-efficient implementation if its memory
    ; footprint will probably exceed this value. Note that the footprint
    ; calculation is only an estimation for the matrix and the LCS method
    ; will typically allocate a bit more memory than this.
    ;$memoryLimit = 100 * 1024 * 1024;

    Local $aRet = ["TimeEfficientLongestCommonSubsequenceCalculator"]

    ;If ($this->calculateEstimatedFootprint($from, $to) > $memoryLimit) Then $aRet[0] = "MemoryEfficientLongestCommonSubsequenceCalculator"

    Return $aRet
EndFunc

Func Au3DiffDiffer_calculateEstimatedFootprint($this, $from, $to)
    ConsoleWriteError("FIXME: Au3DiffDiffer_calculateEstimatedFootprint"&@CRLF);FIXME
EndFunc

Func Au3DiffDiffer_detectUnmatchedLineEndings($this, $diff)
    ConsoleWriteError("FIXME: Au3DiffDiffer_detectUnmatchedLineEndings"&@CRLF);FIXME
EndFunc

Func Au3DiffDiffer_getLinebreak($this, $line)
    ConsoleWriteError("FIXME: Au3DiffDiffer_getLinebreak"&@CRLF);FIXME
EndFunc

Func Au3DiffDiffer_getArrayDiffParted(ByRef $from, ByRef $to)
    Local $k, $i
    Local $start[0]
    Local $end[0]
    Local $_from[0]
    Local $_to[0]

    Local $dynamicIndex = 0
    Local $dynamicIndex2 = 0
    For $k = 0 To UBound($from, 1)-1 Step +1
        Local $v = $from[$k]
        Local $toK = $dynamicIndex2

        If ($toK == $k And $v == $to[$k]) Then
            If UBound($start, 1) <= $k Then Redim $start[$k + 1]
            $start[$k] = $v

            $dynamicIndex = $k + 1
            $dynamicIndex2 = $k + 1
        Else
            ExitLoop
        EndIf
    Next

    Local $endDynamicIndex = UBound($from) - 1
    Local $endDynamicIndex2 = UBound($to) - 1

    While 1
        Local $fromK = $endDynamicIndex
        Local $toK = $endDynamicIndex2

        If $fromK < $dynamicIndex Or $toK < $dynamicIndex2 Or (Not ($from[$endDynamicIndex] == $to[$endDynamicIndex2])) Then ExitLoop

        $endDynamicIndex -= 1
        $endDynamicIndex2 -= 1

        Redim $end[UBound($end, 1) + 1]
        For $i = 0 To UBound($end, 1) - 2 Step +1
            $end[$i + 1] = $end[$i]
        Next
        $end[0] = $from[$fromK]
    WEnd

    For $k = $dynamicIndex To $endDynamicIndex Step +1
        Redim $_from[UBound($_from) + 1]
        $_from[UBound($_from) - 1] = $from[$k]
    Next

    For $k = $dynamicIndex2 To $endDynamicIndex2 Step +1
        Redim $_to[UBound($_to) + 1]
        $_to[UBound($_to) - 1] = $to[$k]
    Next

    ;$from reduce starting point from $dynamicIndex and end size would be based on last loop
    ;$to -||-
    Local $aRet = [$_from, $_to, $start, $end]
    Return $aRet
EndFunc
