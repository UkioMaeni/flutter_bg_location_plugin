import  Flutter

final class PluginContext {
    static let shared = PluginContext()        
    private init() {

    }

    // всё, что нужно хендлерам
    var locationService :LocationService!
    let locationStorage = LocationStorage.shared
    var channel: FlutterMethodChannel!

    var handlers: [Handler] = [
        LocationServiceStartHandler(),
        LocationServiceStopHandler(),
        LocationServiceStatusHandler(),
        LocationServiceMetaHandler()
    ]

    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let handler = handlers.first(where: { $0.callMethod == call.method }) {
            handler.handler(call: call, result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}