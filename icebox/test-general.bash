#!/bin/bash
[[ -n "$BO_Trace" ]] && echo "TRACE: Executing '$BASH_SOURCE'"
####################################################################################################
# TODO: SOMEDAY: Integrate into BriteOnyx

testAll () {
  testGetLength
  testGetPathnameExtension
  testGetPositionFirst
  testGetPositionLast
  testGetStringWithoutEnding
  testGetSubstring
  testStringContains
  testStringEndsWith
  testStringReplaceAll
  testStringStartsWith
}

testGetLength () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertStatus 0 getLength
  assertStatus 0 getLength ''
  assertStatus 0 getLength ""
  assertStatus 1 getLength "'"
  assertStatus 1 getLength "\""
  assertStatus 1 getLength a
  assertStatus 2 getLength ab
  assertStatus 3 getLength abc
  assertStatus 3 getLength 'abc'
  assertStatus 3 getLength "abc"
  assertStatus 4 getLength "ab'c"
  assertStatus 4 getLength "ab\"c"
}

testGetPathnameExtension () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertOutput 1 ''        getPathnameExtension
  assertOutput 1 ''        getPathnameExtension ''
  assertOutput 1 ''        getPathnameExtension ""
  assertOutput 0 ''        getPathnameExtension name
  assertOutput 0 ext       getPathnameExtension name.ext
  assertOutput 0 ext       getPathnameExtension dir/name.ext
  assertOutput 0 ext       getPathnameExtension /dir/name.ext
  assertOutput 0 ext       getPathnameExtension a/b/c/name.ext
  assertOutput 0 extension getPathnameExtension name.extension
  assertOutput 0 xyz       getPathnameExtension name.abc.xyz
  assertOutput 0 ''        getPathnameExtension a.dir/name
  assertOutput 1 ''        getPathnameExtension 'abc(def.xyz'
  assertOutput 1 ''        getPathnameExtension 'abc)def.xyz'
  assertOutput 1 ''        getPathnameExtension 'abc()def.xyz'
  assertOutput 1 ''        getPathnameExtension 'abc\def.xyz'
  assertOutput 1 ''        getPathnameExtension 'abc\ def.xyz'
  # TODO: SOMEDAY This test fails due to word-splitting issues in test framework, need to get out of BASH
  # assertOutput 1 ''        getPathnameExtension 'abc def.xyz'
}

testGetPositionFirst () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertStatus 0 getPositionFirst
  assertStatus 0 getPositionFirst ''
  assertStatus 0 getPositionFirst '' ''
  assertStatus 0 getPositionFirst ""
  assertStatus 0 getPositionFirst "" ""
  assertStatus 1 getPositionFirst abc a
  assertStatus 1 getPositionFirst abc ab
  assertStatus 2 getPositionFirst abc b
  assertStatus 2 getPositionFirst abc bc
  assertStatus 3 getPositionFirst abc c
  assertStatus 0 getPositionFirst abc d
  assertStatus 0 getPositionFirst abc abcd
  assertStatus 1 getPositionFirst abcabc a
  assertStatus 1 getPositionFirst abcabc ab
  assertStatus 2 getPositionFirst abcabc b
  assertStatus 2 getPositionFirst abcabc bc
  assertStatus 3 getPositionFirst abcabc c
  assertStatus 0 getPositionFirst abcabc d
  assertStatus 0 getPositionFirst abcabc abcd
}

testGetPositionLast () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertStatus 0 getPositionLast
  assertStatus 0 getPositionLast ''
  assertStatus 0 getPositionLast '' ''
  assertStatus 0 getPositionLast ""
  assertStatus 0 getPositionLast "" ""
  assertStatus 1 getPositionLast abc a
  assertStatus 1 getPositionLast abc ab
  assertStatus 2 getPositionLast abc b
  assertStatus 2 getPositionLast abc bc
  assertStatus 3 getPositionLast abc c
  assertStatus 0 getPositionLast abc d
  assertStatus 0 getPositionLast abc abcd
  assertStatus 4 getPositionLast abcabc a
  assertStatus 4 getPositionLast abcabc ab
  assertStatus 5 getPositionLast abcabc b
  assertStatus 5 getPositionLast abcabc bc
  assertStatus 6 getPositionLast abcabc c
  assertStatus 0 getPositionLast abcabc d
  assertStatus 0 getPositionLast abcabc abcd
}

testGetStringWithoutEnding () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertOutput 1 ''  getStringWithoutEnding
  assertOutput 1 ''  getStringWithoutEnding abc
  assertOutput 1 abc getStringWithoutEnding abc a
  assertOutput 1 abc getStringWithoutEnding abc b
  assertOutput 0 ab  getStringWithoutEnding abc c
  assertOutput 1 abc getStringWithoutEnding abc ab
  assertOutput 0 a   getStringWithoutEnding abc bc
  assertOutput 0 ''  getStringWithoutEnding abc abc
}

