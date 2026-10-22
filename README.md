# Özbekça klaviatura

Yangi özbek lotin alifbosi uçun klaviatura: **Ö ö, Ğ ğ, Ş ş, Ç ç** va tutuq belgisi **ʼ**.

- Asosi odatiy **US QWERTY**, yaʼni siz bilgan tugmalar özgarmaydi.
- Harfni **Option ⌥** (macOS) yoki **AltGr / öng Alt** (Windows, Linux) bilan birga bosasiz.
- Fonda heç qanday dastur işlamaydi. Bu tizimning öz klaviatura fayli.

[![Build](https://github.com/khudoyshukur/uzbek-keyboard/actions/workflows/build.yml/badge.svg)](https://github.com/khudoyshukur/uzbek-keyboard/actions/workflows/build.yml)

## Qanday yoziladi

| Harf | macOS | Windows / Linux |
|:---:|---|---|
| **ö  Ö** | `⌥ O`  ·  `⌥ ⇧ O` | `AltGr O`  ·  `AltGr ⇧ O` |
| **ğ  Ğ** | `⌥ G`  ·  `⌥ ⇧ G` | `AltGr G`  ·  `AltGr ⇧ G` |
| **ş  Ş** | `⌥ S`  ·  `⌥ ⇧ S` | `AltGr S`  ·  `AltGr ⇧ S` |
| **ç  Ç** | `⌥ C`  ·  `⌥ ⇧ C` | `AltGr C`  ·  `AltGr ⇧ C` |
| **ʼ** | `⌥ '` | `AltGr '` |

Caps Lock yoqilgan bölsa, katta harf çiqadi. Windowsda `AltGr` örniga `Ctrl + Alt` ham işlaydi.

## Örnatiş

Bitta buyruq kifoya. U klaviaturani yuklab oladi, örnatadi va yoqib qöyadi.

**macOS:** *Terminal* ilovasini oçing va quyidagini kiriting:
```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash
```

**Windows:** *PowerShell* ni oçing va quyidagini kiriting:
```powershell
irm https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/windows/get.ps1 | iex
```

**Linux:**
```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/linux/install.sh | sh
```

Batafsil yöriqnoma, boşqa usullar va **öçiriş**: [macOS](docs/macos.md) · [Windows](docs/windows.md) · [Linux](docs/linux.md)

Fayllarni qölda yuklab olmoqçi bölsangiz: [Releases](https://github.com/khudoyshukur/uzbek-keyboard/releases/latest)

## Telefonlar

Android va iPhone ekran klaviaturasini bunday fayl bilan özgartirib bölmaydi, buning uçun alohida ilova kerak.
Hozirça Gboard yoki iPhone klaviaturasida **o, g, s, c** harfini bosib turing, ö ğ ş ç çiqadi.

## Loyihaga hissa qöşiş

[docs/development.md](docs/development.md)

## Litsenziya

[MIT](LICENSE) © 2026 Khudoyshukur Juraev · [English](README.en.md)
