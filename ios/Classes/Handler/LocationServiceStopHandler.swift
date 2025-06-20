import  Flutter

final class LocationServiceStopHandler: Handler {

    let callMethod = CallMethods.LOCATION_SERVICE_STOP

    func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("FlutterLocationPlugin", "stopTracking invoked")

        let isStoped =  PluginContext.shared.locationService.stopTracking()
        result(isStoped)
    }
}