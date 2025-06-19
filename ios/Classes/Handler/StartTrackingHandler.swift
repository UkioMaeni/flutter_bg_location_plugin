final class StartTrackingHandler: Handler {

    let callMethod = "startTracking"

    func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {

        guard let args = call.arguments as? [String: Any] else { return result(false) }

        let seconds = args?["seconds"] as? Int ?? 0;
        let hash = args?["hash"] as? String ?? "";
        let orderId = args?["orderId"] as? String ?? "";
        // пример работы с UserDefaults
        if let h = args["hash"] as? String {
            UserDefaults.standard.set(h, forKey: "hash")
        }

        let svc = PluginContext.shared.service            // <-singleton
        if !svc.isRunning { svc.start() }

        result(true)
    }
}