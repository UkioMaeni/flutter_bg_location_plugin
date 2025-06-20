import  Flutter

final class LocationServiceStatusHandler: Handler {

    let callMethod = CallMethods.LOCATION_SERVICE_STATUS

    func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let isStarted = PluginContext.shared.locationService.isRunning;      
        result(isStarted)
    }
}