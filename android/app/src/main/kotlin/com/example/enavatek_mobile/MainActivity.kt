package com.example.enavatek_mobile

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourcompany.wifi/info"
    private val wifiManager by lazy { applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getWifiName") {
                result.success(getWifiName())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getWifiName(): String {
        if (Build.VERSION.SDK_INT >= VERSION_CODES.M) {
            if (checkSelfPermission(android.Manifest.permission.ACCESS_WIFI_STATE) == android.content.pm.PackageManager.PERMISSION_GRANTED) {
                val info: WifiInfo? = wifiManager.connectionInfo
                return info?.ssid?.trim('"') ?: "Not connected to WiFi"
            } else {
                requestPermissions(arrayOf(android.Manifest.permission.ACCESS_WIFI_STATE), 123)
                return "Permission denied"
            }
        } else {
            val info: WifiInfo? = wifiManager.connectionInfo
            return info?.ssid?.trim('"') ?: "Not connected to WiFi"
        }
    }
}
