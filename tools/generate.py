#!/usr/bin/env python3
"""Generate every keyboard layout file in this repo from one mapping table.

Run from anywhere:  python3 tools/generate.py
Edit UZBEK (below) to change what the modifier key produces; never edit the
generated files by hand. CI fails if they are out of date.
"""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VERSION = open(os.path.join(ROOT, "VERSION")).read().strip()

# Internal layout name: macOS stores it in users' input-source prefs, so never change it.
LAYOUT_NAME = "Uzbek Keyboard"
NAME_EN = "Uzbek Latin"   # what users see
NAME_UZ = "Özbekça klaviatura"
BUNDLE_ID = "io.github.khudoyshukur.keyboardlayout.uzbek"
AUTHOR = "Khudoyshukur Juraev"
WIN_KBD = "uzbekkb"          # DLL name, max 8 chars
WIN_LCID = "0443"            # uz-Latn-UZ
XKB_NAME = "uzbekkb"

# The whole point of the project: base key -> (with modifier, with Shift + modifier)
UZBEK = {
    "o": ("ö", "Ö"),  # ö Ö
    "g": ("ğ", "Ğ"),  # ğ Ğ
    "s": ("ş", "Ş"),  # ş Ş
    "c": ("ç", "Ç"),  # ç Ç
    "'": ("ʼ", "ʼ"),  # ʼ  (tutuq belgisi, modifier letter apostrophe)
}
# Keys where Caps Lock also upper-cases the modifier layer.
CAPS_AFFECTS_MOD = {"o", "g", "s", "c"}

# ---------------------------------------------------------------------------
# Typing keys. Columns:
#   id, mac keycode, win scancode, win VK, xkb key, normal, shift,
#   mac Option, mac Shift+Option   (Apple's stock U.S. layout values)
# "dead:x" means a dead key.
# ---------------------------------------------------------------------------
KEYS = [
    ("`", 50, "29", "OEM_3", "TLDE", "`", "~", "dead:grave", "`"),
    ("1", 18, "02", "1", "AE01", "1", "!", "¡", "⁄"),
    ("2", 19, "03", "2", "AE02", "2", "@", "™", "€"),
    ("3", 20, "04", "3", "AE03", "3", "#", "£", "‹"),
    ("4", 21, "05", "4", "AE04", "4", "$", "¢", "›"),
    ("5", 23, "06", "5", "AE05", "5", "%", "∞", "ﬁ"),
    ("6", 22, "07", "6", "AE06", "6", "^", "§", "ﬂ"),
    ("7", 26, "08", "7", "AE07", "7", "&", "¶", "‡"),
    ("8", 28, "09", "8", "AE08", "8", "*", "•", "°"),
    ("9", 25, "0a", "9", "AE09", "9", "(", "ª", "·"),
    ("0", 29, "0b", "0", "AE10", "0", ")", "º", "‚"),
    ("-", 27, "0c", "OEM_MINUS", "AE11", "-", "_", "–", "—"),
    ("=", 24, "0d", "OEM_PLUS", "AE12", "=", "+", "≠", "±"),
    ("q", 12, "10", "Q", "AD01", "q", "Q", "œ", "Œ"),
    ("w", 13, "11", "W", "AD02", "w", "W", "∑", "„"),
    ("e", 14, "12", "E", "AD03", "e", "E", "dead:acute", "´"),
    ("r", 15, "13", "R", "AD04", "r", "R", "®", "‰"),
    ("t", 17, "14", "T", "AD05", "t", "T", "†", "ˇ"),
    ("y", 16, "15", "Y", "AD06", "y", "Y", "¥", "Á"),
    ("u", 32, "16", "U", "AD07", "u", "U", "dead:umlaut", "¨"),
    ("i", 34, "17", "I", "AD08", "i", "I", "dead:circumflex", "ˆ"),
    ("o", 31, "18", "O", "AD09", "o", "O", "ø", "Ø"),
    ("p", 35, "19", "P", "AD10", "p", "P", "π", "∏"),
    ("[", 33, "1a", "OEM_4", "AD11", "[", "{", "“", "”"),
    ("]", 30, "1b", "OEM_6", "AD12", "]", "}", "‘", "’"),
    ("\\", 42, "2b", "OEM_5", "BKSL", "\\", "|", "«", "»"),
    ("a", 0, "1e", "A", "AC01", "a", "A", "å", "Å"),
    ("s", 1, "1f", "S", "AC02", "s", "S", "ß", "Í"),
    ("d", 2, "20", "D", "AC03", "d", "D", "∂", "Î"),
    ("f", 3, "21", "F", "AC04", "f", "F", "ƒ", "Ï"),
    ("g", 5, "22", "G", "AC05", "g", "G", "©", "˝"),
    ("h", 4, "23", "H", "AC06", "h", "H", "˙", "Ó"),
    ("j", 38, "24", "J", "AC07", "j", "J", "∆", "Ô"),
    ("k", 40, "25", "K", "AC08", "k", "K", "˚", ""),
    ("l", 37, "26", "L", "AC09", "l", "L", "¬", "Ò"),
    (";", 41, "27", "OEM_1", "AC10", ";", ":", "…", "Ú"),
    ("'", 39, "28", "OEM_7", "AC11", "'", '"', "æ", "Æ"),
    ("z", 6, "2c", "Z", "AB01", "z", "Z", "Ω", "¸"),
    ("x", 7, "2d", "X", "AB02", "x", "X", "≈", "˛"),
    ("c", 8, "2e", "C", "AB03", "c", "C", "ç", "Ç"),
    ("v", 9, "2f", "V", "AB04", "v", "V", "√", "◊"),
    ("b", 11, "30", "B", "AB05", "b", "B", "∫", "ı"),
    ("n", 45, "31", "N", "AB06", "n", "N", "dead:tilde", "˜"),
    ("m", 46, "32", "M", "AB07", "m", "M", "µ", "Â"),
    (",", 43, "33", "OEM_COMMA", "AB08", ",", "<", "≤", "¯"),
    (".", 47, "34", "OEM_PERIOD", "AB09", ".", ">", "≥", "˘"),
    ("/", 44, "35", "OEM_2", "AB10", "/", "?", "÷", "¿"),
    ("iso", 10, "56", "OEM_102", "LSGT", "§", "±", "§", "±"),
    ("space", 49, "39", "SPACE", "SPCE", " ", " ", " ", " "),
]

