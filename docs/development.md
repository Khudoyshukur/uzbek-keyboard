# Dasturçilar uçun

[← Bosh sahifa](../README.md)

## Tuzilma

```
tools/generate.py      barça klaviatura fayllari şu bitta jadvaldan yaratiladi
tools/make_icon.swift  macOS menyusidagi "UZ" belgisi (Uzbek Keyboard.icns)
tests/                 yaratilgan fayllarni tekşiradi
macos/                 UzbekKeyboard.bundle, install.sh, build.sh (.zip + .pkg)
windows/               UzbekKeyboard.klc, build.ps1 (kbdutool), get.ps1, install/uninstall
linux/                 XKB fayllari, install.sh
.github/workflows/     har bir push'da uçala tizim uçun yiğadi va tekşiradi
```

## Klaviaturani özgartiriş

1. `tools/generate.py` dagi `UZBEK` jadvalini tahrirlang.
2. Quyidagini işga tuşiring:
   ```sh
   python3 tools/generate.py && python3 tests/check_layouts.py
   ```
3. Yaratilgan fayllarni ham commit qiling. Ular eskirgan bölsa, CI xato beradi.

Yaratilgan fayllarni (`.keylayout`, `.klc`, XKB) qölda tahrirlamang.

## Reliz

`VERSION` ni yangilang, `python3 tools/generate.py` ni işga tuşiring, commit qiling, keyin:
```sh
git tag v1.2.3 && git push origin v1.2.3
```
CI barça fayllarni yiğib, GitHub Releases'ga joylaydi (`.pkg` imzolanadi va notarize qilinadi).
Fayl nomlarida versiya bor (masalan `UzbekKeyboard-macOS-1.2.3.pkg`). Örnatiş skriptlari
`releases/latest` orqali eng sönggi tegni aniqlab, şu versiyadagi faylni yuklaydi.

## Texnik tafsilotlar

- **macOS:** `.keylayout` Apple'ning töliq US klaviaturasini öz içiga oladi (Option qatlami va `` ⌥` ⌥E ⌥U ⌥I ⌥N `` urğu tugmalari). Faqat 5 ta tugma almaştirilgan.
  Içki nomi `Uzbek Keyboard` (foydalanuvçi sozlamalarida saqlanadi, özgartirmang). Körinadigan nomi `Uzbek Latin`.
- **Windows:** til `0443` (uz-Latn-UZ), DLL `uzbekkb.dll`. Harflar `Ctrl+Alt` (AltGr) ustunlarida, Caps Lock ularga ham taʼsir qiladi (`Cap = 5`). ARM64 qöllab-quvvatlanmaydi, çunki kbdutool uni yiğa olmaydi.
- **Linux:** `us(basic)` + öng Alt'da 3-daraja (`level3(ralt_switch)`).