testGetSubstring () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertOutput 1 ''  getSubstring
  assertOutput 1 ''  getSubstring abc
  assertOutput 1 ''  getSubstring abc 0
  assertOutput 0 abc getSubstring abc 1
  assertOutput 0 bc  getSubstring abc 2
  assertOutput 0 c   getSubstring abc 3
  assertOutput 1 ''  getSubstring abc 4
  assertOutput 0 a   getSubstring abc 1 1
  assertOutput 0 b   getSubstring abc 2 1
  assertOutput 0 c   getSubstring abc 3 1
  assertOutput 0 ab  getSubstring abc 1 2
  assertOutput 0 abc getSubstring abc 1 3
  assertOutput 0 abc getSubstring abc 1 4
}

testStringContains () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertStatus 1 stringContains
  assertStatus 1 stringContains ''
  assertStatus 1 stringContains '' ''
  assertStatus 1 stringContains ""
  assertStatus 1 stringContains "" ""
  assertStatus 1 stringContains '' abc
  assertStatus 1 stringContains "" abc
  assertStatus 1 stringContains abc
  assertStatus 1 stringContains abc xyz
  assertStatus 0 stringContains abc a
  assertStatus 0 stringContains abc b
  assertStatus 0 stringContains abc c
  assertStatus 0 stringContains abc ab
  assertStatus 0 stringContains abc bc
  assertStatus 0 stringContains abc abc
  assertStatus 1 stringContains abc abcd
}

testStringEndsWith () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertStatus 1 stringEndsWith
  assertStatus 1 stringEndsWith ''
  assertStatus 1 stringEndsWith '' ''
  assertStatus 1 stringEndsWith ""
  assertStatus 1 stringEndsWith "" ""
  assertStatus 1 stringEndsWith '' abc
  assertStatus 1 stringEndsWith "" abc
  assertStatus 1 stringEndsWith abc
  assertStatus 1 stringEndsWith abc xyz
  assertStatus 1 stringEndsWith abc a
  assertStatus 1 stringEndsWith abc b
  assertStatus 0 stringEndsWith abc c
  assertStatus 1 stringEndsWith abc ab
  assertStatus 0 stringEndsWith abc bc
  assertStatus 0 stringEndsWith abc abc
  assertStatus 1 stringEndsWith abc abcd
}

testStringReplaceAll () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertOutput 1 ''    stringReplaceAll
  assertOutput 1 ''    stringReplaceAll abc
  assertOutput 1 ''    stringReplaceAll abc def
  assertOutput 0 zbc   stringReplaceAll abc a   z
  assertOutput 0 ayc   stringReplaceAll abc b   y
  assertOutput 0 abx   stringReplaceAll abc c   x
  assertOutput 0 zyc   stringReplaceAll abc ab  zy
  assertOutput 0 ayx   stringReplaceAll abc bc  yx
  assertOutput 0 zyx   stringReplaceAll abc abc zyx
  assertOutput 0 zyxbc stringReplaceAll abc a   zyx
  assertOutput 0 azyxc stringReplaceAll abc b   zyx
  assertOutput 0 abzyx stringReplaceAll abc c   zyx
}

testStringStartsWith () {
  # TODO: SOMEDAY enhance tests to cover special characters
  assertStatus 1 stringStartsWith
  assertStatus 1 stringStartsWith ''
  assertStatus 1 stringStartsWith '' ''
  assertStatus 1 stringStartsWith ""
  assertStatus 1 stringStartsWith "" ""
  assertStatus 1 stringStartsWith '' abc
  assertStatus 1 stringStartsWith "" abc
  assertStatus 1 stringStartsWith abc
  assertStatus 1 stringStartsWith abc xyz
  assertStatus 0 stringStartsWith abc a
  assertStatus 1 stringStartsWith abc b
  assertStatus 1 stringStartsWith abc c
  assertStatus 0 stringStartsWith abc ab
  assertStatus 1 stringStartsWith abc bc
  assertStatus 0 stringStartsWith abc abc
  assertStatus 1 stringStartsWith abc abcd
}

################################################################################

main () {
  parametersRequire 0 $#

  # abort $0:$FUNCNAME $LINENO 125 "Forced abort for testing"

  logInfo "Test general BASH functions"
  testAll
}

####################################################################################################

if [[ -z "$BO_Project" ]] ; then
  echo 'This project is not activated, aborting'
else
  main $@
  abortOnFail $0:$FUNCNAME $LINENO $?
fi

################################################################################
: <<'DisabledContent'
DisabledContent

