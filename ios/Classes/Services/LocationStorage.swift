import Foundation

/// iOS-эквивалент Android LocationStorage на базе UserDefaults
class LocationStorage {
    static let shared = LocationStorage()
    private let defaults = UserDefaults.standard
    private init() {}

    // MARK: - Keys и значения по умолчанию
    private enum Keys {
        static let hash = "hash"
        static let tickerSeconds = "ticker_seconds"
        static let tickersLeft = "tickers_left"
        static let tickerId = "ticker_id"
        static let orderId = "order_id"
    }
    private let defaultTickerSeconds = 10

    // MARK: - Хэш
    func getHash() -> String {
        return defaults.string(forKey: Keys.hash) ?? ""
    }

    func setHash(_ hash: String) {
        defaults.set(hash, forKey: Keys.hash)
    }

    // MARK: - Секунды для тикера
    func getTickerSeconds() -> Int {
        if let value = defaults.object(forKey: Keys.tickerSeconds) as? Int {
            return value
        }
        return defaultTickerSeconds
    }

    func setTickerSeconds(_ seconds: Int) {
        defaults.set(seconds, forKey: Keys.tickerSeconds)
    }

    // MARK: - Количество тикеров
    func getTickers() -> Int {
        return defaults.integer(forKey: Keys.tickersLeft)
    }

    func setTickers(_ count: Int) {
        defaults.set(count, forKey: Keys.tickersLeft)
    }

    func declineOneTickers() {
        let current = getTickers()
        defaults.set(max(current - 1, 0), forKey: Keys.tickersLeft)
    }

    // MARK: - ID тикера
    func getTickerId() -> String {
        return defaults.string(forKey: Keys.tickerId) ?? ""
    }

    func setTickerId(_ id: String) {
        defaults.set(id, forKey: Keys.tickerId)
    }

    // MARK: - ID ордера
    func getOrderId() -> Int {
        return defaults.integer(forKey: Keys.orderId) ?? 0
    }

    func setOrderId(_ id: Int) {
        defaults.set(id, forKey: Keys.orderId)
    }
}
