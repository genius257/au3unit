# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- This changelog
- assertGreaterThan
- assertIsNumber
- assertIsInt
- assertLessThan
- assertGreaterThanOrEqual
- assertNotNull
- assertNotSame
- map type comparator support
- GitHub CI testing workflow, for better quality assurance
- assertLessThanOrEqual
- assertStringMatchesFormat
- assertStringEndsWith
- assertStringEndsNotWith
- assertStringStartsWith
- assertStringStartsNotWith
- assertEqualsCanonicalizing
- assertEqualsIgnoringCase
- assertEqualsWithDelta
- Numeric Comparator
- Double Comparator
- assertFileEquals
- assertFileExists
- assertMapHasKey
- assertCount
- assertSameSize
- assertEmpty
- assertIsArray
- assertIsMap
- assertIsBool
- assertIsCallable
- assertIsFloat
- assertIsNumeric
- assertIsObject
- assertIsResource
- assertIsScalar
- assertIsString

### Changed

- IsType error message format
- IsType expected type string comparison from case-sensitive to case-insensitive
- Replaced custom made string repeat function with AutoIt standard UDF _StringRepeat (067b8c8749d7ffd5929912e6831cbad4ce5ba169)
- String export logic from v2.0 to v7.0 to match expected output in exception messages for testing (c4c699bfc8449ee02a99dbb87d161d2dfe33d395)

### Fixed

- assertGreaterThan comparison was opposite expected
- Success checking logic for LogicalNot constraint
- Parameters passed to function calls from LogicalNot FailureDescription logic case
- Operator precedence in ScalarComparator conditional expression (71e5fb8cf976b187c872abea9e009a3d13a18c74)
- Bug causing UnifiedDiffOutputBuilder error message: $diffEndIndex too big
- UnifiedDiffOutputBuilder: Equals operator used string strict comparison to compare numbers by mistake (94ca614391ae742a31c33d38818df60dffbbca5c)
- UnifiedDiffOutputBuilder: non implemented code that caused missing newlines in string diffs (1f9192134e8f5a627f079c72bc140b860bc1f99e)
- ArrayComparator: keys represented in array diffs for 1D and 2+ Dimention arrays (04f0780910db4232287178ff781e83e30418873d)
- Issue caused by unexpected behavior: AutoIt IsFloat returns false if a Double vartype does not has no fractional component


## [1.1.1] - 2023-12-30

### Fixed

- Exit code was not set on test run failure.

## [1.1.0] - 2023-12-24

### Added

- Added testCase.au3
- Added type and object comparators (25d809915dd1a88600d22968e5a615b197de4fe6)

### Changed

- Exporter formatting for Ptr and HWnd

### Fixed

-  Missing comparator for Ptr (Issue #9)

## [1.0.1] - 2023-12-24

### Fixed

- assertSame did not compare correctly (Issue #5)
- assertTrue/assertFalse did not fail (Issue #6)

## [1.0.0] - 2023-12-24

### Added

- assertThat
- assertEquals
- assertNotEquals
- assertFalse
- assertNotFalse
- assertInternalType
- assertNotInternalType
- assertNull
- assertSame
- assertTrue
- assertNotTrue

[unreleased]: https://github.com/genius257/au3unit/compare/1.1.1...HEAD
[1.1.1]: https://github.com/genius257/au3unit/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/genius257/au3unit/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/genius257/au3unit/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/genius257/au3unit/releases/tag/1.0.0
