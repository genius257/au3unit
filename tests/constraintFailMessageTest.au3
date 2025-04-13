#include "..\Unit\assert.au3"
#include "testingHelperFunctions.au3"

Global $bSuccess = True

; Generic

    assert(fail("IsIdentical", 1, 2), "Failed asserting that 1 is identical to 2.", "IsIdentical")

; Boolean

    assert(fail("IsTrue", False, False), "Failed asserting that false is true.", "IsTrue")

    assert(fail("IsFalse", True, True), "Failed asserting that true is false.", "IsFalse")

; Cardinality

    assert(fail("GreaterThan", 2, 1), "Failed asserting that 1 is greater than 2.", "IsGreaterThan")

    assert(fail("LessThan", 1, 2), "Failed asserting that 2 is less than 1.", "IsLessThan")

; COM

; Equality

    assert(fail("IsEqual", 1, 2), "Failed asserting that 2 is equal to 1.", "IsEqual")
    ;assert(fail("IsEqual", array(1,2,3), array('a','b','c')), "Failed asserting that 2 is equal to 1.", "IsEqual") ; TODO: array diff error message requires more work to fail function, to mimic real behaviour

; FileSystem

; Math

; Operator

    Global $passedToContraint = [["IsTrue", Null],["isFalse", Null]]
    assert(fail("LogicalOr", Null, $passedToContraint), "Failed asserting that null is true or is false.", "LogicalOr")

; String


If Not $bSuccess Then Exit 1

ConsoleWrite("All tests passed."&@CRLF)
Exit 0
