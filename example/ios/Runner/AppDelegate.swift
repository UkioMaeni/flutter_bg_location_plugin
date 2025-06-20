import UIKit
import Flutter
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    LocationService.registerBackgroundTask()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
