#!/usr/bin/env bats

@test "validate that check command is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./bin/check
}

