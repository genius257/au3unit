#include-once

Global Enum $Au3DiffDiffer_CLASS, $Au3DiffDiffer_outputBuilder, $Au3DiffDiffer_COUNT

;https://github.com/sebastianbergmann/diff/blob/6cf5ca93a200e009dc974f040fef5d282cf2d876/src/Differ.php

Func Au3DiffDiffer($outputBuilder = null)
    Local $this[$Au3DiffDiffer_COUNT]

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

    Return Call($this[$Au3DiffDiffer_outputBuilder][0]&"_getDiff", $this[$Au3DiffDiffer_outputBuilder], $diff)
EndFunc

Func Au3DiffDiffer_diffToArray($this, $from, $to, $lcs = Null)
    ;FIXME: https://github.com/sebastianbergmann/diff/blob/6cf5ca93a200e009dc974f040fef5d282cf2d876/src/Differ.php#L95
EndFunc
