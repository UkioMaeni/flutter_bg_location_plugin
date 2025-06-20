import CoreLocation
import BackgroundTasks
import UIKit
/// Сервис локации
public class LocationService: NSObject, CLLocationManagerDelegate {

    static let taskIdentifier = "com.example.app.locationProcessing"

    public static func registerBackgroundTask() {
        PluginContext.shared.locationService = LocationService()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: LocationService.taskIdentifier, using: nil) { task in
            guard let task = task as? BGProcessingTask else { return }
            // Передаём задачу в сервис для обработки
            PluginContext.shared.locationService?.handleBackgroundTask(task: task)
        }
    }

    private let manager = CLLocationManager()
    private unowned let ctx: PluginContext

    private var currentBGTask: BGProcessingTask?
 

    override init() {
        self.ctx = PluginContext.shared
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    private func handleBackgroundTask(task: BGProcessingTask) {
        scheduleBackgroundTask() // повторное планирование
        currentBGTask = task
        print("handleBackgroundTask")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        // Запрашиваем одиночную локацию
        print("Запрашиваем одиночную локацию")
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
    }
    private func scheduleBackgroundTask() {
        print("scheduleBackgroundTask")
        let request = BGProcessingTaskRequest(identifier: LocationService.taskIdentifier)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        // Earliest next run
        let locationStorage =  ctx.locationStorage;

        let intervalSeconds = locationStorage.getTickerSeconds()
        let interval = TimeInterval(intervalSeconds)

        print("[LocationService] intervalSeconds (Int): \(intervalSeconds)")
        print("[LocationService] interval (TimeInterval): \(interval)")

        let time = Date(timeIntervalSinceNow: interval)
        //request.earliestBeginDate = time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("\(formatter.string(from: time))")
        print("StartscheduleBackgroundTask")
        do {
            try BGTaskScheduler.shared.submit(request)
            print("[LocationService] BG task submitted successfully")
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

    public func locationManager(_ mgr: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        //lastLocation = locs.last;
        print("locationManager")
        guard let loc = locs.last else { return }
        sendLocation(loc)
        currentBGTask?.setTaskCompleted(success: true)
        currentBGTask = nil

    }

   public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        currentBGTask?.setTaskCompleted(success: true)
        currentBGTask = nil
    }
    
    private func sendLocation(_ loc: CLLocation) {
        print("LocationService tick lat \(loc.coordinate.latitude)")
        print("LocationService tick lon \(loc.coordinate.longitude)")
        let storage =  ctx.locationStorage;
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
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: LocationService.taskIdentifier)
        return true;
        // if(isRunning){
        //     stop();
        //     return true;
        // }
        // return false;
    }
}

