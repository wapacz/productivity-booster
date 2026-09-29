# productivity-booster

A personal, multi-platform hub for system and workspace optimizations — keyboard macros, shortcuts, and automation scripts that shave friction off everyday work.

Each tool lives in its own folder with a dedicated `README.md` covering setup, permissions, and how it works. This file is the index.

## Tools

### macOS

| Tool | Hotkey | Description |
|------|--------|-------------|
| [Spotlight Clipboard History](macos/shortcuts/spotlight-clipboard/README.md) | `⌥ + ⌘ + V` | Opens Spotlight Clipboard History and auto-pastes the selected entry |

## Repository layout

Tools are grouped by operating system, then by tool type:

```
productivity-booster/
├── README.md                          # This index
├── LICENSE
└── macos/
    └── shortcuts/
        └── spotlight-clipboard/
            ├── README.md              # Tool docs
            ├── config.json
            └── macro.applescript
```

Future platforms get their own top-level folder (`windows/`, `linux/`, `cross-platform/`).

## Adding a new tool

1. Create `<os>/<tool-type>/<tool-name>/`.
2. Add a `README.md` there with setup, permissions, and a technical breakdown.
3. Add a row to the matching OS table above.
