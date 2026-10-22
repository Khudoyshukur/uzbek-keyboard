#!/usr/bin/env python3
"""Sanity checks for the generated layout files. Run: python3 tests/check_layouts.py"""
import os
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "macos/UzbekKeyboard.bundle/Contents/Resources")
KEYLAYOUT = os.path.join(RES, "Uzbek Keyboard.keylayout")
DTD = "/System/Library/DTDs/KeyboardLayout.dtd"

failures = []


def check(cond, msg):
    if not cond:
        failures.append(msg)


# --- macOS -----------------------------------------------------------------
raw = open(KEYLAYOUT, encoding="utf-8").read()
# Control characters are legal in XML 1.1 (which Apple uses) but most parsers
# only speak XML 1.0, so swap them for a placeholder before parsing.
xml10 = re.sub(r"&#x00(0[0-9A-F]|1[0-9A-F]|7F);", "&#xFFFD;", raw)
xml10 = xml10.replace('version="1.1"', 'version="1.0"', 1)

if os.path.exists(DTD) and shutil.which("xmllint"):
    with tempfile.NamedTemporaryFile("w", suffix=".xml", delete=False, encoding="utf-8") as f:
        f.write(xml10)
    r = subprocess.run(["xmllint", "--noout", "--dtdvalid", DTD, f.name],
                       capture_output=True, text=True)
    os.unlink(f.name)
    check(r.returncode == 0, "keylayout fails Apple DTD:\n" + r.stderr)

root = ET.fromstring(xml10.split("\n", 2)[2])  # drop xml decl + doctype
maps = {int(m.get("index")): {int(k.get("code")): k for k in m} for m in root.iter("keyMap")}
actions = {a.get("id"): a for a in root.iter("action")}


def mac_out(index, code):
    k = maps[index][code]
    if k.get("output") is not None:
        return k.get("output")
    a = actions[k.get("action")]
    return next(w.get("output") for w in a if w.get("state") == "none")


EXPECT = {  # mac keycode: (Option, Shift+Option, Caps+Option)
    31: ("ö", "Ö", "Ö"), 5: ("ğ", "Ğ", "Ğ"), 1: ("ş", "Ş", "Ş"),
    8: ("ç", "Ç", "Ç"), 39: ("ʼ", "ʼ", "ʼ"),
}
for code, (o, so, co) in EXPECT.items():
    check(mac_out(3, code) == o, "mac Option %d" % code)
    check(mac_out(4, code) == so, "mac Shift+Option %d" % code)
    check(mac_out(5, code) == co, "mac Caps+Option %d" % code)
check(mac_out(0, 31) == "o" and mac_out(1, 31) == "O", "mac base o/O")
check(maps[3][14].get("action") == "dead_acute", "mac ⌥e should stay a dead key")
check(mac_out(3, 0) == "å", "mac ⌥a should stay å")
for i in range(7):
    check(len(maps[i]) >= 70, "mac map %d looks incomplete" % i)

check(os.path.exists(os.path.join(RES, "Uzbek Keyboard.icns")), "mac icon missing (run: swift tools/make_icon.swift)")

# --- Windows ---------------------------------------------------------------
klc_raw = open(os.path.join(ROOT, "windows/UzbekKeyboard.klc"), "rb").read()
check(klc_raw[:2] == b"\xff\xfe", "klc must be UTF-16 LE with BOM")
klc = klc_raw.decode("utf-16")
rows = {}
for line in klc.splitlines():
    p = line.split()
    if len(p) == 8 and re.fullmatch(r"[0-9a-f]{2}", p[0]):
        rows[p[1]] = p[2:]
for vk, (alt, shalt) in {"O": ("00f6", "00d6"), "G": ("011f", "011e"),
                         "S": ("015f", "015e"), "C": ("00e7", "00c7"),
                         "OEM_7": ("02bc", "02bc")}.items():
    check(vk in rows, "klc missing VK_" + vk)
    if vk in rows:
        check(rows[vk][4:6] == [alt, shalt], "klc AltGr VK_%s: %s" % (vk, rows[vk]))
        if vk != "OEM_7":
            check(rows[vk][0] == "5", "klc Caps Lock flag VK_" + vk)
check(len(rows) == 50, "klc should define 50 keys, has %d" % len(rows))

# --- Linux -----------------------------------------------------------------
xkb = open(os.path.join(ROOT, "linux/xkb/symbols/uzbekkb"), encoding="utf-8").read()
for frag in ("odiaeresis, Odiaeresis", "gbreve, Gbreve", "scedilla, Scedilla",
             "ccedilla, Ccedilla", "U02BC, U02BC", 'include "level3(ralt_switch)"'):
    check(frag in xkb, "xkb missing " + frag)

if failures:
    print("FAILED:\n- " + "\n- ".join(failures))
    sys.exit(1)
print("All layout checks passed.")
