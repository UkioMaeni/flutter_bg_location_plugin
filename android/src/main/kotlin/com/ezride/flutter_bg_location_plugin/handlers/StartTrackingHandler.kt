package com.ezride.flutter_bg_location_plugin.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ezride.flutter_bg_location_plugin.services.LocationService
import com.ezride.flutter_bg_location_plugin.service.LocationUpdatesService

class StartTrackingHandler : Handler{


    override val callMethod : String ="startTracking";

    override fun handle(context: Context, call: MethodCall, result: MethodChannel.Result){
        Log.d("FlutterLocationPlugin", "startTracking invoked")
        // Получаем параметр minute из аргументов. это время для сессии трекинга.
        val minute: Int = call.argument<Int>("minute") ?: 0
        LocationStorage(context).setTickerSeconds(minute)
        if (! LocationService.isServiceRunning(LocationUpdatesService::class.java,context)) {
            LocationService.startTracking();
            result.success(true)
        } else {
            Log.d("FlutterLocationPlugin", "Service already running")
            result.success(false)
        }
    }
}