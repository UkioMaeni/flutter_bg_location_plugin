package com.ezride.flutter_bg_location_plugin.services

import android.content.Context
import android.util.Log
import android.app.ActivityManager
import android.content.Intent

object LocationService{
    fun isServiceRunning(serviceClass: Class<*>,context: Context): Boolean {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return true
            }
        }
        return false
    }

    fun startTracking(context: Context,seconds: Int,hash: String): Boolean{
        if(isServiceRunning(LocationUpdatesService::class.java,context)){
            Log.d("FlutterLocationPlugin", "Service already running");
            return false;
        }
        val locationStorage =  LocationStorage(context);
        val tickerSeconds =  locationStorage.getTickerSeconds();
        val tickerCount = seconds/tickerSeconds;
        locationStorage.setTickers(tickerCount);
        locationStorage.setHash(hash);
        val serviceIntent = Intent(context, LocationUpdatesService::class.java)
        context.startForegroundService(serviceIntent)

        return true;
    }

    fun stopTracking(context: Context): Boolean{
        if(isServiceRunning(LocationUpdatesService::class.java,context)){
        
            val serviceIntent = Intent(context, LocationUpdatesService::class.java);
            context.stopService(serviceIntent);

            val locationStorage =  LocationStorage(context);
            locationStorage.setTickers(0);

            return true;
        }
        Log.d("FlutterLocationPlugin", "Service not running");

        return false;
    }
}