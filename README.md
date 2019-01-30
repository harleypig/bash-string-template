## A simple string template script in bash.

### Usage

Usage: string-template '/path/to/%PRJNAME%/'

string-template takes a string as a parameter and looks
for occurrences of '%WORD%', replacing that
substring with the value of WORD, if it exists in
the environment and prints the results to STDOUT.

Example:

  PRJNAME=test123 string-template '/path/to/%PRJNAME%

will echo to STDOUT '/path/to/test123'

### Tests for this function expect bats to be installed.

Install [bats](https://github.com/bats-core/bats-core) along with
[bats-support](https://github.com/ztombol/bats-support.git),
[bats-file](https://github.com/ztombol/bats-file.git), and
[bats-assert](https://github.com/ztombol/bats-assert.git) to run tests in this
repository.
