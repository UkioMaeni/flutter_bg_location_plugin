package com.ezride.flutter_bg_location_plugin.services

import android.content.Context
import android.util.Log
import android.app.ActivityManager

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

    fun startTracking(context: Context,seconds: Int){

        val locationStorage =  LocationStorage(context);
        val tickerSeconds =  locationStorage.getTickerSeconds(seconds);
        val tickerCount = seconds/tickerSeconds;
        locationStorage.setTickers(tickerCount);
        
        val serviceIntent = Intent(context, LocationUpdatesService::class.java)
        context.startForegroundService(serviceIntent)
    }
}