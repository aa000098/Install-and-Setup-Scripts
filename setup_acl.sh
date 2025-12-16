#!/usr/bin/env bash
# This script sets up Access Control Lists (ACLs) on a specified directory.

echo "Setting up ACLs on the specified directory..."

# ==== 1. install scons ====
sudo apt-get update
sudo apt-get install -y scons
echo "scons installed successfully."

