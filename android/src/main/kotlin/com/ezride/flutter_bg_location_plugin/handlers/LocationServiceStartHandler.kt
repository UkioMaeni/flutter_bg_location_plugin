package com.ezride.flutter_bg_location_plugin.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ezride.flutter_bg_location_plugin.services.LocationService

class LocationServiceStartHandler : Handler{


    override val callMethod : String = CallMethods.LOCATION_SERVICE_START;

    override fun handler(context: Context, call: MethodCall, result: MethodChannel.Result){
        Log.d("FlutterLocationPlugin", "startTracking invoked")
        // Получаем параметр seconds и hash из аргументов. это время для сессии трекинга.
        val args = call.arguments as? Map<*, *>
        val seconds = (args?.get("seconds") as? Int) ?: 0;
        val hash = (args?.get("hash") as? String) ?: "";
        val orderId = (args?.get("orderId") as? Int) ?: 0;
        val isStarted =  LocationService.startTracking(context,seconds,hash,orderId);
        result.success(isStarted);

    }
}