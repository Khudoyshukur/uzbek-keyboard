# Windows: örnatiş va öçiriş

[← Bosh sahifa](../README.md)

## Örnatiş (tavsiya etiladi)

1. **Start** tugmasini bosing, *PowerShell* deb yozing va uni oçing.
2. Quyidagi qatorni nusxalang, PowerShellga qöying (siçqonçaning öng tugmasi) va Enter bosing:
   ```powershell
   irm https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/windows/get.ps1 | iex
   ```
3. *"Do you want to allow this app to make changes to your device?"* deb söralganda **Yes** ni bosing.
4. Tayyor. Klaviaturalar orasida **Win + Space** bilan almaşing. Röyxatda **Uzbek Latin** paydo böladi.
   Darhol körinmasa, tizimdan çiqib qayta kiring.

## Boşqa usul: ZIP arxiv

1. [Releases](https://github.com/khudoyshukur/uzbek-keyboard/releases/latest) sahifasidan `UzbekKeyboard-Windows-….zip` ni yuklab oling.
2. Arxivni oçing: öng tugma → **Extract All** → **Extract**. Arxiv içida turib işga tuşirmang.
3. `install.cmd` ni ikki marta bosing.
   - *"Windows protected your PC"* çiqsa: **More info → Run anyway**.
   - Administrator ruxsati söralganda **Yes** ni bosing.

## Muammolar

**Win + Space bosganda Uzbek Latin yöq.**
Tizimdan çiqib qayta kiring. Baribir körinmasa: **Settings → Time & language → Language & region → Uzbek (Latin) → ⋯ → Language options → Add a keyboard → Uzbek Latin**.

**Ayrim dasturlarda Ctrl + Alt + O/G/S/C qisqa tugmalari işlamayapti.**
Bu barça AltGr klaviaturalarida şunday, çunki bu tugmalar harf yoziş uçun band.

**Windows on ARM** (masalan, Snapdragon noutbuklar) hozirça qöllab-quvvatlanmaydi.

## Öçiriş

PowerShellda:
```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/windows/get.ps1))) -Uninstall
```
Yoki ZIP arxivdagi `uninstall.cmd` ni ikki marta bosing. Keyin tizimdan çiqib qayta kiring.
