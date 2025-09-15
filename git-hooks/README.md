# Git Hooks for XR Linux Flake

This directory contains Git hooks that are installed by the `install-hooks.sh` script in the repository root.

## Available Hooks

### pre-commit

The pre-commit hook runs before each commit and ensures that:

1. All tests are passing with `./tests/run-tests.sh`
2. All packages build correctly
3. The dev shell works as expected

If any checks fail, the commit will be aborted.

## Installation

Run the install script from the repository root:

```bash
./install-hooks.sh
```

Or use the Nix development shell which automatically installs the hooks:

```bash
nix develop
```

## Integration with pre-commit-hooks.nix

The hooks are also integrated with the [pre-commit-hooks.nix](https://github.com/cachix/pre-commit-hooks.nix) framework, which provides additional features:

- Caching of hook results
- Nix-based management of hook dependencies
- Integration with CI

When using `nix develop`, the hooks from pre-commit-hooks.nix are automatically activated.