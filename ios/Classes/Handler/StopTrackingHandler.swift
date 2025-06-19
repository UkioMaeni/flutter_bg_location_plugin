import  Flutter

final class StopTrackingHandler: Handler {

    let callMethod = "stopTracking"

    func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("FlutterLocationPlugin", "stopTracking invoked")

        let isStoped =  PluginContext.shared.locationService.stopTracking()
        result(isStoped)
    }
}