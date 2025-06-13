package com.ezride.flutter_bg_location_plugin.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import com.google.android.gms.location.LocationResult

class LocationBroadcastReceiver private constructor() {
    private var listener: ((LocationData) -> Unit)? = null

    fun register(context: Context, callback: (LocationData) -> Unit) {
        listener = callback
        context.registerReceiver(receiver, IntentFilter(LocationUpdatesService.ACTION_LOCATION))
    }

    fun unregister(context: Context) {
        context.unregisterReceiver(receiver)
    }

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val lat = intent.getDoubleExtra(LocationUpdatesService.EXTRA_LAT, 0.0)
            val lng = intent.getDoubleExtra(LocationUpdatesService.EXTRA_LNG, 0.0)
            listener?.invoke(LocationData(lat, lng))
        }
    }

    data class LocationData(val latitude: Double, val longitude: Double)

    companion object {
        private val instance = LocationBroadcastReceiver()
        fun register(context: Context, callback: (LocationData) -> Unit) = instance.register(context, callback)
        fun unregister(context: Context) = instance.unregister(context)
    }
}