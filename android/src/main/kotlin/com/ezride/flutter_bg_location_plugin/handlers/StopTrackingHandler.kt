package com.ezride.flutter_bg_location_plugin.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ezride.flutter_bg_location_plugin.services.LocationService
import com.ezride.flutter_bg_location_plugin.service.LocationUpdatesService

class StopTrackingHandler : Handler{

    override val callMethod : String ="stopTracking";

    override fun handle(context: Context, call: MethodCall, result: MethodChannel.Result){
        Log.d("FlutterLocationPlugin", "stopTracking invoked")
        if (LocationUpdatesService(LocationUpdatesService::class.java)) {
            val serviceIntent = Intent(context, LocationUpdatesService::class.java)
            context.stopService(serviceIntent)
            result.success(true)
        } else {
            Log.d("FlutterLocationPlugin", "Service not running")
            result.success(false)
        }
        
    }
}