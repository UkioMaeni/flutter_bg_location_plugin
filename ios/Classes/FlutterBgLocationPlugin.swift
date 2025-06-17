import Flutter
import UIKit
import AudioToolbox

@objc(FlutterBgLocationPlugin)
public class FlutterBgLocationPlugin: NSObject, FlutterPlugin {
    
    private let service = LocationService()
    private var channel: FlutterMethodChannel
    
    @objc public static func register(with registrar: FlutterPluginRegistrar) {
      print("🔌 FlutterBgLocationPlugin.register called")
        let channel = FlutterMethodChannel(name: "flutter_bg_location_plugin", binaryMessenger: registrar.messenger())
        let instance = FlutterBgLocationPlugin(channel: channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.service.onLocation = { lat, lng in
            print("lat");
            print(lat);
            print("📍 background location: \(lat), \(lng)")
            //instance.channel.invokeMethod("onLocation", arguments: ["lat": lat, "lng": lng])
        }
        
  }
    init(channel : FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      NSLog("…")
      print("🛎️ Swift.handle() got: \(call.method)")
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    switch call.method {
    case "startTracking":
        print("📍 startTracking")
        service.start()
        result(true)
    case "stopTracking":
        service.stop()
        result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
