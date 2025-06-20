package com.ezride.flutter_bg_location_plugin.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ezride.flutter_bg_location_plugin.services.LocationService
import com.ezride.flutter_bg_location_plugin.services.LocationUpdatesService

class LocationServiceStatusHandler : Handler{


    override val callMethod : String = CallMethods.LOCATION_SERVICE_STATUS;

    override fun handler(context: Context, call: MethodCall, result: MethodChannel.Result){
        val isStarted =  LocationService.isServiceRunning(LocationUpdatesService::class.java,context);
        result.success(isStarted);
    }
}