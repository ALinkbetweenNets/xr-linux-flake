# XRLinuxDriver Flake Tests

This directory contains tests for the XRLinuxDriver flake packages.

## Running Tests

To run all tests:

```bash
./tests/run-tests.sh
```

This will:
1. Build each package
2. Run the corresponding tests for each package
3. Run `nix flake check` to verify the flake

## Individual Package Tests

You can also run tests for individual packages:

### XRLinuxDriver

```bash
nix build .#xrlinuxdriver
./tests/xrlinuxdriver/test.sh "$(realpath ./result)"
```

### Breezy Desktop Common

```bash
nix build .#breezy-desktop-common
./tests/breezy-desktop-common/test.sh "$(realpath ./result)"
```

### Breezy Desktop GNOME

```bash
nix build .#breezy-desktop-gnome
./tests/breezy-desktop-gnome/test.sh "$(realpath ./result)"
```

### Breezy Desktop KWin

```bash
nix build .#breezy-desktop-kwin
./tests/breezy-desktop-kwin/test.sh "$(realpath ./result)"
```

## Test Structure

Each test script verifies that:
1. The package builds successfully
2. All required files are present in the package
3. Basic functionality checks pass

## CI Integration

These tests are also run in CI via GitHub Actions. See `.github/workflows/build.yml` for details.