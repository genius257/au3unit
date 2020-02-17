# au3unit
An AutoIt3 Unit Testing framework.

## Install

`au3pm install au3unit`

## Usage

Lets say the project is in `C:\Projects\Example\`

file: `C:\Projects\Example\tests\mainTest.au3`

```AutoIt
#include "..\au3pm\au3unit\Unit\assert.au3"

assertEquals("a", "a")
```

In a new cmd window:

```
C:\User\genius257>cd "C:\Projects\Example\"
C:\Projects\Example>au3pm install au3unit
...
C:\Projects\Example>au3pm install rebuild
...
C:\Projects\Example>cd tests
C:\Projects\Example\tests>"C:\Projects\Example\au3pm\au3unit\build\au3unit.exe"
.

1 Number of assertions
1 Total tests run.
1 Passed - 0 Failed - 0 Errors

```
