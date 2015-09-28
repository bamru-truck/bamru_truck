#!/usr/bin/env bats

@test "validate that gen_env is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./gen_env
}

@test "gen_env runs successfully" {
  cd $BATS_TEST_DIRNAME/../
  run ./gen_env
  [ "$status" == 0 ]
}
