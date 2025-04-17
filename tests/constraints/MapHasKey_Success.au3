#include "../../testCase.au3"

Global $map[]
$map['foo'] = 'bar'
assertMapHasKey('foo', $map)
