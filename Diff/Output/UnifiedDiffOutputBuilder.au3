#include-once
#include "..\Differ.au3"

Func Is_Au3DiffOutputUnifiedDiffOutputBuilder($this)
    Return Execute("$this[$Au3DiffOutputUnifiedDiffOutputBuilder_CLASS]") == "Au3DiffOutputUnifiedDiffOutputBuilder"
EndFunc

Global Enum $Au3DiffOutputUnifiedDiffOutputBuilder_CLASS, $Au3DiffOutputUnifiedDiffOutputBuilder_collapseRanges, $Au3DiffOutputUnifiedDiffOutputBuilder_commonLineThreshold, $Au3DiffOutputUnifiedDiffOutputBuilder_contextLines, $Au3DiffOutputUnifiedDiffOutputBuilder_header, $Au3DiffOutputUnifiedDiffOutputBuilder_addLineNumbers, $Au3DiffOutputUnifiedDiffOutputBuilder_COUNT

Func Au3DiffOutputUnifiedDiffOutputBuilder($header = StringFormat("--- Original\n+++ New\n"), $addLineNumbers = False)
    Local $this[$Au3DiffOutputUnifiedDiffOutputBuilder_COUNT]

    $this[$Au3DiffOutputUnifiedDiffOutputBuilder_collapseRanges] = True
    $this[$Au3DiffOutputUnifiedDiffOutputBuilder_commonLineThreshold] = 6
    $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines] = 3

    $this[$Au3DiffOutputUnifiedDiffOutputBuilder_CLASS] = "Au3DiffOutputUnifiedDiffOutputBuilder"
    $this[$Au3DiffOutputUnifiedDiffOutputBuilder_header] = $header
    $this[$Au3DiffOutputUnifiedDiffOutputBuilder_addLineNumbers] = $addLineNumbers

    Return $this
EndFunc

Func Au3DiffOutputUnifiedDiffOutputBuilder_getDiff($this, $diff)
    Local $buffer = ""
    If Not ('' == $this[$Au3DiffOutputUnifiedDiffOutputBuilder_header]) Then
        $buffer &= $this[$Au3DiffOutputUnifiedDiffOutputBuilder_header]

        If Not StringRegExp($this[$Au3DiffOutputUnifiedDiffOutputBuilder_header], "\n$") Then
            $buffer &= StringFormat("\n")
        EndIf
    EndIf

    If Not (0 == UBound($diff, 1)) Then
        Au3DiffOutputUnifiedDiffOutputBuilder_writeDiffHunks($this, $buffer, $diff)
    EndIf

    $diff = $buffer

    Return (Not StringRegExp($diff, "(\n|\r)$")) ? $diff & StringFormat("\n") : $diff
EndFunc

