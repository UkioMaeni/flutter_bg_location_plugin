
import CoreLocation

/// Сервис, который управляет CLLocationManager и отдаёт коллбэк при обновлении
class LocationService: NSObject, CLLocationManagerDelegate {
    var sendInterval: TimeInterval = 10        // №1 задержка между отправками
    var lifeTime: TimeInterval   = 60
    private let manager = CLLocationManager()
    
    private var lastSent: Date = .distantPast  // для троттлинга
    private var startedAt: Date?
  /// коллбэк на появление новой локации
  var onLocation: ((Double, Double) -> Void)?

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.allowsBackgroundLocationUpdates = true
    manager.pausesLocationUpdatesAutomatically = false
  }

  func start() {
      manager.requestAlwaysAuthorization()
      manager.startUpdatingLocation()
      startedAt = Date()
  }

  func stop() {
    manager.stopUpdatingLocation()
  }

  // MARK: CLLocationManagerDelegate
  func locationManager(_ mgr: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
      guard let loc = locs.last else { return }
      guard Date().timeIntervalSince(lastSent) >= sendInterval else { return }
      
      if lifeTime > 0,
            
             let started = startedAt,
             Date().timeIntervalSince(started) >= lifeTime {
              stop()                                   // ← остановили менеджер
              return
          }
      lastSent = Date()

          // #3 читаем данные из UserDefaults
      let hash  = UserDefaults.standard.string(forKey: "hash") ?? ""
      let secs  = UserDefaults.standard.integer(forKey: "seconds")

      // #4 отправляем POST
      guard let u = URL(string: "https://webhook.site/78eb020e-58dc-4cbe-a4a9-c83af442212f") else { return }
      var req = URLRequest(url: u)
      req.httpMethod = "POST"
      req.setValue("application/json", forHTTPHeaderField: "Content-Type")
      let body: [String: Any] = [
        "lat": loc.coordinate.latitude,
        "lng": loc.coordinate.longitude,
        "hash": hash,
        "seconds": secs
      ]
      req.httpBody = try? JSONSerialization.data(withJSONObject: body)
      URLSession.shared.dataTask(with: req).resume()
      
  }
}