for k in UZBEK:
    assert any(row[0] == k for row in KEYS), k

# ---------------------------------------------------------------------------
# macOS .keylayout
# ---------------------------------------------------------------------------
MAC_FIXED = {  # keys that type the same thing in every layer
    36: "\r", 48: "\t", 51: "\x08", 52: "\x03", 53: "\x1b", 76: "\x03",
    65: ".", 67: "*", 69: "+", 71: "\x1b", 75: "/", 78: "-", 81: "=",
    82: "0", 83: "1", 84: "2", 85: "3", 86: "4", 87: "5", 88: "6", 89: "7",
    91: "8", 92: "9",
    114: "\x05", 115: "\x01", 116: "\x0b", 117: "\x7f", 119: "\x04",
    121: "\x0c", 123: "\x1c", 124: "\x1d", 125: "\x1f", 126: "\x1e",
}
for fk in (64, 79, 80, 90, 96, 97, 98, 99, 100, 101, 103, 105, 106, 107,
           109, 111, 113, 118, 120, 122):
    MAC_FIXED[fk] = "\x10"

DEAD = {  # state: (terminator, {base: composed})
    "grave": ("`", dict(zip("aeiouAEIOU ", "àèìòùÀÈÌÒÙ`"))),
    "acute": ("´", dict(zip("aeiouAEIOU ", "áéíóúÁÉÍÓÚ´"))),
    "umlaut": ("¨", dict(zip("aeiouyAEIOUY ", "äëïöüÿÄËÏÖÜŸ¨"))),
    "circumflex": ("ˆ", dict(zip("aeiouAEIOU ", "âêîôûÂÊÎÔÛˆ"))),
    "tilde": ("˜", dict(zip("anoANO ", "ãñõÃÑÕ˜"))),
}
COMPOSABLE = sorted({b for _, table in DEAD.values() for b in table})


def mac_layers():
    """Return the 7 key maps as {keycode: output} dicts."""
    layers = [dict() for _ in range(7)]
    for kid, code, _sc, _vk, _x, n, s, o, so in KEYS:
        caps = n.upper() if n.isalpha() else n
        opt, shopt = o, so
        if kid in UZBEK:
            opt, shopt = UZBEK[kid]
        caps_opt = shopt if kid in CAPS_AFFECTS_MOD else opt
        if n.isalpha():
            ctrl = chr(ord(n) - 96)
        else:
            ctrl = {"[": "\x1b", "\\": "\x1c", "]": "\x1d"}.get(n, n)
        for i, v in enumerate((n, s, caps, opt, shopt, caps_opt, ctrl)):
            layers[i][code] = v
    for layer in layers:
        layer.update(MAC_FIXED)
    return layers


