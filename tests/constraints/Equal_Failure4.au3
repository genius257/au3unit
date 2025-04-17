#include "../../testCase.au3"

Global $expected[], $actual[]
$expected['foo'] = 'foo'
$expected['bar'] = 'bar'

$actual['foo'] = 'bar'
$actual['baz'] = 'bar'

assertEquals($expected, $actual)
