# AppIcon

A macOS executable that renders the app's (1024×1024) PNG image from a SwiftUI view using `ImageRenderer`.

This is a separate SwiftPM package since it is macOS only and `CollectionUI` is iOS only.

## Note

`Color+Values.swift` is a **symlink** to the file in `CollectionUI` for a single source of truth.

## Generate

```bash
bash Scripts/app-icon.sh
```

Writes `AppIcon.png` into this directory (git-ignored).
