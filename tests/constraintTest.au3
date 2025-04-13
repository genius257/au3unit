#include "..\Unit\assert.au3"
#include "testingHelperFunctions.au3"

Global $bSuccess = True

; Generic

    assert(evaluate("IsIdentical", 1, 1), True, "IsIdentical positive behaviour")
    assert(evaluate("IsIdentical", 1, 1.0), False, "IsIdentical negative behaviour")

; Boolean
    assert(evaluate("IsTrue", True), True, "IsTrue positive behaviour")
    assert(evaluate("IsTrue", False), False, "IsTrue negative behaviour")

    assert(evaluate("IsFalse", False), True, "IsFalse positive behaviour")
    assert(evaluate("IsFalse", True), False, "IsFalse negative behaviour")

; Cardinality

    assert(evaluate("GreaterThan", 1, 2), True, "GreaterThan positive behaviour")
    assert(evaluate("GreaterThan", 2, 1), False, "GreaterThan negative behaviour")

    assert(evaluate("LessThan", 2, 1), True, "LessThan positive behaviour")
    assert(evaluate("LessThan", 1, 2), False, "LessThan negative behaviour")

; COM

; Equality

    assert(evaluate("IsEqual", 1, 1), True, "IsEqual positive behaviour")
    assert(evaluate("IsEqual", 1, 0), Au3UnitExpectationFailedException('0', Au3ComparatorComparisonFailure(0, 1, '', '', False, 'Failed asserting that 1 matches expected 0.')), "IsEqual negative behaviour")

    assert(evaluate("IsEqual", array(1,2,3), array(1,2,3)), True, "IsEqual array positive behaviour")
    assert(evaluate("IsEqual", array(1,2,3), array(1,2,4)), Au3UnitExpectationFailedException('0', Au3ComparatorComparisonFailure(array(1,2,4), array(1,2,3), StringFormat("Array (\n    '0' => 1\n    '1' => 2\n    '2' => 4\n)"), StringFormat("Array (\n    '0' => 1\n    '1' => 2\n    '2' => 3\n)"), 'Failed asserting that 1 matches expected 0.', 'Failed asserting that two arrays are equal.'), "IsEqual array negative behaviour"))

    ; assert(evaluate("IsEqualCanonicalizing"))
    ; assert(evaluate("IsEqualIgnoringCase"))
    ; assert(evaluate("IsEqualWithDelta"))

; FileSystem

    ; assert(evaluate("DirectoryExists", "C:\Windows"), True, "DirectoryExists positive behaviour")
    ; assert(evaluate("DirectoryExists", "C:\Windows\Temp"), False, "DirectoryExists negative behaviour")

    ; assert(evaluate("FileExists", "C:\Windows"), True, "FileExists positive behaviour")
    ; assert(evaluate("FileExists", "C:\Windows\Temp"), False, "FileExists negative behaviour")

    ; assert(evaluate("PathExists"))
    ; assert(evaluate("IsWritable"))

; Math

    ; assert(evaluate("IsFinite"))
    ; assert(evaluate("IsInfinite"))
    ; assert(evaluate("IsNan"))

; Operator

    ; assert(evaluate("BinaryOperator"))
    ; assert(evaluate("LogicalAnd"))
    ; assert(evaluate("LogicalNot"))
    ; assert(evaluate("LogicalOr"))
    ; assert(evaluate("LogicalXor"))
    ; assert(evaluate("UnaryOperator"))

; String

    ; assert(evaluate("IsJson"))
    ; assert(evaluate("RegularExpression"))
    ; assert(evaluate("StringContains"))
    ; assert(evaluate("StringEndsWith"))
    ; assert(evaluate("StringEqualsStringIgnoringLineEndings"))
    ; assert(evaluate("StringMatchesFormatDescription"))
    ; assert(evaluate("StringStartsWith"))

        ; assert(evaluate("StringContainsCanonicalizing"))
        ; assert(evaluate("StringContainsIgnoringCase"))
        ; assert(evaluate("StringEndsWith"))

; Type

    assert(evaluate("IsNull", Null), True, "IsNull positive behaviour")
    assert(evaluate("IsNull", 1), False, "IsNull negative behaviour")

    assert(evaluate("IsType", 1, "Int32"), True, "IsType positive behaviour")
    assert(evaluate("IsType", 1, "String"), False, "IsType negative behaviour")

If Not $bSuccess Then Exit 1

ConsoleWrite("All tests passed."&@CRLF)
Exit 0
