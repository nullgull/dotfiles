#!/usr/bin/env bash

get_aerospace_icon() {
  local workspace="$1"
  if [[ "$workspace" =~ ^0 ]]; then
    echo 󰇥
  else
    echo 
  fi
}
