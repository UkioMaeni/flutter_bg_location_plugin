import  Flutter

final class LocationServiceMetaHandler: Handler {

    let callMethod = CallMethods.LOCATION_SERVICE_META

    func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {

        let storage = PluginContext.shared.locationStorage;
        let meta: [String: Any] = [
            "tickerSeconds": storage.getTickerSeconds(),
            "tickersCount":  storage.getTickers(),
            "hash":          storage.getHash(),
            "orderId":       storage.getOrderId()
        ]    
        result(meta)
    }
}