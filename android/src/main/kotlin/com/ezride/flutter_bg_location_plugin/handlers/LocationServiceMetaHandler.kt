package com.ezride.flutter_bg_location_plugin.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.util.Log
import com.ezride.flutter_bg_location_plugin.services.LocationService
import com.ezride.flutter_bg_location_plugin.models.LocationServiceMeta

class LocationServiceMetaHandler : Handler{


    override val callMethod : String = CallMethods.LOCATION_SERVICE_META;

    override fun handler(context: Context, call: MethodCall, result: MethodChannel.Result){
        val meta :LocationServiceMeta = LocationService.getMeta(context)
        val map = mapOf(
            "tickerSeconds" to meta.tickerSeconds,
            "tickersCount"   to meta.tickersCount,
            "hash"          to meta.hash,
            "orderId"       to meta.orderId
        )
        result.success(map)
    }
}