def xml_char(s):
    out = []
    for ch in s:
        if ch in '&<>"\'' or ord(ch) < 0x20 or ord(ch) == 0x7f or ord(ch) == 0xa0:
            out.append("&#x%04X;" % ord(ch))
        else:
            out.append(ch)
    return "".join(out)


def action_id(ch):
    return "space" if ch == " " else "a_%04X" % ord(ch)


def keylayout():
    layers = mac_layers()
    L = []
    w = L.append
    w('<?xml version="1.1" encoding="UTF-8"?>')
    w('<!DOCTYPE keyboard SYSTEM "file://localhost/System/Library/DTDs/KeyboardLayout.dtd">')
    w("<!-- Generated by tools/generate.py. Do not edit by hand. -->")
    w('<keyboard group="126" id="-19443" name="%s" maxout="1">' % LAYOUT_NAME)
    w("    <layouts>")
    w('        <layout first="0" last="255" mapSet="ANSI" modifiers="Modifiers"/>')
    w("    </layouts>")
    w('    <modifierMap id="Modifiers" defaultIndex="0">')
    selects = [
        ["command?", "caps? anyOption command"],      # 0 plain (⌘⌥ shortcuts use plain letters)
        ["anyShift caps? command?", "anyShift caps? anyOption command"],  # 1 Shift
        ["caps"],                                     # 2 Caps Lock
        ["anyOption"],                                # 3 Option
        ["anyShift caps? anyOption"],                 # 4 Shift+Option
        ["caps anyOption"],                           # 5 Caps+Option
        ["anyShift? caps? anyOption? command? anyControl"],  # 6 Control
    ]
    for i, mods in enumerate(selects):
        w('        <keyMapSelect mapIndex="%d">' % i)
        for m in mods:
            w('            <modifier keys="%s"/>' % m)
        w("        </keyMapSelect>")
    w("    </modifierMap>")
    names = ["plain", "Shift", "Caps Lock", "Option", "Shift+Option",
             "Caps Lock+Option", "Control"]
    w('    <keyMapSet id="ANSI">')
    used_actions = set()
    for i, layer in enumerate(layers):
        w('        <keyMap index="%d"> <!-- %s -->' % (i, names[i]))
        for code in sorted(layer):
            v = layer[code]
            if v.startswith("dead:"):
                aid = "dead_" + v[5:]
                used_actions.add(aid)
                w('            <key code="%d" action="%s"/>' % (code, aid))
            elif v in COMPOSABLE and i != 6:
                used_actions.add(v)
                w('            <key code="%d" action="%s"/>' % (code, action_id(v)))
            else:
                w('            <key code="%d" output="%s"/>' % (code, xml_char(v)))
        w("        </keyMap>")
    w("    </keyMapSet>")
    w("    <actions>")
    for state in DEAD:
        w('        <action id="dead_%s">' % state)
        w('            <when state="none" next="%s"/>' % state)
        w("        </action>")
    for base in COMPOSABLE:
        w('        <action id="%s">' % action_id(base))
        w('            <when state="none" output="%s"/>' % xml_char(base))
        for state, (_t, table) in DEAD.items():
            if base in table:
                w('            <when state="%s" output="%s"/>' % (state, xml_char(table[base])))
        w("        </action>")
    w("    </actions>")
    w("    <terminators>")
    for state, (term, _t) in DEAD.items():
        w('        <when state="%s" output="%s"/>' % (state, xml_char(term)))
    w("    </terminators>")
    w("</keyboard>")
    return "\n".join(L) + "\n"


def info_plist():
    return """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleIdentifier</key>
	<string>{bid}</string>
	<key>CFBundleName</key>
	<string>{layout}</string>
	<key>CFBundleShortVersionString</key>
	<string>{ver}</string>
	<key>CFBundleVersion</key>
	<string>{ver}</string>
	<key>KLInfo_{layout}</key>
	<dict>
		<key>TISInputSourceID</key>
		<string>{bid}.uzbekkeyboard</string>
		<key>TISIconIsTemplate</key>
		<true/>
		<key>TISIntendedLanguage</key>
		<string>uz-Latn</string>
	</dict>
</dict>
</plist>
""".format(bid=BUNDLE_ID, layout=LAYOUT_NAME, ver=VERSION)


