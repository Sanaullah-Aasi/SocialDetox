package com.example.socialdetox

import android.app.Activity
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.VpnService
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.example.socialdetox/vpn"
        private const val VPN_REQUEST_CODE = 100
        private const val TAG = "MainActivity"
    }

    private var pendingResult: MethodChannel.Result? = null
    private var pendingAllowedPackages: ArrayList<String>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    getInstalledApps(result)
                }
                "startBlocking" -> {
                    val blockedPackages = call.argument<List<String>>("blockedPackages")
                    if (blockedPackages != null) {
                        startBlocking(ArrayList(blockedPackages), result)
                    } else {
                        result.error("INVALID_ARGS", "Blocked packages list is null", null)
                    }
                }
                "stopBlocking" -> {
                    stopBlocking(result)
                }
                "isVpnActive" -> {
                    result.success(isVpnServiceRunning())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getInstalledApps(result: MethodChannel.Result) {
        try {
            val packageManager = applicationContext.packageManager
            val installedApps = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
            
            val appsList = ArrayList<Map<String, Any?>>()
            
            for (appInfo in installedApps) {
                // Skip system apps that don't have a launch intent
                val launchIntent = packageManager.getLaunchIntentForPackage(appInfo.packageName)
                if (launchIntent == null) continue
                
                // Skip system apps (optional - keep only user apps)
                if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
                
                try {
                    val appName = packageManager.getApplicationLabel(appInfo).toString()
                    val packageName = appInfo.packageName
                    
                    // Get app icon as base64
                    val iconDrawable = packageManager.getApplicationIcon(appInfo)
                    val iconBytes = drawableToByteArray(iconDrawable)
                    
                    val appMap = HashMap<String, Any?>()
                    appMap["appName"] = appName
                    appMap["packageName"] = packageName
                    appMap["icon"] = iconBytes
                    
                    appsList.add(appMap)
                } catch (e: Exception) {
                    Log.w(TAG, "Error getting app info for ${appInfo.packageName}: ${e.message}")
                }
            }
            
            // Sort by app name
            appsList.sortBy { (it["appName"] as String).lowercase() }
            
            Log.d(TAG, "Found ${appsList.size} installed apps")
            result.success(appsList)
            
        } catch (e: Exception) {
            Log.e(TAG, "Error getting installed apps: ${e.message}", e)
            result.error("GET_APPS_ERROR", e.message, null)
        }
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val bitmap = if (drawable is BitmapDrawable) {
            drawable.bitmap
        } else {
            val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
            val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        }
        
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

    private fun startBlocking(blockedPackages: ArrayList<String>, result: MethodChannel.Result) {
        try {
            // Calculate allowed packages (all installed apps EXCEPT blocked ones)
            val allowedPackages = getAllowedPackages(blockedPackages)
            
            Log.d(TAG, "Blocked packages: ${blockedPackages.size}")
            Log.d(TAG, "Allowed packages: ${allowedPackages.size}")

            // Check VPN permission
            val prepareIntent = VpnService.prepare(applicationContext)

            if (prepareIntent == null) {
                // Permission already granted
                Log.i(TAG, "VPN permission already granted")
                startVpnService(allowedPackages)
                result.success(true)
            } else {
                // Need to request permission
                Log.i(TAG, "Requesting VPN permission")
                pendingResult = result
                pendingAllowedPackages = allowedPackages
                startActivityForResult(prepareIntent, VPN_REQUEST_CODE)
            }

        } catch (e: Exception) {
            Log.e(TAG, "Error starting blocking: ${e.message}", e)
            result.error("START_ERROR", e.message, null)
        }
    }

    private fun stopBlocking(result: MethodChannel.Result) {
        try {
            Log.i(TAG, "Stopping VPN blocking...")
            
            // Use the static method to stop the VPN service
            AppBlockingVpnService.stopVpnService(applicationContext)
            
            Log.i(TAG, "VPN stop command executed")
            result.success(true)

        } catch (e: Exception) {
            Log.e(TAG, "Error stopping blocking: ${e.message}", e)
            result.error("STOP_ERROR", e.message, null)
        }
    }

    private fun startVpnService(allowedPackages: ArrayList<String>) {
        val serviceIntent = Intent(this, AppBlockingVpnService::class.java).apply {
            action = AppBlockingVpnService.ACTION_START
            putStringArrayListExtra(AppBlockingVpnService.EXTRA_ALLOWED_PACKAGES, allowedPackages)
        }
        startService(serviceIntent)
    }

    private fun getAllowedPackages(blockedPackages: ArrayList<String>): ArrayList<String> {
        val packageManager = applicationContext.packageManager
        val installedApps = packageManager.getInstalledApplications(0)
        
        val allowedPackages = ArrayList<String>()
        
        for (appInfo in installedApps) {
            val packageName = appInfo.packageName
            
            // Skip blocked packages
            if (blockedPackages.contains(packageName)) {
                continue
            }
            
            // Add to allowed list
            allowedPackages.add(packageName)
        }
        
        return allowedPackages
    }

    private fun isVpnServiceRunning(): Boolean {
        return AppBlockingVpnService.isServiceRunning
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == VPN_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                // Permission granted
                Log.i(TAG, "VPN permission granted by user")
                
                pendingAllowedPackages?.let { allowedPackages ->
                    startVpnService(allowedPackages)
                    pendingResult?.success(true)
                }
                
            } else {
                // Permission denied
                Log.w(TAG, "VPN permission denied by user")
                pendingResult?.error(
                    "PERMISSION_DENIED",
                    "User denied VPN permission",
                    null
                )
            }

            // Clear pending state
            pendingResult = null
            pendingAllowedPackages = null
        }
    }
}
