#!/usr/bin/env bats

@test "validate that start_server is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./start_server
}

