# macOS: örnatiş va öçiriş

[← Bosh sahifa](../README.md)

## Örnatiş (tavsiya etiladi)

1. **Terminal** ilovasini oçing: `⌘ Space` ni bosing, *Terminal* deb yozing va Enter bosing.
2. Quyidagi qatorni nusxalang, Terminalga qöying va Enter bosing:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash
   ```
3. Skript klaviaturani örnatadi va uni klaviaturalar röyxatiga qöşadi.
   Oxirida *"Hozir çiqasizmi?"* deb söraydi. `ha` deb yozing va Enter bosing.
   macOS yangi klaviaturani faqat qayta kirganda yuklaydi.
4. Qayta kirgaç **fn / 🌐** tugmasini bosing. Röyxatda **UZ** belgili **Uzbek Latin** paydo böladi.

Administrator paroli kerak emas. Apple'ning *"could not verify"* ogohlantirişi ham çiqmaydi.

## Boşqa usul: .pkg installer

1. [Releases](https://github.com/khudoyshukur/uzbek-keyboard/releases/latest) sahifasidan `UzbekKeyboard-macOS-….pkg` ni yuklab oling va ikki marta bosing.
   Paket Apple tomonidan imzolangan va tekşirilgan (notarized).
2. Örnatiş tugagaç tizimdan çiqib qayta kiring.

## Muammolar

**fn / 🌐 bosganda Uzbek Latin körinmayapti.**
Avval tizimdan çiqib qayta kirganingizga işonç hosil qiling. Agar baribir körinmasa, qölda qöşing:
**System Settings → Keyboard → Text Input → Edit… → +** → qidiruvga *Uzbek* deb yozing → **Uzbek Latin** → **Add**.

**⌥ + o bosganda ø çiqyapti.**
Hozir boşqa klaviatura tanlangan. Menyu satridagi belgi **UZ** ekanini tekşiring.

## Öçiriş

Terminalda:
```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/macos/install.sh | bash -s -- --uninstall
```
Skript klaviaturani röyxatdan olib taşlaydi va fayllarni öçiradi. Keyin tizimdan çiqib qayta kiring.

Qölda öçiriş:
1. **System Settings → Keyboard → Text Input → Edit…** ni oçing, **Uzbek Latin** ni tanlang va **−** ni bosing.
2. Finder'da `⇧ ⌘ G` ni bosing, `~/Library/Keyboard Layouts` ni oçing va `UzbekKeyboard.bundle` ni öçiring.
   .pkg orqali örnatgan bölsangiz, `/Library/Keyboard Layouts` papkasidan öçiring.
3. Tizimdan çiqib qayta kiring.