# ---------------------------------------------------------------------------
# Windows .klc (MSKLC / kbdutool)
# ---------------------------------------------------------------------------
def klc_char(ch):
    if ch is None:
        return "-1"
    if ch.isalnum() and ord(ch) < 128:
        return ch
    return "%04x" % ord(ch)


def klc():
    L = []
    w = L.append
    w('KBD\t%s\t"%s"' % (WIN_KBD, NAME_EN))
    w("")
    w('COPYRIGHT\t"(c) 2026 %s, MIT License"' % AUTHOR)
    w("")
    w('COMPANY\t"%s"' % AUTHOR)
    w("")
    w('LOCALENAME\t"uz-Latn-UZ"')
    w("")
    w('LOCALEID\t"0000%s"' % WIN_LCID)
    w("")
    w("VERSION\t%s" % ".".join(VERSION.split(".")[:2]))
    w("")
    w("// Generated by tools/generate.py. Do not edit by hand.")
    w("")
    w("SHIFTSTATE")
    w("")
    w("0\t//Column 4")
    w("1\t//Column 5 : Shft")
    w("2\t//Column 6 :       Ctrl")
    w("6\t//Column 7 :       Ctrl Alt")
    w("7\t//Column 8 : Shft  Ctrl Alt")
    w("")
    w("LAYOUT\t\t;an extra '@' at the end is a dead key")
    w("")
    w("//SC\tVK_\t\tCap\t0\t1\t2\t6\t7")
    w("//--\t----\t\t----\t----\t----\t----\t----\t----")
    w("")
    rows = sorted(KEYS, key=lambda r: int(r[2], 16))
    for kid, _code, sc, vk, _x, n, s, _o, _so in rows:
        ctrl = {"[": "\x1b", "]": "\x1d", "\\": "\x1c", " ": " "}.get(n)
        if kid == "iso":
            n, s, ctrl = "\\", "|", "\x1c"
        alt, shalt = UZBEK.get(kid, (None, None))
        if n.isalpha():
            cap = "5" if kid in CAPS_AFFECTS_MOD else "1"
        else:
            cap = "0"
        cols = [klc_char(c) for c in (n, s, ctrl, alt, shalt)]
        w("%s\t%s\t\t%s\t%s" % (sc, vk, cap, "\t".join(cols)))
    w("53\tDECIMAL\t\t0\t002e\t002e\t-1\t-1\t-1")
    w("")
    w("KEYNAME")
    w("")
    names = [("01", "Esc"), ("0e", "Backspace"), ("0f", "Tab"), ("1c", "Enter"),
             ("1d", "Ctrl"), ("2a", "Shift"), ("36", '"Right Shift"'),
             ("37", '"Num *"'), ("38", "Alt"), ("39", "Space"), ("3a", '"Caps Lock"')]
    names += [("%02x" % (0x3b + i), "F%d" % (i + 1)) for i in range(10)]
    names += [("45", "Pause"), ("46", '"Scroll Lock"'), ("47", '"Num 7"'),
              ("48", '"Num 8"'), ("49", '"Num 9"'), ("4a", '"Num -"'),
              ("4b", '"Num 4"'), ("4c", '"Num 5"'), ("4d", '"Num 6"'),
              ("4e", '"Num +"'), ("4f", '"Num 1"'), ("50", '"Num 2"'),
              ("51", '"Num 3"'), ("52", '"Num 0"'), ("53", '"Num Del"'),
              ("54", '"Sys Req"'), ("57", "F11"), ("58", "F12")]
    names += [("%02x" % (0x64 + i), "F%d" % (13 + i)) for i in range(11)]
    names += [("76", "F24")]
    for sc, nm in names:
        w("%s\t%s" % (sc, nm))
    w("")
    w("KEYNAME_EXT")
    w("")
    for sc, nm in [("1c", '"Num Enter"'), ("1d", '"Right Ctrl"'), ("35", '"Num /"'),
                   ("37", '"Prnt Scrn"'), ("38", '"Right Alt"'), ("45", '"Num Lock"'),
                   ("46", "Break"), ("47", "Home"), ("48", "Up"), ("49", '"Page Up"'),
                   ("4b", "Left"), ("4d", "Right"), ("4f", "End"), ("50", "Down"),
                   ("51", '"Page Down"'), ("52", "Insert"), ("53", "Delete"),
                   ("54", "<00>"), ("56", "Help"), ("5b", '"Left Windows"'),
                   ("5c", '"Right Windows"'), ("5d", "Application")]:
        w("%s\t%s" % (sc, nm))
    w("")
    w("DESCRIPTIONS")
    w("")
    w("0409\t%s" % NAME_EN)
    w("%s\t%s" % (WIN_LCID, NAME_UZ))
    w("")
    w("LANGUAGENAMES")
    w("")
    w("0409\tUzbek (Latin)")
    w("%s\tOʻzbekcha" % WIN_LCID)
    w("")
    w("ENDKBD")
    return "\r\n".join(L) + "\r\n"


