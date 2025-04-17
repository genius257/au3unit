#include "../../testCase.au3"

Global $map[]
$map['bar'] = 'baz'
assertMapHasKey('foo', $map)
