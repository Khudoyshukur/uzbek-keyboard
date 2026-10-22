// Draws the menu-bar icon ("UZ" knocked out of a rounded square, like Apple's
// "РУ") and writes macos/UzbekKeyboard.bundle/Contents/Resources/Uzbek Keyboard.icns.
// Run on macOS:  swift tools/make_icon.swift
import AppKit

let label = "UZ"
let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
let iconset = FileManager.default.temporaryDirectory.appendingPathComponent("UzbekKeyboard.iconset")
try? FileManager.default.removeItem(at: iconset)
try! FileManager.default.createDirectory(at: iconset, withIntermediateDirectories: true)

func render(points: Int, scale: Int) -> Data {
    let px = points * scale
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: px, pixelsHigh: px,
                               bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                               colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    rep.size = NSSize(width: points, height: points)
    NSGraphicsContext.saveGraphicsState()
    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let s = CGFloat(points)
    let box = NSRect(x: s * 0.03, y: s * 0.12, width: s * 0.94, height: s * 0.76)
    NSColor.black.setFill()
    NSBezierPath(roundedRect: box, xRadius: s * 0.16, yRadius: s * 0.16).fill()
    ctx.compositingOperation = .destinationOut
    let font = NSFont.systemFont(ofSize: s * 0.52, weight: .bold)
    let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: NSColor.black, .kern: -s * 0.02]
    let text = NSAttributedString(string: label, attributes: attrs)
    let size = text.size()
    text.draw(at: NSPoint(x: box.midX - size.width / 2, y: box.midY - size.height / 2 + font.descender * 0.15))
    NSGraphicsContext.restoreGraphicsState()
    return rep.representation(using: .png, properties: [:])!
}

for (pt, scale, name) in [(16, 1, "16x16"), (16, 2, "16x16@2x"), (32, 1, "32x32"), (32, 2, "32x32@2x")] {
    try! render(points: pt, scale: scale).write(to: iconset.appendingPathComponent("icon_\(name).png"))
}
let out = root.appendingPathComponent("macos/UzbekKeyboard.bundle/Contents/Resources/Uzbek Keyboard.icns")
let p = Process()
p.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
p.arguments = ["-c", "icns", iconset.path, "-o", out.path]
try! p.run(); p.waitUntilExit()
precondition(p.terminationStatus == 0, "iconutil failed")
try? FileManager.default.copyItem(at: iconset.appendingPathComponent("icon_32x32@2x.png"),
                                  to: FileManager.default.temporaryDirectory.appendingPathComponent("uzk-preview.png"))
print("wrote", out.path)
