package com.ezride.flutter_bg_location_plugin.services

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority 

class LocationUpdatesService : Service() {
    private lateinit var fusedClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private val channelId = "location_channel"
    private val notificationId = 1
    private val notificationManager: NotificationManager by lazy {
        getSystemService(NotificationManager::class.java)
    }

    override fun onCreate() {
        super.onCreate()
        fusedClient = LocationServices.getFusedLocationProviderClient(this)
        // fusedClient.lastLocation.addOnSuccessListener { loc ->
        //     if (loc != null){
        //         Log.d("LocationService", "LastLocation: $loc")
        //         HttpService.sendLocation(loc.latitude, loc.longitude,hash);
        //     }else{
        //         Log.d("LocationService", "LastLocation == null")
        //     } 
        // }
        val serviceContext = this;
        val locationStorage = LocationStorage(serviceContext);

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {

                val lastTickers =  locationStorage.getTickers();
                if(lastTickers<=0){
                    LocationService.stopTracking(serviceContext);
                    return;
                }
                val location = result.lastLocation ?: return
                Log.d("LocationService", "Lat: ${location.latitude}, Lng: ${location.longitude}");
                val hash = locationStorage.getHash()?:"";
                HttpService.sendLocation(location.latitude, location.longitude,hash);
                locationStorage.declineOneTickers();
                notificationManager.notify(notificationId, buildNotification(location));
                Intent().also { intent ->
                        intent.action = ACTION_LOCATION
                        intent.putExtra(EXTRA_LAT, location.latitude)
                        intent.putExtra(EXTRA_LNG, location.longitude)
                        sendBroadcast(intent)
                }
            }
        }

        createNotificationChannel()
        startForeground(notificationId, buildNotification(null))
        requestLocationUpdates()
    }

    private fun buildNotification(location: Location?): android.app.Notification {
        // Лаунч Intent главного Activity приложения
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName) ?: Intent()
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent.apply { addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP) },
            PendingIntent.FLAG_IMMUTABLE
        )

        val contentText = location?.let {
            "Lat: %.5f, Lng: %.5f".format(it.latitude, it.longitude)
        } ?: "Передача геолокации активна"

        return NotificationCompat.Builder(this, channelId)
            .setContentTitle("Location Tracker")
            .setContentText(contentText)
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setOngoing(true)
            .setAutoCancel(false)
            .setContentIntent(pendingIntent)
            .build()
    }
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        Log.d("LocationService", "onStartCommand() called")
        when (intent?.action) {
            ACTION_START -> {
                // мгновенная отправка из кэша
                fusedClient.lastLocation.addOnSuccessListener { loc ->
                    loc?.let {
                        val storage = LocationStorage(this)
                        val hash = storage.getHash() ?: ""
                        HttpService.sendLocation(it.latitude, it.longitude, hash)
                    }
                }
            }
            ACTION_STOP -> {
            }
            else -> {
                // при повторном onStartCommand без action можно ничего не делать
            }
        }
        return START_STICKY
    }
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Background Location",
                NotificationManager.IMPORTANCE_LOW
            )
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun requestLocationUpdates() {

        //Получаем интервал из локального хранилища (в секундах)
        val storage = LocationStorage(this);
        val tickerSeconds = storage.getTickerSeconds();
        val intervalMs = tickerSeconds * 1000L;

        val request = LocationRequest.create().apply {
            priority = LocationRequest.PRIORITY_HIGH_ACCURACY
            interval = intervalMs
        }
        fusedClient.requestLocationUpdates(request, locationCallback, mainLooper)
    }

    override fun onDestroy() {
        fusedClient.removeLocationUpdates(locationCallback)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        const val ACTION_LOCATION   = "com.ezride.flutter_location_plugin.services.ACTION_LOCATION"
        const val ACTION_START      = "com.ezride.flutter_location_plugin.services.ACTION_START"
        const val ACTION_STOP       = "com.ezride.flutter_location_plugin.services.ACTION_STOP"
        const val EXTRA_LAT         = "latitude"
        const val EXTRA_LNG         = "longitude"
    }
}