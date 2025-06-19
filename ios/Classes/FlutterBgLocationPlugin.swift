import Flutter
import UIKit

@objc(FlutterBgLocationPlugin)
public class FlutterBgLocationPlugin: NSObject, FlutterPlugin {
    
    
    @objc public static func register(with registrar: FlutterPluginRegistrar) {
      print("🔌 FlutterBgLocationPlugin.register called")
        let ctx = PluginContext.shared;
        let channel = FlutterMethodChannel(name: "flutter_bg_location_plugin", binaryMessenger: registrar.messenger())
        ctx.channel = channel
        let instance = FlutterBgLocationPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel) 
   }

  private let channel: FlutterMethodChannel

   @objc public init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult){
    PluginContext.shared.handleMethodCall(call,result:result)
  }
}
