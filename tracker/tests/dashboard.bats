#!/usr/bin/env bats

@test "validate that dashboard is available" {
  cd $BATS_TEST_DIRNAME/../
  command -v ./dashboard
}

