//
//  LocationService.swift
//  
//
//  Created by Gost on 16.06.2025.
//

import CoreLocation

/// Сервис, который управляет CLLocationManager и отдаёт коллбэк при обновлении
class LocationService: NSObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
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
  }

  func stop() {
    manager.stopUpdatingLocation()
  }

  // MARK: CLLocationManagerDelegate
  func locationManager(_ mgr: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
    guard let loc = locs.last else { return }
    onLocation?(loc.coordinate.latitude, loc.coordinate.longitude)
  }
}
