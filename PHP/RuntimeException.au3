#include-once

Global Enum $Au3PhpRuntimeException_CLASS, $Au3PhpRuntimeException_message, $Au3PhpRuntimeException_string, $Au3PhpRuntimeException_code, $Au3PhpRuntimeException_file, $Au3PhpRuntimeException_line, $Au3PhpRuntimeException_trace, $Au3PhpRuntimeException_previous, $Au3PhpRuntimeException_COUNT

Func Au3PhpRuntimeException($message = "", $code = 0, $previous = null)
    Local $this[$Au3PhpRuntimeException_COUNT]

    $this[$Au3PhpRuntimeException_CLASS] = "Au3PhpRuntimeException"
    $this[$Au3PhpRuntimeException_message] = $message
    $this[$Au3PhpRuntimeException_code] = $code
    $this[$Au3PhpRuntimeException_previous] = $previous

    Return $this
EndFunc

Func Au3PhpRuntimeException_getMessage($this)
    Return $this[$Au3PhpRuntimeException_message]
EndFunc

Func Au3PhpRuntimeException_toString($this)
    Return Au3PhpRuntimeException_getMessage($this)
EndFunc
