# productivity-booster

A personal, multi-platform hub for system and workspace optimizations — keyboard macros, shortcuts, and automation scripts that shave friction off everyday work.

Tools are grouped by operating system so macOS, Windows, Linux, and cross-platform utilities can live side by side:

```
productivity-booster/
├── README.md
├── LICENSE
└── macos/
    └── shortcuts/
        └── spotlight-clipboard/
            ├── config.json          # Shortcut metadata (name, hotkey, dependencies)
            └── macro.applescript    # The AppleScript macro
```

Future platforms get their own top-level folder (`windows/`, `linux/`, `cross-platform/`).

---

## macOS: Spotlight Clipboard History (`⌥ + ⌘ + V`)

Opens the native Spotlight Clipboard History panel with a single hotkey. Pick an entry with the arrow keys, press `Return`, and it is pasted straight into the app you were working in. If you click away or dismiss the panel, nothing is pasted.

### 1. Import into the macOS Shortcuts app

1. Open **Shortcuts.app**.
2. Choose **File → New Shortcut** (`⌘ + N`).
3. Name it **Open Clipboard History**.
4. In the action search on the right, find **Run AppleScript** and drag it into the editor.
5. Replace the default template with the full contents of
   [`macos/shortcuts/spotlight-clipboard/macro.applescript`](macos/shortcuts/spotlight-clipboard/macro.applescript).
6. Save the shortcut.

### 2. Bind the keyboard shortcut

1. With the shortcut open, click the **Shortcut Details** (ⓘ) button in the top-right toolbar.
2. Enable **Use as Quick Action**.
3. Click **Add Keyboard Shortcut** and press `⌥ + ⌘ + V`.
4. Close the details panel. The hotkey now works system-wide.

### 3. Security & TCC permissions

The macro drives the keyboard through **System Events**, which macOS protects via TCC (Transparency, Consent, and Control). Without these grants the script fails silently or with an "not allowed to send keystrokes" error.

1. Open **System Settings → Privacy & Security → Accessibility**.
2. Click **+**, add **Shortcuts** (`/System/Applications/Shortcuts.app`), and switch it **on**.
3. If you run the shortcut from another host (e.g. a launcher app or `osascript` in Terminal), add that app too.
4. On first run, macOS may ask to allow Shortcuts to control **System Events** — click **OK**. You can review this later under **Privacy & Security → Automation**.

### 4. Technical breakdown

- **`key code 21` instead of `keystroke "4"`** — `keystroke` sends a character that depends on the active keyboard layout and input source; on some layouts or during focus transitions it gets dropped or mapped to a different key. `key code 21` is the physical hardware code of the `4` key on the number row, so `⌘ + 4` reliably switches Spotlight to the Clipboard History tab.
- **Focus loop (blur / dismissal protection)** — after opening the panel, the script polls every 50 ms while the Spotlight window exists:
  - If another process becomes frontmost (you clicked elsewhere or switched apps), `shouldPaste` is reset to `false` and the loop exits.
  - While Spotlight keeps focus, the session is considered valid.
  - After the window disappears, `⌘ + V` is fired only if the window closed while Spotlight still held focus — i.e. a committed selection — so no rogue paste lands in an unrelated window.
