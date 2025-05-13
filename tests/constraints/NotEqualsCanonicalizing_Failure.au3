#include "../../testCase.au3"

Global $expected = [3, 2, 1]

Global $actual = [1, 2, 3]

assertNotEqualsCanonicalizing($expected, $actual)
