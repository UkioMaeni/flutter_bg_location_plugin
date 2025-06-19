import  Flutter

final class PluginContext {
    static let shared = PluginContext()        
    private init() {}

    // всё, что нужно хендлерам
    let locationService = LocationService()
    let storage = LocationStorage()
    var channel: FlutterMethodChannel!
}