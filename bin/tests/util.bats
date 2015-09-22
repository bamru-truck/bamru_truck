#!/usr/bin/env bats

@test "run a util function" {
  cd $BATS_TEST_DIRNAME/../
  source ./util
  run print_divider
  [ "$status" -eq 0 ]
}
