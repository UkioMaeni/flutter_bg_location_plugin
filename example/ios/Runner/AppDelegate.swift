import UIKit
import Flutter
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate {

  private var tickTimer: Timer? 
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    tickTimer = Timer(timeInterval: 3, repeats: true) { _ in
      NSLog("⏰ tick %@", Date() as NSDate)   // или os_log(.info, "⏰ tick %{public}@", Date() as CVarArg)
    }
    RunLoop.main.add(tickTimer!, forMode: .common)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
