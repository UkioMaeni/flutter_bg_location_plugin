import  Flutter

protocol  Handler {
    var callMethod: String {get}
    fun handler(call: FlutterMethodCall, result: @escaping FlutterResult,){

    }
    
}