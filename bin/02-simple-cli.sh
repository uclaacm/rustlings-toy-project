#!/bin/bash

source $(dirname "$0")/harness.sh

test_name='simple_cli_bee_movie_test'
path_to_expected_resp=$(dirname "$0")/fixtures/02-simple-cli_bee_movie_expected
test_opts=$(dirname "$0")/fixtures/bee-movie-script.txt

run_and_compare $test_name $path_to_expected_resp $test_opts

rc=$?

exit $rc
