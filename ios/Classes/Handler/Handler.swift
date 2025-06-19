import  Flutter

protocol  Handler {
    var callMethod: String {get}
    func handler(call: FlutterMethodCall, result: @escaping FlutterResult,)
    
}