import CoreLocation
import BackgroundTasks
/// Сервис локации
class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private unowned let ctx: PluginContext

    private var currentBGTask: BGProcessingTask?
    private let taskIdentifier = "com.example.app.locationProcessing" 

    init(context: PluginContext) {
        self.ctx = context
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { [weak self] task in
            self?.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }

    private func handleBackgroundTask(task: BGProcessingTask) {
        scheduleBackgroundTask() // повторное планирование
        currentBGTask = task
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        // Запрашиваем одиночную локацию
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
    }
    private func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: taskIdentifier)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        // Earliest next run
        request.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(storage.getTickerSeconds()))
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule location BG task: \(error)")
        }
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
        //lastLocation = locs.last;
        guard let loc = locations.last else { return }
        sendLocation(loc)
        currentBGTask?.setTaskCompleted(success: true)
        currentBGTask = nil

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        currentBGTask?.setTaskCompleted(success: true)
        currentBGTask = nil
    }
    
    private func sendLocation(_ loc: CLLocation) {
        print("LocationService tick lat \(loc.coordinate.latitude)")
        print("LocationService tick lon \(loc.coordinate.longitude)")
        let remaining = storage.getTickers()
        guard remaining > 0 else {
            stopTracking()
            return
        }
        storage.declineOneTickers()
        // HttpService.sendLocation(lat: loc.coordinate.latitude,
        //                          lng: loc.coordinate.longitude,
        //                          hash: storage.getHash())
    }

    @discardableResult
    func startTracking(seconds: Int, hash: String, orderId: Int) -> Bool {
        // if(isRunning){
        //     print("LocationService already running")
        //     return false
        // }
        let locationStorage =  PluginContext.shared.locationStorage;
        let tickerSeconds =  locationStorage.getTickerSeconds(); //раз в сколько секунд будет происходить тик. 
        let tickerCount = seconds/tickerSeconds;

        locationStorage.setTickers(tickerCount);
        locationStorage.setHash(hash);
        locationStorage.setOrderId(orderId);
        scheduleBackgroundTask()
        //start();
        return true
    }

    @discardableResult
    func stopTracking() -> Bool {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskIdentifier)
        return true;
        // if(isRunning){
        //     stop();
        //     return true;
        // }
        // return false;
    }
}

