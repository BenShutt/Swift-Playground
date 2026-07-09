# Swift Playground

Collection of Swift snippets, investigations, experiments etc.

## Project structures

### Script

A single `<Name>.swift` file.
No external dependencies (system frameworks only).
Can be run using:

```bash
swift <Name>.swift
```

May contain companion scripts (e.g. `run.sh` for optimization).

### SwiftPM package

A script might not be enough if a project needs (including but not limited to):

- Third-party dependencies
- Modularization and separation of targets
- Build, platform, and Swift settings
- Swift testing
- Resources

Exposes one or more of these products:

#### Library

When merely storing a collection of files.

#### Executable

When the product has a `main` entry point. Can be run using:

```bash
swift run <executable>
```

#### App playground

When the product is a runnable app with UI (a `.swiftpm`).
Opened in Xcode.

### Notes

There should never be a need for an `.xcodeproj` file.
