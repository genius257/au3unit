#include "../../testCase.au3"

Global $expected = [3, 2, 1]

Global $actual = [2, 3, 0, 1]

assertNotEqualsCanonicalizing($expected, $actual)
