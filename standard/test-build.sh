#!/usr/bin/env bash
# Test build script - không apply config, chỉ test
#
# Quick Reference:
#   ./test-build.sh          - Test build (safe, no changes)
#   sudo nixos-rebuild switch --flake .#hostname    - Apply system
#   home-manager switch --flake .#user@hostname     - Apply home

set -e

echo "🔍 Checking flake syntax..."
nix flake check

echo ""
echo "🏗️  Testing NixOS build..."
sudo nixos-rebuild build --flake .#nixos

echo ""
echo "🏠 Testing Home-Manager build..."
home-manager build --flake .#river@nixos

echo ""
echo "✅ Build test successful! Safe to switch."
echo ""
echo "To apply:"
echo "  sudo nixos-rebuild switch --flake .#nixos"
echo "  home-manager switch --flake .#river@nixos"
