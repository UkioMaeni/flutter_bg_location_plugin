import  Flutter

final class PluginContext {
    static let shared = PluginContext()        
    private init() {}

    // всё, что нужно хендлерам
    let locationService = LocationService()
    let locationStorage = LocationStorage()
    var channel: FlutterMethodChannel!

    var handlers: [Handler] = [
        StartTrackingHandler(),
        StopTrackingHandler(),
        LocationServiceStatusHandler(),
        LocationServiceMetaHandler()
    ]

    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let handler = handlers.first(where: { $0.callMethod == call.method }) {
            handler.handle(context: self, call: call, result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}