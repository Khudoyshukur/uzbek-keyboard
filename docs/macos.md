# macOS: örnatiş va öçiriş

[← Bosh sahifa](../README.md)

## Örnatiş (tavsiya etiladi)

1. **Terminal** ilovasini oçing: `⌘ Space` ni bosing, *Terminal* deb yozing va Enter bosing.
2. Quyidagi qatorni nusxalang, Terminalga qöying va Enter bosing:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash
   ```
3. Skript klaviaturani örnatadi va uni klaviaturalar röyxatiga qöşadi. Tizimdan çiqib qayta kiriş şart emas.
4. **fn / 🌐** tugmasini bosing. Röyxatda **UZ** belgili **Uzbek Latin** paydo böladi.

Administrator paroli kerak emas. Apple'ning *"could not verify"* ogohlantirişi ham çiqmaydi.

## Boşqa usul: .pkg installer

1. [Releases](https://github.com/khudoyshukur/uzbek-keyboard/releases/latest) sahifasidan `UzbekKeyboard-macOS.pkg` ni yuklab oling va ikki marta bosing.
2. *"Apple could not verify…"* degan oyna çiqsa:
   **Done** ni bosing → **System Settings → Privacy & Security** ni oçing → pastga tuşing → **Open Anyway** ni bosing.
   Bu ogohlantiriş paket hali Apple tomonidan imzolanmagani uçun çiqadi. Fayl xavfsiz.
3. Örnatiş tugagaç **fn / 🌐** tugmasini bosing va **Uzbek Latin** ni tanlang.

## Muammolar

**fn / 🌐 bosganda Uzbek Latin körinmayapti.**
Tizimdan çiqib qayta kiring. Agar baribir körinmasa, qölda qöşing:
**System Settings → Keyboard → Text Input → Edit… → +** → qidiruvga *Uzbek* deb yozing → **Uzbek Latin** → **Add**.

**⌥ + o bosganda ø çiqyapti.**
Hozir boşqa klaviatura tanlangan. Menyu satridagi belgi **UZ** ekanini tekşiring.

## Öçiriş

Terminalda:
```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash -s -- --uninstall
```
Skript klaviaturani röyxatdan olib taşlaydi va fayllarni öçiradi.

Qölda öçiriş:
1. **System Settings → Keyboard → Text Input → Edit…** ni oçing, **Uzbek Latin** ni tanlang va **−** ni bosing.
2. Finder'da `⇧ ⌘ G` ni bosing, `~/Library/Keyboard Layouts` ni oçing va `UzbekKeyboard.bundle` ni öçiring.
   .pkg orqali örnatgan bölsangiz, `/Library/Keyboard Layouts` papkasidan öçiring.
3. Tizimdan çiqib qayta kiring.
