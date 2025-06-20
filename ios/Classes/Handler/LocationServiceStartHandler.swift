import  Flutter

final class LocationServiceStartHandler: Handler {

    let callMethod = CallMethods.LOCATION_SERVICE_START

    func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("FlutterLocationPlugin", "startTracking invoked")
        guard let args = call.arguments as? [String: Any] else { return result(false) }

        let seconds = args["seconds"] as? Int ?? 0;
        let hash = args["hash"] as? String ?? "";
        let orderId = args["orderId"] as? Int ?? 0;
  
        let isStarted = PluginContext.shared.locationService.startTracking(seconds:seconds, hash:hash, orderId:orderId)       
        result(isStarted)
    }
}
