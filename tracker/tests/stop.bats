#!/usr/bin/env bats

@test "validate that stop command is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./bin/stop
}

