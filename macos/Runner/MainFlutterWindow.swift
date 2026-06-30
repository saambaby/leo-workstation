import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Hide the centered system title; keep traffic-light window controls.
    titleVisibility = .hidden
    titlebarAppearsTransparent = true
    styleMask.insert(.fullSizeContentView)
    isMovableByWindowBackground = true

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
