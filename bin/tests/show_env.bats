#!/usr/bin/env bats

@test "validate that show_env is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./show_env
}

@test "show_env runs successfully" {
  cd $BATS_TEST_DIRNAME/../
  echo `pwd` >&2
  echo `ls` >&2
  run ./show_env
  val=$status
  echo $val >&2
  [ "$val" == 0 ]
}
