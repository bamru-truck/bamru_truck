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

@test "includes_item match" {
  run includes_item "a b c d e" c
  [ "$status" -eq 0 ]
}

@test "includes_item miss" {
  run includes_item "a b c d e" z
  [ "$status" -eq 1 ]
}

@test "excludes_item match" {
  run excludes_item "a b c d e" c
  [ "$status" -eq 1 ]
}

@test "excludes_item miss" {
  run excludes_item "a b c d e" z
  [ "$status" -eq 0 ]
}

# ----- script and path names -----

# TBD 

# ----- console output -----

@test "print_divider runs" {
  run print_divider
  [ "$status" -eq 0 ]
}

