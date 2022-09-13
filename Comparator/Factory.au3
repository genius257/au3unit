#include-once
#include "ResourceComparator.au3"
#include "ArrayComparator.au3"
#include "ScalarComparator.au3"

Global $Au3ComparatorFactoryCustomComparators = []
Global $Au3ComparatorFactoryDefaultComparators = []

Au3ComparatorFactory_registerDefaultComparators()

Func Au3ComparatorFactory_getComparatorFor($expected, $actual)
    Local $_

    For $comparator In $Au3ComparatorFactoryCustomComparators
        If Call($comparator&"_accepts", $expected, $actual) Then Return $comparator
    Next

    For $comparator In $Au3ComparatorFactoryDefaultComparators
        If Call($comparator&"_accepts", $expected, $actual) Then Return $comparator
    Next

    Return SetError(1)
EndFunc

Func Au3ComparatorFactory_register($comparator)
    Local $iUbound = UBound($Au3ComparatorFactoryCustomComparators, 1)
    Redim $Au3ComparatorFactoryCustomComparators[$iUbound + 1]
    $Au3ComparatorFactoryCustomComparators[$iUbound] = $comparator

    Call($comparator&"_setFactory", "Au3ComparatorFactory")
    #ignorefunc Au3ComparatorComparator_setFactory
    If @error = 0xDEAD And @extended = 0xBEEF Then Call("Au3ComparatorComparator_setFactory", "Au3ComparatorFactory")
EndFunc

Func Au3ComparatorFactory_unregister($comparator)
    Local $_CustomComparators[UBound($Au3ComparatorFactoryCustomComparators, 1) - 1]
    Local $bFound = False
    Local $iIndex = 0
    For $_comparator In $Au3ComparatorFactoryCustomComparators
        If (Not $bFound) And $comparator = $_comparator Then
            $bFound = True
            $iIndex += 1
            ContinueLoop
        EndIf
        $_CustomComparators[$iIndex] = $_comparator
        $iIndex += 1
    Next

    If $bFound Then $Au3ComparatorFactoryCustomComparators = $_CustomComparators
EndFunc

Func Au3ComparatorFactory_reset()
    Redim $Au3ComparatorFactoryCustomComparators[0]
EndFunc

Func Au3ComparatorFactory_registerDefaultComparators()
    Au3ComparatorFactory_registerDefaultComparator('MockObjectComparator');TODO: maybe keep
    ;Au3ComparatorFactory_registerDefaultComparator('DateTimeComparator');TODO: maybe remove
    Au3ComparatorFactory_registerDefaultComparator('ObjectComparator');TODO: maybe keep
    Au3ComparatorFactory_registerDefaultComparator('Au3ComparatorResourceComparator')
    Au3ComparatorFactory_registerDefaultComparator('Au3ComparatorArrayComparator')
    Au3ComparatorFactory_registerDefaultComparator('DoubleComparator')
    Au3ComparatorFactory_registerDefaultComparator('NumericComparator')
    Au3ComparatorFactory_registerDefaultComparator('Au3ComparatorScalarComparator')
    Au3ComparatorFactory_registerDefaultComparator('TypeComparator')
EndFunc

Func Au3ComparatorFactory_registerDefaultComparator($comparator)
    Local $iUbound = UBound($Au3ComparatorFactoryDefaultComparators, 1)
    Redim $Au3ComparatorFactoryDefaultComparators[$iUbound + 1]
    $Au3ComparatorFactoryDefaultComparators[$iUbound] = $comparator
EndFunc
