#!/bin/sh
set -e
nix flake lock --update-input private
nixos-rebuild "$@" --flake .
