#!/usr/bin/env bats

#######################################################################
# Error Scenarios (returns 1):
#   no string passed
#   unknown error (no idea how to test this)
#   error in regex (maybe sed to temp file and call that instead?)
#   string contains no %WORDS%
#
# Mixed scenarios (warns, but returns 0):
#   var does not exist in environment
#   var exists but is empty or not set
#   mixed var not exists and exists
#   beginning and end of lines
#   multiple %WORDS% - same and different
#
# Success scenarios (no errors, returns 0):
#
#   beginning and end of lines
#   multiple %WORDS% - same and different

#######################################################################
expected_usage="

Usage: string-template '/path/to/%PRJNAME%/'

string-template takes a string as a parameter and looks
for occurrences of '%WORD%', replacing that
substring with the value of WORD, if it exists in
the environment and prints the results to STDOUT.

Example:

  PRJNAME=test123 string-template '/path/to/%PRJNAME%

will echo to STDOUT '/path/to/test123'

!!! string-template requires a string to process"

expected_nowords="No %WORD%'s found in string '%s'."

input_vardoesnotexist='%PLEASETELMEYOUDONTHAVEAVARNAMEDTHIS%'

expected_vardoesnotexist="Variable 'PLEASETELMEYOUDONTHAVEAVARNAMEDTHIS' does not exist in the environment
!!PLEASETELMEYOUDONTHAVEAVARNAMEDTHIS!!"


#######################################################################
load_lib() {
  local libname="$1"
  load "helper/$libname/load"
}

load_lib 'bats-support'
load_lib 'bats-assert'

#######################################################################

@test 'no string passed' {
  run string-template
  assert_failure
  assert_output "$expected_usage"
}

@test 'string contains no words' {
  run string-template 'there are no variables here'
  assert_failure
  assert_output "$expected_nowords"
}

@test 'var does not exist' {
  run string-template "$input_vardoesnotexist"
  assert_success
  assert_output "$expected_vardoesnotexist"
}