Func Au3DiffOutputUnifiedDiffOutputBuilder_writeDiffHunks($this, ByRef $output, $diff)
    Local $upperLimit = UBound($diff, 1)

    If 0 == ($diff[$upperLimit - 1])[1] Then
        ;If Not StringRegExp($diff[$upperLimit - 1][0], "\n$") Then array_splice($diff, $upperLimit, 0, [["\n\\ No newline at end of file\n", Differ::NO_LINE_END_EOF_WARNING]])
    Else
        ; search back for the last `+` and `-` line,
        ; check if has trailing linebreak, else add under it warning under it

        #cs
        $toFind = [1 => true, 2 => true];
        for ($i = $upperLimit - 1; $i >= 0; --$i) {
            if (isset($toFind[$diff[$i][1]])) {
                unset($toFind[$diff[$i][1]]);
                $lc = \substr($diff[$i][0], -1);
                if ("\n" !== $lc) {
                    \array_splice($diff, $i + 1, 0, [["\n\\ No newline at end of file\n", Differ::NO_LINE_END_EOF_WARNING]]);
                }
                if (!\count($toFind)) {
                    break;
                }
            }
        }
        #ce
    EndIf

    ; write hunks to output buffer
    Local $cutOff = _Max($this[$Au3DiffOutputUnifiedDiffOutputBuilder_commonLineThreshold], $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines])
    Local $hunkCapture = False
    Local $fromRange = 0
    Local $toRange = $fromRange
    Local $sameCount = $toRange
    Local $fromStart = 1
    Local $toStart = $fromStart

    Local $i
    For $i = 0 To UBound($diff, 1)-1 Step +1
        $entry = $diff[$i]
        If 0 = $entry[1] Then ;same
            If False == $hunkCapture Then
                $fromStart += 1
                $toStart += 1

                ContinueLoop
            EndIf

            $sameCount += 1
            $toRange += 1
            $fromRange += 1

            If $sameCount = $cutOff Then
                Local $contextStartOffset = ($hunkCapture - $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines]) < 0 ? $hunkCapture : $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines]

                ; note: $contextEndOffset = $this->contextLines;
                ;
                ; because we never go beyond the end of the diff.
                ; with the cutoff/contextlines here the follow is never true;
                ;
                ; if ($i - $cutOff + $this->contextLines + 1 > \count($diff)) {
                ;    $contextEndOffset = count($diff) - 1;
                ; }
                ;
                ; ; that would be true for a trailing incomplete hunk case which is dealt with after this loop

                Au3DiffOutputUnifiedDiffOutputBuilder_writeHunk($this, _
                    $diff, _
                    $hunkCapture - $contextStartOffset, _
                    $i - $cutOff + $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines] + 1, _
                    $fromStart - $contextStartOffset, _
                    $fromRange - $cutOff + $contextStartOffset + $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines], _
                    $toStart - $contextStartOffset, _
                    $toRange - $cutOff + $contextStartOffset + $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines], _
                    $output _
                )

                $fromStart += $fromRange
                $toStart += $toRange

                $hunkCapture = False
                $fromRange = 0
                $toRange = $fromRange
                $sameCount = $toRange
            EndIf

            ContinueLoop
        EndIf

        $sameCount = 0

        If $entry[1] == $Au3DiffDiffer_NO_LINE_END_EOF_WARNING Then ContinueLoop

        If False == $hunkCapture Then $hunkCapture = $i

        If $Au3DiffDiffer_ADDED == $entry[1] Then $toRange += 1

        If $Au3DiffDiffer_REMOVED == $entry[1] Then $fromRange -= 1
    Next

    If False == $hunkCapture Then Return Null

    ; we end here when cutoff (commonLineThreshold) was not reached, but we where capturing a hunk,
    ; do not render hunk till end automatically because the number of context lines might be less than the commonLineThreshold

    $contextStartOffset = $hunkCapture - $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines] < 0 ? $hunkCapture : $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines]

    ; prevent trying to write out more common lines than there are in the diff _and_
    ; do not write more than configured through the context lines
    $contextEndOffset = _Min($sameCount, $this[$Au3DiffOutputUnifiedDiffOutputBuilder_contextLines])

    $fromRange -= $sameCount
    $toRange -= $sameCount

    Au3DiffOutputUnifiedDiffOutputBuilder_writeHunk($this, _
        $diff, _
        $hunkCapture - $contextStartOffset, _
        $i - $sameCount + $contextEndOffset + 1, _
        $fromStart - $contextStartOffset, _
        $fromRange + $contextStartOffset + $contextEndOffset, _
        $toStart - $contextStartOffset, _
        $toRange + $contextStartOffset + $contextEndOffset, _
        $output _
    )
EndFunc

Func Au3DiffOutputUnifiedDiffOutputBuilder_writeHunk($this, $diff, $diffStartIndex, $diffEndIndex, $fromStart, $fromRange, $toStart, $toRange, ByRef $output)
    If $this[$Au3DiffOutputUnifiedDiffOutputBuilder_addLineNumbers] Then
        $output &= '@@ -' & $fromStart

        If (Not $this[$Au3DiffOutputUnifiedDiffOutputBuilder_collapseRanges]) Or Not (1 == $fromRange) Then $output &= ',' & $fromRange

        $output &= ' +' & $toStart

        If (Not $this[$Au3DiffOutputUnifiedDiffOutputBuilder_collapseRanges]) Or Not (1 == $toRange) Then $output &= ',' & $toRange

        $output &= StringFormat(" @@\n")
    Else
        $output &= StringFormat("@@ @@\n")
    EndIf

    Local $i

    If UBound($diff) < $diffEndIndex Then
        ConsoleWrite(StringFormat("UnifiedDiffOutputBuilder.au3:%s ERROR: $diffEndIndex too big!\n", @ScriptLineNumber))
        $diffEndIndex = UBound($diff)
    EndIf

    For $i = $diffStartIndex To $diffEndIndex - 1 Step +1
        If ($diff[$i])[1] == $Au3DiffDiffer_ADDED Then
            $output &= '+' & ($diff[$i])[0]
        ElseIf ($diff[$i])[1] == $Au3DiffDiffer_REMOVED Then
            $output &= '-' & ($diff[$i])[0]
        ElseIf ($diff[$i])[1] == $Au3DiffDiffer_OLD Then
            $output &= ' ' & ($diff[$i])[0]
        ElseIf ($diff[$i])[1] == $Au3DiffDiffer_NO_LINE_END_EOF_WARNING Then
            $output &= StringFormat("\n")
        Else ; Not changed (old) Differ::OLD or Warning Differ::DIFF_LINE_END_WARNING
            $output &= ' ' & ($diff[$i])[0]
        EndIf
    Next
EndFunc
