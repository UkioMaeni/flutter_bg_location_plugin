import Flutter
import UIKit
import AudioToolbox

@objc(FlutterBgLocationPlugin)
public class FlutterBgLocationPlugin: NSObject, FlutterPlugin {
    
    
    @objc public static func register(with registrar: FlutterPluginRegistrar) {
      print("🔌 FlutterBgLocationPlugin.register called")
        let ctx = PluginContext.shared;
        ctx.channel = FlutterMethodChannel(name: "flutter_bg_location_plugin", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: ctx.channel)
        // let instance = FlutterBgLocationPlugin(channel: channel)
        
        
        
        // instance.service.onLocation = { lat, lng in
        //     print("lat");
        //     print(lat);
        //     print("📍 background location: \(lat), \(lng)")
        //     //instance.channel.invokeMethod("onLocation", arguments: ["lat": lat, "lng": lng])
        // }
        
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
        guard let args = call.arguments as? [String: Any] else { return result(false) }
        if let h = args["hash"] as? String {                   // #3 set
            UserDefaults.standard.setValue(h, forKey: "hash")
        }
        if let s = args["seconds"] as? Int {
            UserDefaults.standard.setValue(s, forKey: "seconds")
        }
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
