#include "../../testCase.au3"

assertIsCallable(UserFunction); UserFunction
assertIsCallable("UserFunction"); String representation of UserFunction
assertIsCallable(StringRegExp); Function
assertIsCallable("StringRegExp"); String representation of Function

Func UserFunction()
    ;
EndFunc
