import  Flutter

final class LocationServiceMetaHandler: Handler {

    let callMethod = CallMethods.LOCATION_SERVICE_META

    func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {

        PluginContext.shared.

        print("FlutterLocationPlugin", "startTracking invoked")
        guard let args = call.arguments as? [String: Any] else { return result(false) }

        let seconds = args?["seconds"] as? Int ?? 0;
        let hash = args?["hash"] as? String ?? "";
        let orderId = args?["orderId"] as? String ?? "";
  
        let isStarted = PluginContext.shared.locationService.startTracking(seconds, hash, orderId)       
        result(isStarted)
    }
}