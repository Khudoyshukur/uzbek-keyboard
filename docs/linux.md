# Linux: örnatiş va öçiriş

[← Bosh sahifa](../README.md)

## Örnatiş (tavsiya etiladi)

Terminalda:
```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/linux/install.sh | sh
```
Skript klaviaturani joriy foydalanuvçi uçun örnatadi. GNOME'da u klaviaturalar röyxatiga avtomatik qöşiladi.
Keyin tizimdan çiqib qayta kiring va **Uzbek Latin** ni tanlang.

**AltGr** bu klaviaturadagi **öng Alt** tugmasi.

## Boşqa muhitlar

| Muhit | Nima qiliş kerak |
|---|---|
| KDE Plasma | System Settings → Keyboard → Layouts → **Add** → *Uzbek Latin* |
| Sway | konfiguratsiyaga: `input * xkb_layout "us,uzbekkb"` |
| X11 (Xorg) sessiyasi | barça foydalanuvçilar uçun örnating (pastda), keyin `setxkbmap uzbekkb` |

Barça foydalanuvçilar uçun örnatiş (X11 uçun ham kerak):
```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/linux/install.sh | sudo sh -s -- --system
```

## Öçiriş

```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/linux/install.sh | sh -s -- --uninstall
```
`--system` bilan örnatgan bölsangiz:
```sh
curl -fsSL https://raw.githubusercontent.com/khudoyshukur/uzbek-keyboard/main/linux/install.sh | sudo sh -s -- --system --uninstall
```
Keyin tizimdan çiqib qayta kiring.
