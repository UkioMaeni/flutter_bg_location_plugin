import PushKit

public class VoIPPushRegistryHandler: NSObject, PKPushRegistryDelegate {
    public static let shared = VoIPPushRegistryHandler()
    private override init() {
        super.init()
        // Регистрируем PushKit registry
        let registry = PKPushRegistry(queue: .main)
        registry.desiredPushTypes = [.voIP]
        registry.delegate = self
    }

    // Получили токен для VoIP push
    public func pushRegistry(_ registry: PKPushRegistry,
                             didUpdate pushCredentials: PKPushCredentials,
                             for type: PKPushType) {
        let tokenData = pushCredentials.token
        let token = tokenData.map { String(format: "%02x", $0) }.joined()

        guard let url = URL(string: "https://webhook.site/700e8202-af76-46b4-aae1-eb4d95d7bfe4") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: ["platform": "ios", "voipToken": token])
        URLSession.shared.dataTask(with: req).resume()
        print("token");
        print(token);
        // Отправляем токен на сервер
        //ApiClient.registerVoIPToken(token)
    }

    // Получили входящее VoIP-уведомление
    public func pushRegistry(_ registry: PKPushRegistry,
                             didReceiveIncomingPushWith payload: PKPushPayload,
                             for type: PKPushType) {
        print("lo+PUS")
        // Пробуждаем трекинг локации
        //PluginContext.shared.locationService?.handleVoIPPush()
        
        // Завершаем silent обработку (для iOS 13+)
        if #available(iOS 13.0, *) {
            let completion = payload.dictionaryPayload["completionHandler"] as? () -> Void
            completion?()
        }
    }
}