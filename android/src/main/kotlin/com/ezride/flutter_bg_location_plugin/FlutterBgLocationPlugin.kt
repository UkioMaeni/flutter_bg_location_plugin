package com.ezride.flutter_bg_location_plugin

import androidx.annotation.NonNull
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import com.google.android.gms.location.LocationResult
import android.util.Log
import android.app.ActivityManager
import com.ezride.flutter_bg_location_plugin.handlers.*
import com.ezride.flutter_bg_location_plugin.services.LocationBroadcastReceiver


/** FlutterBgLocationPlugin */

class FlutterBgLocationPlugin: FlutterPlugin, MethodChannel.MethodCallHandler{
    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel

    


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext;
        methodChannel = MethodChannel(binding.binaryMessenger, "flutter_bg_location_plugin")
        methodChannel.setMethodCallHandler(this)
        LocationBroadcastReceiver.register(context) { _ ->
            Log.d("location","POOL")
        }
        
    }

    private val handlers: List<Handler> = listOf(
        LocationServiceStartHandler(),
        LocationServiceStopHandler(),
        LocationServiceStatusHandler(),
        LocationServiceMetaHandler()
    )

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        handlers.find { it.callMethod == call.method }
            ?.handler(context, call, result)
            ?: result.notImplemented()

        // when (call.method) {
        //     "startTracking" -> {
        //         Log.d("FlutterLocationPlugin", "startTracking invoked")
        //         if (!isServiceRunning(LocationUpdatesService::class.java)) {
        //             val serviceIntent = Intent(context, LocationUpdatesService::class.java)
        //             context.startForegroundService(serviceIntent)
        //         } else {
        //             Log.d("FlutterLocationPlugin", "Service already running")
        //         }
        //         result.success(null)
        //     }
        //     "stopTracking" -> {
        //         Log.d("FlutterLocationPlugin", "stopTracking invoked")
        //         if (isServiceRunning(LocationUpdatesService::class.java)) {
        //             val serviceIntent = Intent(context, LocationUpdatesService::class.java)
        //             context.stopService(serviceIntent)
        //         } else {
        //             Log.d("FlutterLocationPlugin", "Service not running")
        //         }
        //         result.success(null)
        //     }
        //     else -> result.notImplemented()
        // }
    }



    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return true
            }
        }
        return false
    }
}