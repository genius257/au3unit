#include "..\..\Unit\assert.au3"

Global $a = [1,2,3]
Global $b = [1,2,3]

assertEquals($a, $b)

Global $a = [1,2,3]
Global $b = [1,2,2,4]

assertNotEquals($a, $b)
