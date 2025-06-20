import CoreLocation

/// Сервис локации
class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private unowned let ctx: PluginContext 
    init(context: PluginContext) {
        self.ctx = context
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    private(set) var isRunning = false;
    private var timer: Timer?
    private var lastLocation: CLLocation?

        
    func start() {
        manager.requestAlwaysAuthorization();
        manager.startUpdatingLocation();
        isRunning = true;

        let locationStorage =  ctx.locationStorage;
        let tickerSeconds = locationStorage.getTickerSeconds();

        tick(countering: false);
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(tickerSeconds), repeats: true) { [weak self] _ in
                self?.tick(countering: true)
            }
        }

    }
    
    func stop() {
        manager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        let locationStorage =  ctx.locationStorage;
        locationStorage.setTickers(0);
    }

    private func tick(countering: Bool) {

        let locationStorage =  ctx.locationStorage;
        let lastTickers = locationStorage.getTickers();
        if(lastTickers<=0){
            stop();
            return;
        }
        if(countering){
            locationStorage.declineOneTickers();
        }
        print("LocationService tick")
        guard let loc = lastLocation else { return }
        
        print("LocationService tick lat \(loc.coordinate.latitude)")
        print("LocationService tick lon \(loc.coordinate.longitude)")

    }

    func locationManager(_ mgr: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        lastLocation = locs.last;
    }
    
    @discardableResult
    func startTracking(seconds: Int, hash: String, orderId: Int) -> Bool {
        if(isRunning){
            print("LocationService already running")
            return false
        }
        let locationStorage =  PluginContext.shared.locationStorage;
        let tickerSeconds =  locationStorage.getTickerSeconds(); //раз в сколько секунд будет происходить тик. 
        let tickerCount = seconds/tickerSeconds;

        locationStorage.setTickers(tickerCount);
        locationStorage.setHash(hash);
        locationStorage.setOrderId(orderId);

        start();
        return true
    }

    @discardableResult
    func stopTracking() -> Bool {
        if(isRunning){
            stop();
            return true;
        }
        return false;
    }
}

