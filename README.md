# Uzbek Keyboard · Özbekça klaviatura

A keyboard layout for the updated Uzbek Latin alphabet, with **Ö ö, Ğ ğ, Ş ş, Ç ç** and the apostrophe **ʼ**.

- It's the standard **US QWERTY** layout, so nothing you already type changes.
- Hold **Option ⌥** (macOS) or **AltGr / Right Alt** (Windows, Linux) and press a letter to type the Uzbek character.
- These are native OS layout files, so nothing runs in the background.

[![Build](https://github.com/khudoyshukur/uzbek-keyboard/actions/workflows/build.yml/badge.svg)](https://github.com/khudoyshukur/uzbek-keyboard/actions/workflows/build.yml)

## Cheat sheet

| Type | macOS | Windows / Linux | Unicode |
|---|---|---|---|
| **ö** / **Ö** | `⌥ O` / `⌥ ⇧ O` | `AltGr O` / `AltGr ⇧ O` | U+00F6 / U+00D6 |
| **ğ** / **Ğ** | `⌥ G` / `⌥ ⇧ G` | `AltGr G` / `AltGr ⇧ G` | U+011F / U+011E |
| **ş** / **Ş** | `⌥ S` / `⌥ ⇧ S` | `AltGr S` / `AltGr ⇧ S` | U+015F / U+015E |
| **ç** / **Ç** | `⌥ C` / `⌥ ⇧ C` | `AltGr C` / `AltGr ⇧ C` | U+00E7 / U+00C7 |
| **ʼ** (tutuq belgisi) | `⌥ '` | `AltGr '` | U+02BC |

With **Caps Lock** on, the modifier gives the capital letter (`⌥ O` → `Ö`).
On Windows, `Ctrl + Alt` works the same as `AltGr`.

```
 ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
 │  Q  │  W  │  E  │  R  │  T  │  Y  │  U  │  I  │ O Ö │  P  │  [  │
 │     │     │     │     │     │     │     │     │ o ö │     │     │
 └┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┐
  │  A  │ S Ş │  D  │  F  │ G Ğ │  H  │  J  │  K  │  L  │  ;  │ ' ʼ │
  │     │ s ş │     │     │ g ğ │     │     │     │     │     │     │
  └┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┘
   │  Z  │  X  │ C Ç │  V  │  B  │  N  │  M  │  ,  │  .  │  /  │
   │     │     │ c ç │     │     │     │     │     │     │     │
   └─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
   bottom-left: normal  ·  bottom-right: + modifier  ·  top: + Shift
```

On macOS, every other Option shortcut works the same as the stock US layout: `⌥ E` still adds an accent, `⌥ 2` is ™, and so on. The only exceptions are the five keys above, which replace `ø © ß ç æ`.

## Download

Get the latest files from **[Releases](https://github.com/khudoyshukur/uzbek-keyboard/releases)**.
Every push to `main` also builds them; open the latest [Actions run](https://github.com/khudoyshukur/uzbek-keyboard/actions) and download the files under *Artifacts*.

| Platform | File |
|---|---|
| macOS | `UzbekKeyboard-macOS-<version>.pkg` (installer) or `.zip` (manual) |
| Windows | `UzbekKeyboard-Windows-<version>.zip` |
| Linux | `UzbekKeyboard-Linux-<version>.tar.gz` |

## Install on macOS

**Option A, installer (all users):**
1. Double-click `UzbekKeyboard-macOS-<version>.pkg`.
   The package isn't signed yet, so macOS may block it. If it does, open **System Settings → Privacy & Security**, scroll down, and click **Open Anyway**.
2. Log out and log back in.

**Option B, manual (your user only):**
1. Unzip `UzbekKeyboard-macOS-<version>.zip`.
2. In Finder press `⇧⌘G`, type `~/Library/Keyboard Layouts`, and press Enter.
3. Drag `UzbekKeyboard.bundle` into that folder.
4. Log out and log back in.

   From a clone of this repo you can also run `./macos/install.sh`.

**Then turn it on:**
1. Open **System Settings → Keyboard → Text Input → Input Sources → Edit…**
2. Click **+**, pick **Uzbek** in the language list (or search "Uzbek Keyboard"), select **Uzbek Keyboard**, and click **Add**.
3. Switch layouts with the input menu in the menu bar, or with `Ctrl Space` / the 🌐 key.

To uninstall, remove it in Input Sources, then delete `UzbekKeyboard.bundle` from `~/Library/Keyboard Layouts` or `/Library/Keyboard Layouts`.

## Install on Windows

1. Unzip `UzbekKeyboard-Windows-<version>.zip`.
2. Double-click **`install.cmd`** and approve the administrator prompt.
   The script copies `uzbekkb.dll` into the system folders, registers the layout, and adds it under **Uzbek (Latin)** in your languages.
3. Sign out and back in if it doesn't show up right away. Switch layouts with `Win Space`.

To uninstall, run `uninstall.cmd`.

If you prefer to do it by hand, open `UzbekKeyboard.klc` in [Microsoft Keyboard Layout Creator 1.4](https://www.microsoft.com/download/details.aspx?id=102134), choose **Project → Build DLL and Setup Package**, and run the `setup.exe` it produces.

> Windows on ARM isn't supported yet, because Microsoft's layout compiler can't build ARM64 layouts.
> A few apps use `Ctrl Alt O/G/S/C` as shortcuts. Like every AltGr layout, this one takes those key combinations for typing.

## Install on Linux

```sh
tar xzf UzbekKeyboard-Linux-<version>.tar.gz && cd UzbekKeyboard-Linux-*
./install.sh               # current user, Wayland (GNOME, KDE, Sway…)
sudo ./install.sh --system # all users, also needed for X11 sessions
```

Then select it:
- **GNOME:** `gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'uzbekkb')]"`, then log out and back in.
- **KDE Plasma:** System Settings → Keyboard → Layouts → Add → *Uzbek Keyboard*.
- **X11:** `setxkbmap uzbekkb`
- **Sway:** add `input * xkb_layout uzbekkb` to your config.

AltGr is the **Right Alt** key. To uninstall, run `./install.sh --uninstall` (add `--system` if you installed with it).

## Phones and tablets

- **Android / iOS on-screen keyboards:** an OS layout file can't change these; it takes a full keyboard app. Until that exists, Gboard and the iOS keyboard let you long-press `o g s c` to get `ö ğ ş ç`. Adding the *Azerbaijani* or *Turkish Q* keyboard puts those letters on keys of their own.
- **Physical keyboards on Android** could use a small app that ships a key-character map (`.kcm`). It may be added here later.
- **Physical keyboards on iPad / iOS:** Apple doesn't allow custom hardware layouts.

## Repository layout

```
tools/generate.py   single source of truth: generates every layout file below
tools/make_icon.swift  draws the macOS menu-bar icon (Uzbek Keyboard.icns)
tests/              checks for the generated files
macos/              UzbekKeyboard.bundle (Info.plist + .keylayout + names), build/install scripts
windows/            UzbekKeyboard.klc, build.ps1 (kbdutool), install/uninstall scripts
linux/              XKB symbols + registry entry, install script
.github/workflows/  builds all three platforms on every push; tags `v*` publish a release
```

### Changing the layout

1. Edit the `UZBEK` table in `tools/generate.py`.
2. Run `python3 tools/generate.py && python3 tests/check_layouts.py`.
3. Commit the regenerated files. CI fails if they're out of date.

To release, bump `VERSION`, commit, then `git tag v<version> && git push --tags`.

## Technical notes

- **macOS:** the `.keylayout` includes Apple's full US layout (Option layer and dead keys `` ⌥` ⌥E ⌥U ⌥I ⌥N ``), with key maps for plain, Shift, Caps Lock, Option, Shift+Option, Caps+Option, and Control. The menu name is localized: *Uzbek Keyboard* in English, *Özbekça klaviatura* in Uzbek.
- **Windows:** the locale is `0443` (uz-Latn-UZ), and the DLL is `uzbekkb.dll`. Our keys sit in the `Ctrl+Alt` (AltGr) and `Shift+Ctrl+Alt` columns, and Caps Lock also applies to them (`Cap = 5`).
- **Linux:** the layout is `us(basic)` plus level 3 on Right Alt (`level3(ralt_switch)`).

## License

[MIT](LICENSE) © 2026 Khudoyshukur Juraev
