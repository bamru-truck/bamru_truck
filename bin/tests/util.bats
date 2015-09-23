#!/usr/bin/env bats

setup () {
  cd $BATS_TEST_DIRNAME/../
  shopt -s expand_aliases
  source ./util
}

# ----- environment configuration -----

@test "load_environment_variables runs" {
  run load_environment_variables
  [ "$status" -eq 0 ]
}

@test "load_environment sets environment variable" {
  run load_environment_variables
  [ -n "$erpi" ]
}

# ----- text utilities-----

@test "remove_blank_lines" {
  run remove_blank_lines "asdf\n\nqwer"
  [ "${lines[0]}" == "asdf" ]
  [ "${lines[1]}" == "qwer" ]
}

@test "timstamp" {
  run timestamp
  [ -n "$output" ]
}

# ----- script and path names -----

# TBD 

# ----- console output -----

@test "print_divider runs" {
  run print_divider
  [ "$status" -eq 0 ]
}

