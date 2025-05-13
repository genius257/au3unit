#include "../../testCase.au3"

Global $expected = [[1,2,3]]
Global $actual = [[1,3,4]]

assertEquals($expected, $actual)
