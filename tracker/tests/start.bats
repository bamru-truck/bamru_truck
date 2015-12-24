#!/usr/bin/env bats

@test "validate that start command is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./bin/start
}

