import UIKit
import Flutter
import os.log
import flutter_bg_location_plugin
@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    LocationService.registerBackgroundTask()
    _=VoIPPushRegistryHandler.shared
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
