# Spotlight Clipboard History (`⌥ + ⌘ + V`)

Opens the native Spotlight Clipboard History panel with a single hotkey. Pick an entry with the arrow keys, press `Return`, and it is pasted straight into the app you were working in. If you press `Escape` or click away, nothing is pasted.

**Requires macOS 26 (Tahoe) or later** — Clipboard History in Spotlight does not exist in earlier versions.

| File | Purpose |
|------|---------|
| [`macro.applescript`](macro.applescript) | The AppleScript macro |
| [`config.json`](config.json) | Shortcut metadata (name, hotkey, dependencies) |

## 1. Import into the macOS Shortcuts app

1. Open **Shortcuts.app**.
2. Choose **File → New Shortcut** (`⌘ + N`).
3. Name it **Open Clipboard History**.
4. In the action search on the right, find **Run AppleScript** and drag it into the editor.
5. Replace the default template with the full contents of [`macro.applescript`](macro.applescript).
6. Save the shortcut.

## 2. Bind the keyboard shortcut

1. With the shortcut open, click the **Shortcut Details** (ⓘ) button in the top-right toolbar.
2. Enable **Use as Quick Action**.
3. Click **Add Keyboard Shortcut** and press `⌥ + ⌘ + V`.
4. Close the details panel. The hotkey now works system-wide.

## 3. Security & TCC permissions

The macro drives the keyboard through **System Events**, which macOS protects via TCC (Transparency, Consent, and Control). Without these grants the script fails silently or with a "not allowed to send keystrokes" error.

1. Open **System Settings → Privacy & Security → Accessibility**.
2. Click **+**, add **Shortcuts** (`/System/Applications/Shortcuts.app`), and switch it **on**.
3. If you run the shortcut from another host (e.g. a launcher app or `osascript` in Terminal), add that app too.
4. On first run, macOS may ask to allow Shortcuts to control **System Events** — click **OK**. You can review this later under **Privacy & Security → Automation**.

## 4. Technical breakdown

- **`key code 21` instead of `keystroke "4"`** — `keystroke` sends a character that depends on the active keyboard layout and input source; on some layouts or during focus transitions it gets dropped or mapped to a different key. `key code 21` is the physical hardware code of the `4` key on the number row, so `⌘ + 4` reliably switches Spotlight to the Clipboard History tab.
- **Clipboard change detection (Escape / blur protection)** — "the window closed" looks the same whether you pressed `Return`, `Escape`, or clicked away, so the script decides by watching the clipboard instead:
  - Before opening Spotlight it records `NSPasteboard`'s `changeCount`, a counter macOS increments on every clipboard write.
  - It then waits (polling every 50 ms) until the Spotlight window disappears.
  - Selecting an entry with `Return` copies it to the clipboard, so the counter changes and `⌘ + V` is fired. `Escape` or clicking away leaves the counter untouched, so nothing is pasted.
  - `changeCount` is used instead of comparing clipboard contents so that re-selecting the entry already on the clipboard still pastes.
