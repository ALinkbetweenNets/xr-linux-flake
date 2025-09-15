#!/bin/bash
set -e

# Replace occurrences in files with extensions
find . -type f \( -name "*.nix" -o -name "*.md" -o -name "*.yml" -o -name "*.sh" \) -exec sed -i 's/xr-linux-flake/xr-linux-flake/g' {} \;

# Update description
find . -type f -name "flake.nix" -exec sed -i 's/Nix flake for XRLinuxDriver - a driver for XR glasses on Linux/Nix flake for XR glasses on Linux - including XRLinuxDriver and Breezy Desktop/g' {} \;

# Update test references
find ./tests -type f -name "*.sh" -exec sed -i 's/XRLinuxDriver Flake/XR Linux Flake/g' {} \;

# Update development environment message
find ./flake.nix -type f -exec sed -i 's/XRLinuxDriver development environment/XR Linux development environment/g' {} \;

echo "Renamed all references from xr-linux-flake to xr-linux-flake"