# ---------------------------------------------------------------------------
# Linux XKB
# ---------------------------------------------------------------------------
XKB_SYM = {"ö": "odiaeresis", "Ö": "Odiaeresis", "ğ": "gbreve", "Ğ": "Gbreve",
           "ş": "scedilla", "Ş": "Scedilla", "ç": "ccedilla", "Ç": "Ccedilla"}
XKB_BASE = {"'": ("apostrophe", "quotedbl")}


def xkb_sym(ch):
    return XKB_SYM.get(ch) or "U%04X" % ord(ch)


def xkb_symbols():
    L = ["// Generated by tools/generate.py. Do not edit by hand.",
         "// %s (%s): US QWERTY + Right Alt (AltGr) for ö ğ ş ç ʼ" % (NAME_EN, NAME_UZ),
         "",
         "default partial alphanumeric_keys",
         'xkb_symbols "basic" {',
         '    include "us(basic)"',
         '    name[Group1] = "%s";' % NAME_EN,
         ""]
    for kid, _c, _sc, _vk, xkey, n, s, _o, _so in KEYS:
        if kid not in UZBEK:
            continue
        alt, shalt = UZBEK[kid]
        base = XKB_BASE.get(kid, (n, s))
        typ = "FOUR_LEVEL_ALPHABETIC" if kid in CAPS_AFFECTS_MOD else "FOUR_LEVEL"
        L.append('    key <%s> { type[Group1] = "%s", [ %s, %s, %s, %s ] };'
                 % (xkey, typ, base[0], base[1], xkb_sym(alt), xkb_sym(shalt)))
    L += ["", '    include "level3(ralt_switch)"', "};"]
    return "\n".join(L) + "\n"


def xkb_registry():
    return """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xkbConfigRegistry SYSTEM "xkb.dtd">
<!-- Generated by tools/generate.py. Do not edit by hand. -->
<xkbConfigRegistry version="1.1">
  <layoutList>
    <layout>
      <configItem>
        <name>{name}</name>
        <shortDescription>uz</shortDescription>
        <description>{en} ({uz})</description>
        <languageList>
          <iso639Id>uzb</iso639Id>
        </languageList>
      </configItem>
    </layout>
  </layoutList>
</xkbConfigRegistry>
""".format(name=XKB_NAME, en=NAME_EN, uz=NAME_UZ)


# ---------------------------------------------------------------------------
OUTPUTS = {
    "macos/UzbekKeyboard.bundle/Contents/Info.plist": (info_plist, "utf-8"),
    "macos/UzbekKeyboard.bundle/Contents/Resources/%s.keylayout" % LAYOUT_NAME: (keylayout, "utf-8"),
    "macos/UzbekKeyboard.bundle/Contents/Resources/en.lproj/InfoPlist.strings":
        (lambda: '"%s" = "%s";\n' % (LAYOUT_NAME, NAME_EN), "utf-8"),
    "macos/UzbekKeyboard.bundle/Contents/Resources/uz.lproj/InfoPlist.strings":
        (lambda: '"%s" = "%s";\n' % (LAYOUT_NAME, NAME_UZ), "utf-8"),
    "windows/UzbekKeyboard.klc": (klc, "utf-16"),  # MSKLC needs UTF-16 LE with BOM
    "linux/xkb/symbols/" + XKB_NAME: (xkb_symbols, "utf-8"),
    "linux/xkb/rules/evdev.xml": (xkb_registry, "utf-8"),
}


def main():
    check = "--check" in sys.argv
    stale = []
    for rel, (fn, enc) in OUTPUTS.items():
        path = os.path.join(ROOT, rel)
        data = fn().encode("utf-16-le") if enc == "utf-16" else fn().encode("utf-8")
        if enc == "utf-16":
            data = b"\xff\xfe" + data
        old = open(path, "rb").read() if os.path.exists(path) else None
        if old == data:
            continue
        if check:
            stale.append(rel)
        else:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "wb") as f:
                f.write(data)
            print("wrote", rel)
    if stale:
        print("Out of date (run python3 tools/generate.py):\n  " + "\n  ".join(stale))
        sys.exit(1)


if __name__ == "__main__":
    main()
