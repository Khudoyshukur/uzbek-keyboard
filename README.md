# Özbekça klaviatura

Yangi özbek lotin alifbosi uçun klaviatura: **Ö ö, Ğ ğ, Ş ş, Ç ç** va tutuq belgisi **ʼ**.

Sayt va Kirill ↔ Lotin ↔ Yangi lotin konvertori: **[uzbek-keyboard.safix.uz](https://uzbek-keyboard.safix.uz)**

- Asosi odatiy **US QWERTY**, yaʼni siz bilgan tugmalar özgarmaydi.
- Harfni **Option ⌥** (macOS) yoki **öng tarafdagi Alt** (Windows, Linux) bilan birga bosasiz.
- Fonda heç qanday dastur işlamaydi. Bu tizimning öz klaviatura fayli.

[![Build](https://github.com/khudoyshukur/uzbek-keyboard/actions/workflows/build.yml/badge.svg)](https://github.com/khudoyshukur/uzbek-keyboard/actions/workflows/build.yml)

## Qanday yoziladi

| Harf | macOS | Windows / Linux |
|:---:|---|---|
| **ö  Ö** | `⌥ O`  ·  `⌥ ⇧ O` | `öng Alt O`  ·  `öng Alt ⇧ O` |
| **ğ  Ğ** | `⌥ G`  ·  `⌥ ⇧ G` | `öng Alt G`  ·  `öng Alt ⇧ G` |
| **ş  Ş** | `⌥ S`  ·  `⌥ ⇧ S` | `öng Alt S`  ·  `öng Alt ⇧ S` |
| **ç  Ç** | `⌥ C`  ·  `⌥ ⇧ C` | `öng Alt C`  ·  `öng Alt ⇧ C` |
| **ʼ** | `⌥ '` | `öng Alt '` |

Caps Lock yoqilgan bölsa, katta harf çiqadi. Windowsda `öng Alt` örniga `Ctrl + Alt` ham işlaydi.

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

> **Muhim:** örnatgandan va öçirgandan söng **tizimdan çiqib qayta kiring** (Log out → Log in).
> Usiz klaviatura röyxatda körinmasligi yoki öçirilgandan keyin ham qolib ketişi mumkin.

Batafsil yöriqnoma, boşqa usullar va **öçiriş**: [macOS](docs/macos.md) · [Windows](docs/windows.md) · [Linux](docs/linux.md)

Fayllarni qölda yuklab olmoqçi bölsangiz: [Releases](https://github.com/khudoyshukur/uzbek-keyboard/releases/latest)

## Loyihaga hissa qöşiş

[docs/development.md](docs/development.md)

## Litsenziya

[MIT](LICENSE) © 2026 Khudoyshukur Juraev · [English](README.en.md)
