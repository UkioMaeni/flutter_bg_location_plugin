package com.ezride.flutter_bg_location_plugin.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ezride.flutter_bg_location_plugin.services.LocationService

class LocationServiceStopHandler : Handler{

    override val callMethod : String = CallMethods.LOCATION_SERVICE_STOP;

    override fun handler(context: Context, call: MethodCall, result: MethodChannel.Result){
        Log.d("FlutterLocationPlugin", "stopTracking invoked");
        val isStoped =  LocationService.stopTracking(context);
        result.success(isStoped);
    }
}