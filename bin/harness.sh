#!/bin/bash

function run_and_compare {

  # argcheck
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
   then
    printf '%s\n' "Parameters not supplied properly."
    printf '%s\n' "Expected: <test_name> <path_to_expected_result> <test_flags>"
    printf '%s\n' "Received: $1 | $2 | $3"
    return 1
  fi

  test_name=$1
  path_to_target='./target/debug/rustlings-toy-project'
  test_flags=${3}

  # check if file exists
  if [ ! -f "${path_to_target}" ]; then
    printf '%s\n' "File not found at '${path_to_target}'"
    printf '%s\n' "please run cargo first"
    return 1
  fi

  cmd_output=$($path_to_target $test_flags)

  # echoing to files so we can use diff;
  # we make a temporary file, to avoid problems
  # for reference, comparing multiline strings was exceedingly hard :(
  tfile=$(mktemp /tmp/rustlings-toy-project.XXXXXXXXX)
  # tfile="tmp"
  echo -n "${cmd_output}" > ${tfile}

  # compare between two lines; verbose output gives us useful info on failure
  # recall: $2 is the path to expected fixture
  diff --ignore-all-space -y $2 ${tfile}
  diff_out="$?"

  # cleanup, so we can return cleanly
  rm ${tfile}

  if [ "$diff_out" -eq "0" ]; then
    printf '%s\n' "Integration test '${test_name}' passed."
    return 0
  else
    exp_out=$(cat ${2})
    printf '%s\n' "---"
    printf '%s\n' "Integration test '${test_name}' failed."
    printf '%s\n' "Expected: "
    printf '%s\n' "${exp_out}"
    printf '%s\n' "Received: "
    printf '%s\n' "${cmd_output}"
    return 1
  fi
}
