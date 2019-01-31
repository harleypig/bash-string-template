#!/usr/bin/env bats

#######################################################################
# Error Scenarios (returns 1):
#   unknown error (no idea how to test this)
#   error in regex (maybe sed to temp file and call that instead?)

#######################################################################
load_lib() {
  local libname="$1"
  load "helper/$libname/load"
}

load_lib 'bats-support'
load_lib 'bats-assert'

#######################################################################

@test 'no string passed' {
  expect_usage="

Usage: string-template '/path/to/%PRJNAME%/'

string-template takes a string as a parameter and looks
for occurrences of '%WORD%', replacing that
substring with the value of WORD, if it exists in
the environment and prints the results to STDOUT.

Example:

  PRJNAME=test123 string-template '/path/to/%PRJNAME%

will echo to STDOUT '/path/to/test123'

!!! string-template requires a string to process"

  run string-template
  assert_failure
  assert_output "$expect_usage"
}

#-----------------------------------------------------------------------
@test 'string contains no words' {
  input_nowords='nowordshere'
  expect_nowords="No %WORD%'s found in string '%s'."

  run string-template "$input_nowords"
  assert_failure
  assert_output "$expect_nowords"
}

#-----------------------------------------------------------------------
@test 'string contains one percent sign' {
  input_onepercent='%nowordshere'
  expect_onepercent="No %WORD%'s found in string '%s'."

  run string-template "$input_onepercent"
  assert_failure
  assert_output "$expect_onepercent"
}

#-----------------------------------------------------------------------
@test 'var does not exist' {
  input_vardoesnotexist='%PLEASETELMEYOUDONTHAVEAVARNAMEDTHIS%'
  expect_vardoesnotexist="Variable 'PLEASETELMEYOUDONTHAVEAVARNAMEDTHIS' does not exist in the environment
!!PLEASETELMEYOUDONTHAVEAVARNAMEDTHIS!!"

  run string-template "$input_vardoesnotexist"
  assert_success
  assert_output "$expect_vardoesnotexist"
}

#-----------------------------------------------------------------------
@test 'var exists but is empty' {
  export VAREXISTSEMPTY=
  input_varexistsempty='/path/to/%VAREXISTSEMPTY%'
  expect_varexistsempty='/path/to/'

  run string-template "$input_varexistsempty"
  assert_success
  assert_output "$expect_varexistsempty"
}

#-----------------------------------------------------------------------
@test 'var exists' {
  export VAREXISTS='filename.txt'
  input_varexists='/path/to/%VAREXISTS%'
  expect_varexists='/path/to/filename.txt'

  run string-template "$input_varexists"
  assert_success
  assert_output "$expect_varexists"
}

#-----------------------------------------------------------------------
@test 'multiple vars' {
  export VARMULT='MULTIPLE'
  input_varmult='%VARMULT% some string %VARMULT%'
  expect_varmult='MULTIPLE some string MULTIPLE'

  run string-template "$input_varmult"
  assert_success
  assert_output "$expect_varmult"
}

#-----------------------------------------------------------------------
@test 'mixed not set and missing vars' {
  export VAREXISTSEMPTY=
  input_mixedvars='/path/to/%VAREXISTSEMPTY%/%NOSUCHVAR%'
  expect_mixedvars="Variable 'NOSUCHVAR' does not exist in the environment
/path/to//!!NOSUCHVAR!!"

  run string-template "$input_mixedvars"
  assert_success
  assert_output "$expect_mixedvars"
}
