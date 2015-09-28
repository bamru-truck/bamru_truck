#!/usr/bin/env bats

@test "validate that show_env is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./show_env
}

@test "show_env runs successfully" {
  cd $BATS_TEST_DIRNAME/../
  run ./show_env
  [ "$status" == 0 ]
}
