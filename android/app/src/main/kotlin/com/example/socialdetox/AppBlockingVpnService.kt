package com.example.socialdetox

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.ByteBuffer

class AppBlockingVpnService : VpnService() {

    companion object {
        private const val TAG = "AppBlockingVpnService"
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "socialdetox_vpn_channel"
        const val EXTRA_ALLOWED_PACKAGES = "allowed_packages"
        const val ACTION_START = "com.example.socialdetox.START"
        const val ACTION_STOP = "com.example.socialdetox.STOP"
        
        // Static variable to track service running state
        @Volatile
        var isServiceRunning = false
            private set
        
        // Static reference to the service instance for stopping
        private var instance: AppBlockingVpnService? = null
        
        // Static method to stop the VPN service
        fun stopVpnService(context: Context) {
            Log.i(TAG, "Static stopVpnService called")
            instance?.let {
                it.stopVpn()
                it.stopSelf()
            }
            // Also try to stop the service via context
            val stopIntent = Intent(context, AppBlockingVpnService::class.java)
            context.stopService(stopIntent)
        }
    }

    private var vpnInterface: ParcelFileDescriptor? = null
    private var vpnThread: Thread? = null
    @Volatile
    private var isRunning = false

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.i(TAG, "Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i(TAG, "onStartCommand received with action: ${intent?.action}")
        
        when (intent?.action) {
            ACTION_START -> {
                val allowedPackages = intent.getStringArrayListExtra(EXTRA_ALLOWED_PACKAGES)
                if (allowedPackages != null) {
                    startVpn(allowedPackages)
                } else {
                    Log.e(TAG, "No allowed packages provided")
                    stopSelf()
                }
            }
            ACTION_STOP -> {
                Log.i(TAG, "ACTION_STOP received - stopping VPN")
                stopVpn()
                stopSelf()
            }
            null -> {
                // Service restarted by system or null intent
                Log.w(TAG, "Null intent received - stopping service")
                stopVpn()
                stopSelf()
            }
            else -> {
                Log.w(TAG, "Unknown action: ${intent.action}")
            }
        }
        return START_NOT_STICKY // Don't restart if killed
    }

    private fun startVpn(allowedPackages: ArrayList<String>) {
        try {
            // Start as foreground service with notification
            startForeground(NOTIFICATION_ID, createNotification())

            // Build VPN interface
            val builder = Builder()
            
            // Set session name
            builder.setSession("SocialDetox")
            
            // Configure VPN network parameters
            builder.addAddress("10.0.0.2", 32)  // Local VPN IP
            builder.addRoute("0.0.0.0", 0)      // Route all traffic
            builder.addDnsServer("8.8.8.8")     // Google DNS
            builder.addDnsServer("8.8.4.4")     // Google DNS backup
            builder.setMtu(1500)                // Standard MTU
            
            // Allow our own app to bypass VPN (critical!)
            try {
                builder.addDisallowedApplication(packageName)
            } catch (e: PackageManager.NameNotFoundException) {
                Log.e(TAG, "Own package not found: ${e.message}")
            }
            
            // Allow all apps in the allowedPackages list to bypass VPN
            // These apps will keep working normally
            for (pkg in allowedPackages) {
                try {
                    builder.addDisallowedApplication(pkg)
                    Log.d(TAG, "Allowed (bypass): $pkg")
                } catch (e: PackageManager.NameNotFoundException) {
                    Log.w(TAG, "Package not found: $pkg")
                }
            }
            
            // Establish VPN interface
            vpnInterface = builder.establish()
            
            if (vpnInterface == null) {
                Log.e(TAG, "Failed to establish VPN interface")
                stopSelf()
                return
            }
            
            Log.i(TAG, "VPN interface established successfully")
            isRunning = true
            isServiceRunning = true
            
            // Start packet handling thread
            startPacketLoop()
            
        } catch (e: Exception) {
            Log.e(TAG, "Error starting VPN: ${e.message}", e)
            stopSelf()
        }
    }

    private fun startPacketLoop() {
        vpnThread = Thread {
            try {
                val vpnInput = FileInputStream(vpnInterface?.fileDescriptor)
                val vpnOutput = FileOutputStream(vpnInterface?.fileDescriptor)
                val buffer = ByteBuffer.allocate(32767)
                
                Log.i(TAG, "Packet loop started - dropping all packets from blocked apps")
                
                while (isRunning) {
                    try {
                        // Read packets from VPN interface
                        val length = vpnInput.read(buffer.array())
                        
                        if (length > 0) {
                            // We intentionally DO NOTHING with the packet
                            // This drops the packet, effectively blocking the connection
                            // Blocked apps send data here, but it goes nowhere
                            
                            // Optional: Log for debugging (disable in production)
                            // Log.d(TAG, "Dropped packet: $length bytes")
                        }
                        
                        buffer.clear()
                        
                    } catch (e: Exception) {
                        if (isRunning) {
                            Log.e(TAG, "Error in packet loop: ${e.message}")
                        }
                        break
                    }
                }
                
                Log.i(TAG, "Packet loop stopped")
                
            } catch (e: Exception) {
                Log.e(TAG, "Packet loop error: ${e.message}", e)
            }
        }.apply {
            name = "VPN-PacketLoop"
            start()
        }
    }

    private fun stopVpn() {
        Log.i(TAG, "Stopping VPN service")
        
        isRunning = false
        isServiceRunning = false
        
        // Stop the packet loop thread
        try {
            vpnThread?.interrupt()
            vpnThread?.join(2000)
            vpnThread = null
        } catch (e: InterruptedException) {
            Log.w(TAG, "Thread interruption: ${e.message}")
        }
        
        // Close VPN interface
        try {
            vpnInterface?.close()
            vpnInterface = null
            Log.i(TAG, "VPN interface closed")
        } catch (e: Exception) {
            Log.e(TAG, "Error closing VPN interface: ${e.message}")
        }
        
        // Stop foreground notification
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_REMOVE)
            } else {
                @Suppress("DEPRECATION")
                stopForeground(true)
            }
            Log.i(TAG, "Foreground stopped")
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping foreground: ${e.message}")
        }
    }

    private fun createNotification(): Notification {
        createNotificationChannel()

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("SocialDetox Active")
            .setContentText("Blocking selected apps from internet access")
            .setSmallIcon(android.R.drawable.ic_lock_idle_lock)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "SocialDetox VPN Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Notification for active app blocking"
                setShowBadge(false)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager?.createNotificationChannel(channel)
        }
    }

    override fun onDestroy() {
        Log.i(TAG, "Service onDestroy called")
        stopVpn()
        instance = null
        super.onDestroy()
    }

    override fun onRevoke() {
        Log.w(TAG, "VPN permission revoked by user")
        stopVpn()
        stopSelf()
        super.onRevoke()
    }
}
