#include "../../testCase.au3"

Global $expected = ['a', 'b', 'c']
Global $actual = ['a', 'c', 'd']

assertEquals($expected, $actual)
