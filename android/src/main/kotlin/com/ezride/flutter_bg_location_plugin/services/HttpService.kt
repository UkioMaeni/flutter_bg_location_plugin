package com.ezride.flutter_bg_location_plugin.services

import android.util.Log
import okhttp3.*
import org.json.JSONObject
import java.io.IOException
import okhttp3.MediaType.Companion.toMediaType
object HttpService {
    private val client = OkHttpClient()
    private const val BASE_URL = "https://your.api.endpoint/locations"

    fun sendLocation(lat: Double, lng: Double, hash: String) {


        val json = JSONObject().apply {
            put("latitude", lat)
            put("longitude", lng)
            put("hash", hash)
        }
        val mediaType = "application/json; charset=utf-8".toMediaType()
        val body = RequestBody.create(mediaType, json.toString())
        val request = Request.Builder()
            .url(BASE_URL)
            .post(body)
            .build()
        client.newCall(request).enqueue(object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("HttpService", "Failed to send location", e)
            }

            override fun onResponse(call: Call, response: Response) {
                Log.d("HttpService", "Location sent, response code: ${response.code}")
                response.close()
            }
        })
    }
}