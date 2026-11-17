#!/usr/bin/env bash
set -e

mkdir -p app/src/main/java/com/example/lancast
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/mipmap-anydpi-v26
mkdir -p app/src/main/res/values

mkdir -p tv/src/main/java/com/example/lancasttv
mkdir -p tv/src/main/res/drawable
mkdir -p tv/src/main/res/mipmap-anydpi-v26
mkdir -p tv/src/main/res/values
mkdir -p tv/src/main/res/xml

mkdir -p gradle/wrapper

# ==================== GRADLE BASE CONFIG ====================
cat << 'EOF' > gradle.properties
android.useAndroidX=true
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
EOF

cat << 'EOF' > settings.gradle.kts
pluginManagement {
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories { google(); mavenCentral() }
}
rootProject.name = "VDOCastSuite"
include(":app", ":tv")
EOF

cat << 'EOF' > build.gradle.kts
plugins {
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}
EOF

# ==================== 1. PHONE SENDER & REMOTE MODULE (:app) ====================
cat << 'EOF' > app/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.lancast"
    compileSdk = 34
    defaultConfig {
        applicationId = "com.example.lancast"
        minSdk = 24
        targetSdk = 34
        versionCode = 2
        versionName = "2.0"
    }
    signingConfigs {
        create("release") {
            storeFile = rootProject.file("release.keystore")
            storePassword = "vdocast"
            keyAlias = "vdocast"
            keyPassword = "vdocast"
        }
    }
    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
    buildFeatures { compose = true }
    composeOptions { kotlinCompilerExtensionVersion = "1.5.14" }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
}

dependencies {
    implementation("org.nanohttpd:nanohttpd:2.3.1")
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.activity:activity-compose:1.9.2")
    implementation(platform("androidx.compose:compose-bom:2024.09.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.media:media:1.7.0")
}
EOF

# App Strings
cat << 'EOF' > app/src/main/res/values/strings.xml
<resources>
    <string name="app_name">VDO Remote</string>
</resources>
EOF

# Modern Professional App Vector Icons (VDO Remote)
cat << 'EOF' > app/src/main/res/drawable/ic_launcher_background.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#060913"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#0E1626"
        android:pathData="M54,54m-46,0a46,46 0,1 1,92 0a46,46 0,1 1,-92 0" />
    <path
        android:fillColor="#152037"
        android:pathData="M54,54m-32,0a32,32 0,1 1,64 0a32,32 0,1 1,-64 0" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher_foreground.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <!-- Outer Signal Waves -->
    <path
        android:strokeColor="#818CF8"
        android:strokeWidth="3"
        android:strokeLineCap="round"
        android:pathData="M81,38 a26,26 0 0,1 0,32" />
    <path
        android:strokeColor="#00E5FF"
        android:strokeWidth="3.2"
        android:strokeLineCap="round"
        android:pathData="M75,44 a18,18 0 0,1 0,20" />
    <path
        android:strokeColor="#818CF8"
        android:strokeWidth="3"
        android:strokeLineCap="round"
        android:pathData="M27,38 a26,26 0 0,0 0,32" />
    <path
        android:strokeColor="#00E5FF"
        android:strokeWidth="3.2"
        android:strokeLineCap="round"
        android:pathData="M33,44 a18,18 0 0,0 0,20" />

    <!-- Sleek Remote Contour Body -->
    <path
        android:fillColor="#00E5FF"
        android:pathData="M43,26 h22 c3.3,0 6,2.7 6,6 v44 c0,3.3 -2.7,6 -6,6 h-22 c-3.3,0 -6,-2.7 -6,-6 v-44 c0,-3.3 2.7,-6 6,-6 z" />

    <!-- Inset Display Screen -->
    <path
        android:fillColor="#060913"
        android:pathData="M41,33 h26 v28 h-26 z" />

    <!-- Sharp Play Emblem -->
    <path
        android:fillColor="#00E5FF"
        android:pathData="M50,42 l12,5 -12,5 z" />

    <!-- Remote Navigation Circle -->
    <path
        android:fillColor="#060913"
        android:pathData="M54,69 m-3.5,0 a3.5,3.5 0 1,0 7,0 a3.5,3.5 0 1,0 -7,0" />
    <path
        android:fillColor="#060913"
        android:pathData="M45,69 m-1.8,0 a1.8,1.8 0 1,0 3.6,0 a1.8,1.8 0 1,0 -3.6,0" />
    <path
        android:fillColor="#060913"
        android:pathData="M63,69 m-1.8,0 a1.8,1.8 0 1,0 3.6,0 a1.8,1.8 0 1,0 -3.6,0" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#060913"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#0E1626"
        android:pathData="M54,54m-44,0a44,44 0,1 1,88 0a44,44 0,1 1,-88 0" />
    <path
        android:fillColor="#00E5FF"
        android:pathData="M43,26 h22 c3.3,0 6,2.7 6,6 v44 c0,3.3 -2.7,6 -6,6 h-22 c-3.3,0 -6,-2.7 -6,-6 v-44 c0,-3.3 2.7,-6 6,-6 z" />
    <path
        android:fillColor="#060913"
        android:pathData="M41,33 h26 v28 h-26 z" />
    <path
        android:fillColor="#00E5FF"
        android:pathData="M50,42 l12,5 -12,5 z" />
    <path
        android:strokeColor="#818CF8"
        android:strokeWidth="3.2"
        android:strokeLineCap="round"
        android:pathData="M76,43 a18,18 0 0,1 0,22" />
    <path
        android:strokeColor="#00E5FF"
        android:strokeWidth="3.2"
        android:strokeLineCap="round"
        android:pathData="M83,37 a26,26 0 0,1 0,34" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

cat << 'EOF' > app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

cat << 'EOF' > app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:usesCleartextTraffic="true"
        android:theme="@android:style/Theme.Material.NoActionBar">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:configChanges="orientation|screenSize|screenLayout">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="video/*" />
            </intent-filter>
        </activity>
        <service
            android:name=".CastServerService"
            android:exported="false"
            android:foregroundServiceType="mediaPlayback" />
    </application>
</manifest>
EOF

cat << 'EOF' > app/src/main/java/com/example/lancast/CastServerService.kt
package com.example.lancast

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.os.IBinder
import android.os.ParcelFileDescriptor
import android.os.PowerManager
import android.provider.OpenableColumns
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.core.app.NotificationCompat
import fi.iki.elonen.NanoHTTPD
import org.json.JSONObject
import java.util.concurrent.atomic.AtomicInteger

data class TvPlaybackState(
    val status: String = "idle",
    val currentTime: Double = 0.0,
    val duration: Double = 0.0,
    val volume: Float = 1.0f,
    val muted: Boolean = false,
    val playbackRate: Float = 1.0f,
    val aspectRatio: String = "contain",
    val title: String = ""
)

class CastServerService : Service() {

    companion object {
        var currentVideoUri: Uri? = null
        var currentVideoTitle: String = ""
        var lastCommand: String = ""
        var lastValue: Double = 0.0
        var lastStrVal: String = ""
        val seq = AtomicInteger(0)

        // Reactive Compose State for real-time TV telemetry
        var tvStatus by mutableStateOf(TvPlaybackState())

        fun pushCommand(cmd: String, value: Double = 0.0, strVal: String = "") {
            lastCommand = cmd
            lastValue = value
            lastStrVal = strVal
            seq.incrementAndGet()
        }
    }

    private var server: VideoHttpServer? = null
    private var nsdManager: NsdManager? = null
    private var registrationListener: NsdManager.RegistrationListener? = null
    private var multicastLock: WifiManager.MulticastLock? = null
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onCreate() {
        super.onCreate()
        acquireLocks()
        updateForegroundNotification("VDO Remote Active", false)
        server = VideoHttpServer(5050).apply { start(NanoHTTPD.SOCKET_READ_TIMEOUT, false) }
        registerNsdService(5050)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        intent?.data?.let { uri ->
            currentVideoUri = uri
        }
        when (intent?.action) {
            "ACTION_TOGGLE" -> pushCommand("toggle")
            "ACTION_REWIND" -> pushCommand("seekRelative", -15.0)
            "ACTION_FF" -> pushCommand("seekRelative", 15.0)
            "ACTION_STOP" -> pushCommand("stop")
        }
        return START_STICKY
    }

    override fun onDestroy() {
        try { registrationListener?.let { nsdManager?.unregisterService(it) } } catch (_: Exception) {}
        server?.stop()
        releaseLocks()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun acquireLocks() {
        try {
            val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
            multicastLock = wifiManager?.createMulticastLock("vdocast_multicast_lock")?.apply {
                setReferenceCounted(true)
                acquire()
            }
            val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
            wakeLock = powerManager?.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "vdocast:wakelock")?.apply {
                acquire(24 * 60 * 60 * 1000L)
            }
        } catch (_: Exception) {}
    }

    private fun releaseLocks() {
        try { if (multicastLock?.isHeld == true) multicastLock?.release() } catch (_: Exception) {}
        try { if (wakeLock?.isHeld == true) wakeLock?.release() } catch (_: Exception) {}
    }

    private fun registerNsdService(port: Int) {
        val serviceInfo = NsdServiceInfo().apply {
            serviceName = "VDOCastPhone"
            serviceType = "_vdocast._tcp."
            setPort(port)
        }
        nsdManager = getSystemService(Context.NSD_SERVICE) as NsdManager
        registrationListener = object : NsdManager.RegistrationListener {
            override fun onServiceRegistered(info: NsdServiceInfo) {}
            override fun onRegistrationFailed(info: NsdServiceInfo, errorCode: Int) {}
            override fun onServiceUnregistered(info: NsdServiceInfo) {}
            override fun onUnregistrationFailed(info: NsdServiceInfo, errorCode: Int) {}
        }
        nsdManager?.registerService(serviceInfo, NsdManager.PROTOCOL_DNS_SD, registrationListener)
    }

    fun updateForegroundNotification(title: String, isPlaying: Boolean) {
        val channelId = "vdocast_server"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, "VDO Remote Streaming", NotificationManager.IMPORTANCE_LOW)
            getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
        }

        val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE else PendingIntent.FLAG_UPDATE_CURRENT

        val toggleIntent = Intent(this, CastServerService::class.java).apply { action = "ACTION_TOGGLE" }
        val togglePending = PendingIntent.getService(this, 1, toggleIntent, flag)

        val rewIntent = Intent(this, CastServerService::class.java).apply { action = "ACTION_REWIND" }
        val rewPending = PendingIntent.getService(this, 2, rewIntent, flag)

        val ffIntent = Intent(this, CastServerService::class.java).apply { action = "ACTION_FF" }
        val ffPending = PendingIntent.getService(this, 3, ffIntent, flag)

        val stopIntent = Intent(this, CastServerService::class.java).apply { action = "ACTION_STOP" }
        val stopPending = PendingIntent.getService(this, 4, stopIntent, flag)

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle(if (title.isNotEmpty()) title else "VDO Remote Active")
            .setContentText("Broadcasting to VDO TV on Wi-Fi (Port 5050)")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .addAction(android.R.drawable.ic_media_rew, "-15s", rewPending)
            .addAction(if (isPlaying) android.R.drawable.ic_media_pause else android.R.drawable.ic_media_play, if (isPlaying) "Pause" else "Play", togglePending)
            .addAction(android.R.drawable.ic_media_ff, "+15s", ffPending)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Stop", stopPending)
            .setOngoing(isPlaying)
            .build()

        startForeground(101, notification)
    }

    inner class VideoHttpServer(port: Int) : NanoHTTPD(port) {
        override fun serve(session: IHTTPSession): Response {
            return when (session.uri) {
                "/", "/tv" -> newFixedLengthResponse(Response.Status.OK, "text/html", TV_HTML)
                "/api/state" -> {
                    val json = JSONObject().apply {
                        put("seq", seq.get())
                        put("cmd", lastCommand)
                        put("val", lastValue)
                        put("strVal", lastStrVal)
                    }
                    newFixedLengthResponse(Response.Status.OK, "application/json", json.toString())
                }
                "/api/status" -> {
                    if (session.method == Method.POST) {
                        val files = HashMap<String, String>()
                        try {
                            session.parseBody(files)
                            val postData = files["postData"]
                            if (!postData.isNullOrBlank()) parseAndApplyStatus(postData)
                        } catch (_: Exception) {}
                    } else {
                        val s = session.parms["s"]
                        if (!s.isNullOrBlank()) parseAndApplyStatus(s)
                    }
                    newFixedLengthResponse(Response.Status.OK, "application/json", "{\"ok\":true}")
                }
                "/stream" -> streamCurrentVideo(session)
                else -> newFixedLengthResponse(Response.Status.NOT_FOUND, "text/plain", "Not Found")
            }
        }

        private fun parseAndApplyStatus(rawJson: String) {
            try {
                val json = JSONObject(rawJson)
                val state = TvPlaybackState(
                    status = json.optString("status", "idle"),
                    currentTime = json.optDouble("currentTime", 0.0),
                    duration = json.optDouble("duration", 0.0),
                    volume = json.optDouble("volume", 1.0).toFloat(),
                    muted = json.optBoolean("muted", false),
                    playbackRate = json.optDouble("playbackRate", 1.0).toFloat(),
                    aspectRatio = json.optString("aspectRatio", "contain"),
                    title = json.optString("title", "")
                )
                tvStatus = state
                updateForegroundNotification(
                    if (state.title.isNotEmpty()) state.title else currentVideoTitle,
                    state.status == "playing"
                )
            } catch (_: Exception) {}
        }

        private fun streamCurrentVideo(session: IHTTPSession): Response {
            val uri = currentVideoUri ?: return newFixedLengthResponse(Response.Status.NOT_FOUND, "text/plain", "No video selected")

            var mime = contentResolver.getType(uri)
            if (mime.isNullOrBlank() || mime == "video/*" || mime == "application/octet-stream") {
                val ext = uri.path?.substringAfterLast('.', "")?.lowercase()
                mime = when (ext) {
                    "mp4", "m4v" -> "video/mp4"
                    "mkv" -> "video/x-matroska"
                    "webm" -> "video/webm"
                    "mov" -> "video/quicktime"
                    "avi" -> "video/x-msvideo"
                    "ts" -> "video/mp2t"
                    else -> "video/mp4"
                }
            }

            val pfd = try {
                contentResolver.openFileDescriptor(uri, "r")
            } catch (e: Exception) {
                null
            } ?: return newFixedLengthResponse(Response.Status.INTERNAL_ERROR, "text/plain", "Cannot open video file")

            var fileSize = pfd.statSize
            if (fileSize <= 0) {
                try {
                    contentResolver.query(uri, arrayOf(OpenableColumns.SIZE), null, null, null)?.use { cursor ->
                        if (cursor.moveToFirst()) {
                            val sizeIdx = cursor.getColumnIndex(OpenableColumns.SIZE)
                            if (sizeIdx != -1) fileSize = cursor.getLong(sizeIdx)
                        }
                    }
                } catch (_: Exception) {}
            }

            val rangeHeader = session.headers["range"]

            return if (rangeHeader != null && rangeHeader.startsWith("bytes=")) {
                val parts = rangeHeader.removePrefix("bytes=").split("-")
                val start = parts[0].toLongOrNull() ?: 0L
                val end = if (parts.size > 1 && parts[1].isNotEmpty()) parts[1].toLong() else (if (fileSize > 0) fileSize - 1 else start + 1024 * 1024)
                val length = (end - start) + 1
                val fis = ParcelFileDescriptor.AutoCloseInputStream(pfd)
                try {
                    fis.channel.position(start)
                } catch (_: Exception) {
                    try { fis.skip(start) } catch (_: Exception) {}
                }
                newFixedLengthResponse(Response.Status.PARTIAL_CONTENT, mime, fis, length).apply {
                    addHeader("Accept-Ranges", "bytes")
                    addHeader("Content-Range", "bytes $start-$end/${if (fileSize > 0) fileSize.toString() else "*"}")
                }
            } else {
                val fis = ParcelFileDescriptor.AutoCloseInputStream(pfd)
                newFixedLengthResponse(Response.Status.OK, mime, fis, if (fileSize > 0) fileSize else -1).apply {
                    addHeader("Accept-Ranges", "bytes")
                }
            }
        }
    }

    private val TV_HTML = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VDO TV</title>
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; -webkit-user-select: none; user-select: none; }
          body { background: #000; color: #fff; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; width: 100vw; height: 100vh; overflow: hidden; display: flex; align-items: center; justify-content: center; }

          /* Ambient Standby Mode */
          #ambient {
            position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: center;
            background: radial-gradient(circle at 50% 38%, #111e38 0%, #060a14 60%, #020409 100%);
            z-index: 10; transition: opacity 0.4s ease;
          }
          .brand-logo { display: flex; align-items: center; gap: 16px; margin-bottom: 24px; }
          .logo-icon { width: 62px; height: 62px; border-radius: 18px; background: linear-gradient(135deg, #00e5ff, #3b82f6); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 35px rgba(0, 229, 255, 0.45); }
          .logo-icon svg { width: 36px; height: 36px; fill: #fff; }
          .brand-title { font-size: 46px; font-weight: 900; letter-spacing: -1.5px; background: linear-gradient(90deg, #00e5ff, #60a5fa, #c084fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
          .clock { font-size: 80px; font-weight: 200; letter-spacing: 2px; color: #f8fafc; text-shadow: 0 2px 14px rgba(0,0,0,0.6); margin-bottom: 6px; }
          .date { font-size: 20px; color: #94a3b8; margin-bottom: 36px; text-transform: uppercase; letter-spacing: 1.5px; }

          .status-card {
            background: rgba(15, 23, 42, 0.78); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.12);
            padding: 18px 32px; border-radius: 22px; display: flex; align-items: center; gap: 16px; box-shadow: 0 10px 36px rgba(0,0,0,0.55);
          }
          .pulse-dot { width: 12px; height: 12px; border-radius: 50%; background: #22c55e; box-shadow: 0 0 14px #22c55e; animation: pulse 2s infinite; }
          @keyframes pulse { 0% { opacity: 0.4; transform: scale(0.9); } 50% { opacity: 1; transform: scale(1.1); } 100% { opacity: 0.4; transform: scale(0.9); } }
          .status-text { font-size: 18px; font-weight: 600; color: #f1f5f9; }
          .status-sub { font-size: 14px; color: #94a3b8; }
          .ip-badge { background: rgba(0, 229, 255, 0.2); color: #00e5ff; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-family: monospace; }

          /* Video Player */
          video {
            position: absolute; inset: 0; width: 100vw; height: 100vh; object-fit: contain; background: #000; display: none; z-index: 5;
          }

          /* Cinematic On-Screen Display (OSD) */
          #osd {
            position: absolute; inset: 0; z-index: 20; pointer-events: none; display: flex; flex-direction: column; justify-content: space-between;
            padding: 40px 60px; background: linear-gradient(180deg, rgba(0,0,0,0.8) 0%, transparent 22%, transparent 75%, rgba(0,0,0,0.92) 100%);
            opacity: 0; transition: opacity 0.35s ease;
          }
          #osd.visible { opacity: 1; }

          .osd-top { display: flex; align-items: center; justify-content: space-between; }
          .video-title { font-size: 28px; font-weight: 700; color: #fff; text-shadow: 0 2px 8px rgba(0,0,0,0.8); max-width: 70vw; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
          .osd-badges { display: flex; gap: 12px; }
          .badge { background: rgba(255, 255, 255, 0.16); backdrop-filter: blur(8px); padding: 6px 14px; border-radius: 8px; font-size: 14px; font-weight: 600; text-transform: uppercase; }

          .osd-bottom { display: flex; flex-direction: column; gap: 12px; }
          .progress-bar-container { position: relative; width: 100%; height: 8px; background: rgba(255, 255, 255, 0.22); border-radius: 4px; overflow: hidden; }
          .buffer-bar { position: absolute; top: 0; left: 0; height: 100%; background: rgba(255, 255, 255, 0.35); width: 0%; border-radius: 4px; }
          .progress-bar { position: absolute; top: 0; left: 0; height: 100%; background: linear-gradient(90deg, #00e5ff, #38bdf8); width: 0%; border-radius: 4px; box-shadow: 0 0 10px #00e5ff; }
          .time-row { display: flex; justify-content: space-between; font-size: 18px; font-weight: 500; color: #cbd5e1; text-shadow: 0 1px 4px rgba(0,0,0,0.8); }

          /* HUD Center Alert Toast */
          #hud {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) scale(0.9);
            background: rgba(11, 15, 25, 0.92); backdrop-filter: blur(18px); border: 1px solid rgba(255, 255, 255, 0.16);
            padding: 18px 36px; border-radius: 24px; display: flex; align-items: center; gap: 16px;
            z-index: 30; opacity: 0; pointer-events: none; transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 12px 42px rgba(0,0,0,0.65);
          }
          #hud.show { opacity: 1; transform: translate(-50%, -50%) scale(1); }
          .hud-icon { font-size: 32px; }
          .hud-text { font-size: 24px; font-weight: 700; color: #f8fafc; }
        </style>
        </head>
        <body>

          <!-- Ambient Mode Screen -->
          <div id="ambient">
            <div class="brand-logo">
              <div class="logo-icon">
                <svg viewBox="0 0 24 24"><path d="M21 3H3c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h5v2h8v-2h5c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 14H3V5h18v12z"/></svg>
              </div>
              <div class="brand-title">VDO TV</div>
            </div>
            <div class="clock" id="clock">--:--</div>
            <div class="date" id="date">Ready to Cast</div>
            <div class="status-card">
              <div class="pulse-dot"></div>
              <div>
                <div class="status-text">Connected to Wi-Fi</div>
                <div class="status-sub">Select or share video from <span class="ip-badge">VDO Remote</span></div>
              </div>
            </div>
          </div>

          <!-- Video Element -->
          <video id="v" playsinline preload="auto"></video>

          <!-- OSD Overlay -->
          <div id="osd">
            <div class="osd-top">
              <div class="video-title" id="osd-title">Playing Video</div>
              <div class="osd-badges">
                <div class="badge" id="badge-speed">1.0x</div>
                <div class="badge" id="badge-aspect">Fit</div>
              </div>
            </div>
            <div class="osd-bottom">
              <div class="progress-bar-container">
                <div class="buffer-bar" id="buffer-bar"></div>
                <div class="progress-bar" id="progress-bar"></div>
              </div>
              <div class="time-row">
                <span id="time-current">00:00</span>
                <span id="time-total">00:00</span>
              </div>
            </div>
          </div>

          <!-- Center HUD Alert -->
          <div id="hud">
            <div class="hud-icon" id="hud-icon">▶</div>
            <div class="hud-text" id="hud-text">Playing</div>
          </div>

        <script>
          const v = document.getElementById('v');
          const ambient = document.getElementById('ambient');
          const osd = document.getElementById('osd');
          const hud = document.getElementById('hud');
          const hudIcon = document.getElementById('hud-icon');
          const hudText = document.getElementById('hud-text');
          const clockEl = document.getElementById('clock');
          const dateEl = document.getElementById('date');
          const progressBar = document.getElementById('progress-bar');
          const bufferBar = document.getElementById('buffer-bar');
          const timeCurrent = document.getElementById('time-current');
          const timeTotal = document.getElementById('time-total');
          const osdTitle = document.getElementById('osd-title');
          const badgeSpeed = document.getElementById('badge-speed');
          const badgeAspect = document.getElementById('badge-aspect');

          let currentTitle = 'Video';
          let lastSeq = 0;
          let osdTimer = null;
          let hudTimer = null;
          let isMutedByCommand = false;

          function ensureAudioEnabled() {
            if (v.muted && !isMutedByCommand) {
              v.muted = false;
            }
            if (v.volume === 0 && !isMutedByCommand) {
              v.volume = 1.0;
            }
          }
          window.addEventListener('click', ensureAudioEnabled);
          window.addEventListener('keydown', ensureAudioEnabled);

          function updateClock() {
            const now = new Date();
            clockEl.innerText = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            dateEl.innerText = now.toLocaleDateString([], { weekday: 'long', month: 'short', day: 'numeric' });
          }
          setInterval(updateClock, 1000);
          updateClock();

          function formatTime(s) {
            if (isNaN(s) || s < 0) s = 0;
            const m = Math.floor(s / 60);
            const sec = Math.floor(s % 60);
            return (m < 10 ? '0' : '') + m + ':' + (sec < 10 ? '0' : '') + sec;
          }

          function showOsd() {
            osd.classList.add('visible');
            clearTimeout(osdTimer);
            osdTimer = setTimeout(() => { osd.classList.remove('visible'); }, 3000);
          }

          function showHud(icon, text) {
            hudIcon.innerText = icon;
            hudText.innerText = text;
            hud.classList.add('show');
            clearTimeout(hudTimer);
            hudTimer = setTimeout(() => { hud.classList.remove('show'); }, 1500);
            showOsd();
          }

          async function reportStatus() {
            try {
              const isBuffering = v.seeking || (v.readyState > 0 && v.readyState < 3);
              const statusObj = {
                status: v.style.display === 'none' ? 'idle' : (v.ended ? 'ended' : (isBuffering ? 'buffering' : (v.paused ? 'paused' : 'playing'))),
                currentTime: v.currentTime || 0,
                duration: isNaN(v.duration) ? 0 : v.duration,
                volume: v.volume,
                muted: v.muted,
                playbackRate: v.playbackRate,
                aspectRatio: v.style.objectFit || 'contain',
                title: currentTitle
              };
              await fetch('/api/status', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(statusObj)
              });
            } catch(e) {}
          }

          v.addEventListener('error', function() {
            const code = v.error ? v.error.code : 0;
            showHud('⚠️', 'Playback error (Code ' + code + ')');
            reportStatus();
          });

          v.addEventListener('timeupdate', () => {
            if (v.duration) {
              const pct = (v.currentTime / v.duration) * 100;
              progressBar.style.width = pct + '%';
              timeCurrent.innerText = formatTime(v.currentTime);
              timeTotal.innerText = formatTime(v.duration);
            }
            if (v.buffered && v.buffered.length > 0 && v.duration) {
              const bufEnd = v.buffered.end(v.buffered.length - 1);
              bufferBar.style.width = ((bufEnd / v.duration) * 100) + '%';
            }
          });

          v.addEventListener('volumechange', () => {
            if (v.muted && !isMutedByCommand) {
              v.muted = false;
            }
            reportStatus();
          });

          v.addEventListener('play', () => {
            ensureAudioEnabled();
            reportStatus();
          });
          v.addEventListener('pause', () => { reportStatus(); });
          v.addEventListener('ended', () => {
            reportStatus();
            showHud('⏹', 'Playback Ended');
          });

          setInterval(async () => {
            try {
              const r = await fetch('/api/state');
              const s = await r.json();
              if (s.seq === lastSeq) return;
              lastSeq = s.seq;

              if (s.cmd === 'load') {
                currentTitle = s.strVal || 'Now Playing';
                osdTitle.innerText = currentTitle;
                ambient.style.display = 'none';
                v.style.display = 'block';

                v.pause();
                v.src = '/stream?t=' + s.seq;
                v.load();
                
                isMutedByCommand = false;
                v.muted = false;
                v.volume = 1.0;
                
                const playPromise = v.play();
                if (playPromise !== undefined) {
                  playPromise.then(() => {
                    v.muted = false;
                  }).catch((err) => {
                    v.muted = true;
                    v.play().then(() => {
                      setTimeout(() => { v.muted = false; }, 200);
                    }).catch(()=>{});
                  });
                }
                showHud('▶', 'Playing');
              } else if (s.cmd === 'play') {
                ensureAudioEnabled();
                v.play().catch(() => {
                  v.muted = true;
                  v.play().then(() => { v.muted = false; }).catch(()=>{});
                });
                showHud('▶', 'Play');
              } else if (s.cmd === 'pause') {
                v.pause();
                showHud('⏸', 'Paused');
              } else if (s.cmd === 'toggle') {
                ensureAudioEnabled();
                if (v.paused) {
                  v.play().catch(() => {
                    v.muted = true;
                    v.play().then(() => { v.muted = false; }).catch(()=>{});
                  });
                  showHud('▶', 'Play');
                } else {
                  v.pause();
                  showHud('⏸', 'Paused');
                }
              } else if (s.cmd === 'seekRelative') {
                ensureAudioEnabled();
                v.currentTime = Math.max(0, Math.min(v.duration || 999999, v.currentTime + (s.val || 0)));
                const sign = s.val >= 0 ? '+' : '';
                showHud(s.val >= 0 ? '⏩' : '⏪', sign + s.val + 's (' + formatTime(v.currentTime) + ')');
              } else if (s.cmd === 'seekAbsolute') {
                ensureAudioEnabled();
                v.currentTime = Math.max(0, Math.min(v.duration || 999999, s.val || 0));
                showHud('⏩', formatTime(v.currentTime));
              } else if (s.cmd === 'setVolume') {
                v.volume = Math.max(0, Math.min(1, s.val));
                if (v.volume > 0) {
                  isMutedByCommand = false;
                  v.muted = false;
                }
                showHud('🔊', Math.round(v.volume * 100) + '%');
              } else if (s.cmd === 'volumeRelative') {
                v.volume = Math.max(0, Math.min(1, v.volume + (s.val || 0)));
                if (v.volume > 0) {
                  isMutedByCommand = false;
                  v.muted = false;
                }
                showHud('🔊', Math.round(v.volume * 100) + '%');
              } else if (s.cmd === 'mute') {
                isMutedByCommand = !isMutedByCommand;
                v.muted = isMutedByCommand;
                showHud(v.muted ? '🔇' : '🔊', v.muted ? 'Muted' : Math.round(v.volume * 100) + '%');
              } else if (s.cmd === 'setSpeed') {
                v.playbackRate = s.val || 1.0;
                badgeSpeed.innerText = v.playbackRate + 'x';
                showHud('⚡', v.playbackRate + 'x Speed');
              } else if (s.cmd === 'setAspect') {
                v.style.objectFit = s.strVal || 'contain';
                badgeAspect.innerText = s.strVal === 'cover' ? 'Fill' : (s.strVal === 'fill' ? 'Stretch' : 'Fit');
                showHud('🔲', 'Aspect: ' + badgeAspect.innerText);
              } else if (s.cmd === 'stop') {
                v.pause();
                v.src = '';
                v.style.display = 'none';
                ambient.style.display = 'flex';
                showHud('⏹', 'Standby');
              } else if (s.cmd === 'menu') {
                osd.classList.contains('visible') ? osd.classList.remove('visible') : showOsd();
              } else if (s.cmd === 'type') {
                showHud('⌨️', s.strVal || 'Typed');
              } else if (s.cmd === 'typeAndEnter') {
                showHud('🔍', s.strVal || 'Search');
                if (s.strVal && (s.strVal.startsWith('http://') || s.strVal.startsWith('https://'))) {
                  v.pause();
                  v.src = s.strVal;
                  v.load();
                  v.play().catch(()=>{});
                  ambient.style.display = 'none';
                  v.style.display = 'block';
                }
              } else if (s.cmd === 'key') {
                showHud('⌨️', (s.strVal || 'KEY').toUpperCase());
              }
              reportStatus();
            } catch(e) {}
          }, 200);

          setInterval(reportStatus, 500);

          window.handleTvKey = function(action, val) {
            ensureAudioEnabled();
            if (action === 'toggle') {
              if (v.paused) {
                v.play().catch(() => {
                  v.muted = true;
                  v.play().then(() => { v.muted = false; }).catch(()=>{});
                });
                showHud('▶', 'Play');
              } else {
                v.pause();
                showHud('⏸', 'Paused');
              }
            } else if (action === 'play') {
              v.play().catch(() => {
                v.muted = true;
                v.play().then(() => { v.muted = false; }).catch(()=>{});
              });
              showHud('▶', 'Play');
            } else if (action === 'pause') {
              v.pause();
              showHud('⏸', 'Paused');
            } else if (action === 'seek') {
              v.currentTime = Math.max(0, Math.min(v.duration || 999999, v.currentTime + (val || 0)));
              showHud(val >= 0 ? '⏩' : '⏪', (val >= 0 ? '+' : '') + val + 's');
            } else if (action === 'volume') {
              v.volume = Math.max(0, Math.min(1, v.volume + (val || 0)));
              if (v.volume > 0) {
                isMutedByCommand = false;
                v.muted = false;
              }
              showHud('🔊', Math.round(v.volume * 100) + '%');
            } else if (action === 'back') {
              if (v.style.display !== 'none' && !v.paused) {
                v.pause();
                v.style.display = 'none';
                ambient.style.display = 'flex';
                showHud('⏹', 'Standby');
              }
            } else if (action === 'menu') {
              osd.classList.contains('visible') ? osd.classList.remove('visible') : showOsd();
            }
            reportStatus();
          };
        </script>
        </body>
        </html>
    """.trimIndent()
}
EOF

# ==================== MODERN ERGONOMIC REMOTE UI (:app) ====================
cat << 'EOF' > app/src/main/java/com/example/lancast/MainActivity.kt
package com.example.lancast

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.Crossfade
import androidx.compose.animation.core.tween
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val serviceIntent = Intent(this, CastServerService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(serviceIntent)
        else startService(serviceIntent)

        val sharedUri: Uri? = if (intent?.action == Intent.ACTION_SEND) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.getParcelableExtra(Intent.EXTRA_STREAM)
            }
        } else null

        if (sharedUri != null) {
            try {
                grantUriPermission(packageName, sharedUri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } catch (_: Exception) {}

            val sendIntent = Intent(this, CastServerService::class.java).apply {
                data = sharedUri
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(sendIntent)
            else startService(sendIntent)

            CastServerService.currentVideoUri = sharedUri
            CastServerService.currentVideoTitle = getVideoName(this, sharedUri)
            CastServerService.pushCommand("load", 0.0, CastServerService.currentVideoTitle)
        }

        setContent {
            val luxuryDarkScheme = darkColorScheme(
                primary = Color(0xFF00E5FF),
                onPrimary = Color(0xFF060913),
                primaryContainer = Color(0xFF131D31),
                onPrimaryContainer = Color(0xFF38BDF8),
                secondary = Color(0xFF818CF8),
                background = Color(0xFF060913),
                surface = Color(0xFF0E1424),
                onSurface = Color(0xFFF8FAFC),
                surfaceVariant = Color(0xFF152037),
                onSurfaceVariant = Color(0xFF94A3B8)
            )

            MaterialTheme(colorScheme = luxuryDarkScheme) {
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    VdoMainScreen(initialUri = sharedUri)
                }
            }
        }
    }
}

fun getVideoName(context: Context, uri: Uri): String {
    var name = "Video"
    try {
        context.contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            if (nameIndex != -1 && cursor.moveToFirst()) {
                name = cursor.getString(nameIndex) ?: "Video"
            }
        }
    } catch (_: Exception) {}
    return name
}

fun formatTime(seconds: Double): String {
    if (seconds.isNaN() || seconds < 0) return "00:00"
    val totalSec = seconds.toLong()
    val m = totalSec / 60
    val s = totalSec % 60
    return String.format(java.util.Locale.US, "%02d:%02d", m, s)
}

fun getLocalWifiIp(context: Context): String {
    try {
        val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
        val ipInt = wifiManager?.connectionInfo?.ipAddress ?: 0
        if (ipInt != 0) {
            return String.format(
                java.util.Locale.US,
                "%d.%d.%d.%d",
                ipInt and 0xff,
                ipInt shr 8 and 0xff,
                ipInt shr 16 and 0xff,
                ipInt shr 24 and 0xff
            )
        }
    } catch (_: Exception) {}
    return "192.168.x.x"
}

@Composable
fun VdoMainScreen(initialUri: Uri?) {
    val context = LocalContext.current
    val haptic = LocalHapticFeedback.current
    var selectedTab by remember { mutableIntStateOf(0) } // 0 = Player, 1 = TV Remote
    var selectedUri by remember { mutableStateOf(initialUri ?: CastServerService.currentVideoUri) }
    var showInfoDialog by remember { mutableStateOf(false) }

    val tvStatus = CastServerService.tvStatus
    val isConnected = tvStatus.status != "idle"

    val picker = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.PickVisualMedia()
    ) { uri ->
        if (uri != null) {
            try {
                context.grantUriPermission(context.packageName, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } catch (_: Exception) {}
            try {
                context.contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } catch (_: Exception) {}

            val serviceIntent = Intent(context, CastServerService::class.java).apply {
                data = uri
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }

            selectedUri = uri
            CastServerService.currentVideoUri = uri
            val title = getVideoName(context, uri)
            CastServerService.currentVideoTitle = title
            CastServerService.pushCommand("load", 0.0, title)
        }
    }

    if (showInfoDialog) {
        AlertDialog(
            onDismissRequest = { showInfoDialog = false },
            title = { Text("VDO Cast Link Status", fontWeight = FontWeight.Bold) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    Text("Phone Wi-Fi IP: ${getLocalWifiIp(context)}:5050", fontWeight = FontWeight.SemiBold)
                    Text("Receiver: VDO TV (TX3 Mini)")
                    Text("Connection: ${if (isConnected) "Live Synced with TV" else "Standby (Waiting for TV)"}")
                    Divider(color = Color(0xFF1E293B))
                    Text("Ensure your TX3 Mini box is open on VDO TV and connected to the same Wi-Fi network.", style = MaterialTheme.typography.bodySmall, color = Color(0xFF94A3B8))
                }
            },
            confirmButton = {
                TextButton(onClick = { showInfoDialog = false }) { Text("Done", fontWeight = FontWeight.Bold) }
            }
        )
    }

    Scaffold(
        containerColor = MaterialTheme.colorScheme.background,
        topBar = {
            ModernTopAppBar(
                selectedTab = selectedTab,
                isConnected = isConnected,
                onInfoClick = { showInfoDialog = true },
                onStandbyClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    CastServerService.pushCommand("stop")
                }
            )
        },
        bottomBar = {
            NavigationBar(
                containerColor = Color(0xFF090D18),
                tonalElevation = 8.dp,
                modifier = Modifier.clip(RoundedCornerShape(topStart = 20.dp, topEnd = 20.dp))
            ) {
                NavigationBarItem(
                    selected = selectedTab == 0,
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        selectedTab = 0
                    },
                    icon = { Icon(Icons.Default.PlayCircle, contentDescription = "Player", modifier = Modifier.size(24.dp)) },
                    label = { Text("Player", fontWeight = if (selectedTab == 0) FontWeight.Bold else FontWeight.Normal) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = Color(0xFF060913),
                        selectedTextColor = Color(0xFF00E5FF),
                        indicatorColor = Color(0xFF00E5FF),
                        unselectedIconColor = Color(0xFF64748B),
                        unselectedTextColor = Color(0xFF64748B)
                    )
                )
                NavigationBarItem(
                    selected = selectedTab == 1,
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        selectedTab = 1
                    },
                    icon = { Icon(Icons.Default.SettingsRemote, contentDescription = "TV Remote", modifier = Modifier.size(24.dp)) },
                    label = { Text("TV Remote", fontWeight = if (selectedTab == 1) FontWeight.Bold else FontWeight.Normal) },
                    colors = NavigationBarItemDefaults.colors(
                        selectedIconColor = Color(0xFF060913),
                        selectedTextColor = Color(0xFF00E5FF),
                        indicatorColor = Color(0xFF00E5FF),
                        unselectedIconColor = Color(0xFF64748B),
                        unselectedTextColor = Color(0xFF64748B)
                    )
                )
            }
        }
    ) { innerPadding ->
        Box(modifier = Modifier.fillMaxSize().padding(innerPadding)) {
            Crossfade(targetState = selectedTab, animationSpec = tween(220), label = "TabSwitch") { tab ->
                when (tab) {
                    0 -> PlayerScreen(
                        selectedUri = selectedUri,
                        tvStatus = tvStatus,
                        onSelectVideo = { picker.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.VideoOnly)) }
                    )
                    1 -> RemoteScreen(
                        tvStatus = tvStatus,
                        isConnected = isConnected
                    )
                }
            }
        }
    }
}

@Composable
fun ModernTopAppBar(
    selectedTab: Int,
    isConnected: Boolean,
    onInfoClick: () -> Unit,
    onStandbyClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(38.dp)
                    .clip(CircleShape)
                    .background(Brush.linearGradient(listOf(Color(0xFF00E5FF), Color(0xFF3B82F6)))),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    if (selectedTab == 0) Icons.Default.PlayCircle else Icons.Default.SettingsRemote,
                    contentDescription = null,
                    tint = Color.Black,
                    modifier = Modifier.size(20.dp)
                )
            }
            Column {
                Text(
                    if (selectedTab == 0) "VDO Player" else "VDO TV Remote",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    letterSpacing = (-0.5).sp
                )
                Text("VDO Cast Suite", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalAlignment = Alignment.CenterVertically) {
            Surface(
                shape = RoundedCornerShape(20.dp),
                color = if (isConnected) Color(0xFF22C55E).copy(alpha = 0.15f) else Color(0xFF1E293B),
                border = BorderStroke(1.dp, if (isConnected) Color(0xFF22C55E).copy(alpha = 0.4f) else Color(0xFF334155)),
                modifier = Modifier.clickable { onInfoClick() }
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .size(7.dp)
                            .clip(CircleShape)
                            .background(if (isConnected) Color(0xFF22C55E) else Color(0xFF00E5FF))
                    )
                    Text(
                        if (isConnected) "VDO TV" else "Wi-Fi Ready",
                        style = MaterialTheme.typography.labelSmall,
                        fontWeight = FontWeight.SemiBold,
                        color = if (isConnected) Color(0xFF22C55E) else Color(0xFF00E5FF)
                    )
                }
            }

            FilledTonalIconButton(
                onClick = onStandbyClick,
                modifier = Modifier.size(36.dp),
                colors = IconButtonDefaults.filledTonalIconButtonColors(
                    containerColor = Color(0xFF1E293B),
                    contentColor = Color(0xFFEF4444)
                )
            ) {
                Icon(Icons.Default.PowerSettingsNew, contentDescription = "TV Standby", modifier = Modifier.size(18.dp))
            }
        }
    }
}

// ==================== SCREEN 1: DEDICATED MEDIA PLAYER ====================
@Composable
fun PlayerScreen(
    selectedUri: Uri?,
    tvStatus: TvPlaybackState,
    onSelectVideo: () -> Unit
) {
    val haptic = LocalHapticFeedback.current
    val scrollState = rememberScrollState()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(horizontal = 20.dp, vertical = 10.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        NowPlayingCard(
            title = if (tvStatus.title.isNotEmpty()) tvStatus.title else CastServerService.currentVideoTitle,
            status = tvStatus.status,
            currentTime = tvStatus.currentTime,
            duration = tvStatus.duration
        )

        HeroTransportRow(
            isPlaying = tvStatus.status == "playing",
            onToggle = {
                haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                CastServerService.pushCommand("toggle")
            },
            onSeek = { offset ->
                haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                CastServerService.pushCommand("seekRelative", offset)
            }
        )

        VolumeCapsuleCard(volume = tvStatus.volume, isMuted = tvStatus.muted)

        QuickModifiersCard(currentSpeed = tvStatus.playbackRate, currentAspect = tvStatus.aspectRatio)

        Button(
            onClick = onSelectVideo,
            modifier = Modifier.fillMaxWidth().height(54.dp),
            shape = RoundedCornerShape(16.dp),
            colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.primary)
        ) {
            Icon(Icons.Default.VideoLibrary, contentDescription = null, tint = Color.Black, modifier = Modifier.size(20.dp))
            Spacer(Modifier.width(10.dp))
            Text(
                if (selectedUri == null) "Select Video to Cast" else "Change Video",
                fontWeight = FontWeight.Bold,
                fontSize = 16.sp,
                color = Color.Black
            )
        }

        Spacer(Modifier.height(8.dp))
    }
}

@Composable
fun NowPlayingCard(
    title: String,
    status: String,
    currentTime: Double,
    duration: Double
) {
    var isDragging by remember { mutableStateOf(false) }
    var dragVal by remember { mutableFloatStateOf(0f) }

    val effectiveTime = if (isDragging) dragVal.toDouble() else currentTime
    val maxDuration = if (duration > 0) duration.toFloat() else 1f

    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color(0xFF0E1424)),
        border = BorderStroke(1.dp, Color(0xFF1E293B)),
        shape = RoundedCornerShape(22.dp)
    ) {
        Column(modifier = Modifier.padding(18.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = title.ifEmpty { "Select a video to stream" },
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                    Text(
                        text = if (duration > 0) "Total length: ${formatTime(duration)}" else "No active stream",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                Surface(
                    shape = RoundedCornerShape(10.dp),
                    color = when (status) {
                        "playing" -> Color(0xFF00E5FF).copy(alpha = 0.15f)
                        "paused" -> Color(0xFFF59E0B).copy(alpha = 0.15f)
                        "buffering" -> Color(0xFF8B5CF6).copy(alpha = 0.15f)
                        else -> Color(0xFF1E293B)
                    }
                ) {
                    Text(
                        text = status.uppercase(),
                        modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp),
                        style = MaterialTheme.typography.labelSmall,
                        fontWeight = FontWeight.Bold,
                        color = when (status) {
                            "playing" -> Color(0xFF00E5FF)
                            "paused" -> Color(0xFFF59E0B)
                            "buffering" -> Color(0xFF8B5CF6)
                            else -> Color(0xFF64748B)
                        }
                    )
                }
            }

            Slider(
                value = effectiveTime.toFloat().coerceIn(0f, maxDuration),
                onValueChange = {
                    isDragging = true
                    dragVal = it
                },
                onValueChangeFinished = {
                    isDragging = false
                    CastServerService.pushCommand("seekAbsolute", dragVal.toDouble())
                },
                valueRange = 0f..maxDuration,
                enabled = duration > 0,
                colors = SliderDefaults.colors(
                    thumbColor = Color(0xFF00E5FF),
                    activeTrackColor = Color(0xFF00E5FF),
                    inactiveTrackColor = Color(0xFF1E293B)
                )
            )

            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text(formatTime(effectiveTime), style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.Bold, color = Color(0xFF00E5FF))
                if (duration > 0) {
                    Text("-${formatTime(duration - effectiveTime)}", style = MaterialTheme.typography.labelSmall, color = Color(0xFF64748B))
                }
                Text(formatTime(duration), style = MaterialTheme.typography.labelMedium, color = Color(0xFF94A3B8))
            }
        }
    }
}

@Composable
fun HeroTransportRow(
    isPlaying: Boolean,
    onToggle: () -> Unit,
    onSeek: (Double) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        FilledTonalIconButton(
            onClick = { onSeek(-30.0) },
            modifier = Modifier.size(50.dp),
            shape = CircleShape,
            colors = IconButtonDefaults.filledTonalIconButtonColors(containerColor = Color(0xFF111827), contentColor = Color(0xFF94A3B8))
        ) {
            Icon(Icons.Default.Replay30, "-30s", modifier = Modifier.size(24.dp))
        }

        FilledTonalIconButton(
            onClick = { onSeek(-10.0) },
            modifier = Modifier.size(54.dp),
            shape = CircleShape,
            colors = IconButtonDefaults.filledTonalIconButtonColors(containerColor = Color(0xFF152037), contentColor = Color(0xFF00E5FF))
        ) {
            Icon(Icons.Default.Replay10, "-10s", modifier = Modifier.size(26.dp))
        }

        FilledIconButton(
            onClick = onToggle,
            modifier = Modifier.size(74.dp),
            shape = CircleShape,
            colors = IconButtonDefaults.filledIconButtonColors(containerColor = Color(0xFF00E5FF))
        ) {
            Icon(
                if (isPlaying) Icons.Default.Pause else Icons.Default.PlayArrow,
                contentDescription = "Play/Pause",
                tint = Color.Black,
                modifier = Modifier.size(40.dp)
            )
        }

        FilledTonalIconButton(
            onClick = { onSeek(10.0) },
            modifier = Modifier.size(54.dp),
            shape = CircleShape,
            colors = IconButtonDefaults.filledTonalIconButtonColors(containerColor = Color(0xFF152037), contentColor = Color(0xFF00E5FF))
        ) {
            Icon(Icons.Default.Forward10, "+10s", modifier = Modifier.size(26.dp))
        }

        FilledTonalIconButton(
            onClick = { onSeek(30.0) },
            modifier = Modifier.size(50.dp),
            shape = CircleShape,
            colors = IconButtonDefaults.filledTonalIconButtonColors(containerColor = Color(0xFF111827), contentColor = Color(0xFF94A3B8))
        ) {
            Icon(Icons.Default.Forward30, "+30s", modifier = Modifier.size(24.dp))
        }
    }
}

@Composable
fun VolumeCapsuleCard(volume: Float, isMuted: Boolean) {
    val haptic = LocalHapticFeedback.current

    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color(0xFF0E1424)),
        border = BorderStroke(1.dp, Color(0xFF1E293B)),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(modifier = Modifier.padding(18.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("TV Audio Volume", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold)
                Text(
                    if (isMuted) "MUTED" else "${(volume * 100).toInt()}%",
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.ExtraBold,
                    color = if (isMuted) Color(0xFFEF4444) else Color(0xFF00E5FF)
                )
            }
            Spacer(Modifier.height(6.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                IconButton(onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    CastServerService.pushCommand("mute")
                }) {
                    Icon(
                        if (isMuted) Icons.Default.VolumeOff else Icons.Default.VolumeUp,
                        contentDescription = "Mute",
                        tint = if (isMuted) Color(0xFFEF4444) else Color(0xFF00E5FF)
                    )
                }
                Slider(
                    value = volume,
                    onValueChange = { CastServerService.pushCommand("setVolume", it.toDouble()) },
                    valueRange = 0f..1f,
                    modifier = Modifier.weight(1f),
                    colors = SliderDefaults.colors(
                        thumbColor = if (isMuted) Color(0xFFEF4444) else Color(0xFF00E5FF),
                        activeTrackColor = if (isMuted) Color(0xFFEF4444) else Color(0xFF00E5FF),
                        inactiveTrackColor = Color(0xFF1E293B)
                    )
                )
            }
        }
    }
}

@Composable
fun QuickModifiersCard(currentSpeed: Float, currentAspect: String) {
    val haptic = LocalHapticFeedback.current

    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color(0xFF0E1424)),
        border = BorderStroke(1.dp, Color(0xFF1E293B)),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(modifier = Modifier.padding(18.dp), verticalArrangement = Arrangement.spacedBy(14.dp)) {
            Column {
                Text("Playback Speed", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.SemiBold, color = Color(0xFF94A3B8))
                Spacer(Modifier.height(6.dp))
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                    val speeds = listOf(0.75f, 1.0f, 1.25f, 1.5f, 2.0f)
                    speeds.forEach { sp ->
                        val isSelected = (currentSpeed - sp).let { if (it < 0) -it else it } < 0.05f
                        FilterChip(
                            selected = isSelected,
                            onClick = {
                                haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                                CastServerService.pushCommand("setSpeed", sp.toDouble())
                            },
                            label = { Text("${sp}x", fontSize = 12.sp) },
                            modifier = Modifier.weight(1f)
                        )
                    }
                }
            }

            Column {
                Text("Screen Aspect Ratio", style = MaterialTheme.typography.labelSmall, fontWeight = FontWeight.SemiBold, color = Color(0xFF94A3B8))
                Spacer(Modifier.height(6.dp))
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                    val aspects = listOf("contain" to "Fit", "cover" to "Fill", "fill" to "Stretch")
                    aspects.forEach { (mode, label) ->
                        val isSelected = currentAspect == mode
                        FilterChip(
                            selected = isSelected,
                            onClick = {
                                haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                                CastServerService.pushCommand("setAspect", 0.0, mode)
                            },
                            label = { Text(label, fontSize = 12.sp) },
                            modifier = Modifier.weight(1f)
                        )
                    }
                }
            }
        }
    }
}

// ==================== SCREEN 2: DEDICATED TV REMOTE CONTROLLER ====================
@Composable
fun RemoteScreen(
    tvStatus: TvPlaybackState,
    isConnected: Boolean
) {
    val haptic = LocalHapticFeedback.current
    val scrollState = rememberScrollState()
    var showKeyboardDialog by remember { mutableStateOf(false) }

    if (showKeyboardDialog) {
        var textInput by remember { mutableStateOf("") }
        AlertDialog(
            onDismissRequest = { showKeyboardDialog = false },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.Keyboard, contentDescription = null, tint = Color(0xFF00E5FF))
                    Text("Type on TV", fontWeight = FontWeight.Bold)
                }
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
                    Text(
                        "Type movie title, search query, or paste link to send to your TX3 Mini TV box:",
                        style = MaterialTheme.typography.bodySmall,
                        color = Color(0xFF94A3B8)
                    )

                    OutlinedTextField(
                        value = textInput,
                        onValueChange = { textInput = it },
                        placeholder = { Text("Search YouTube, Netflix, or web...") },
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(12.dp),
                        trailingIcon = {
                            if (textInput.isNotEmpty()) {
                                IconButton(onClick = { textInput = "" }) {
                                    Icon(Icons.Default.Clear, contentDescription = "Clear")
                                }
                            }
                        },
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = Color(0xFF00E5FF),
                            unfocusedBorderColor = Color(0xFF334155),
                            cursorColor = Color(0xFF00E5FF)
                        )
                    )

                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        OutlinedButton(
                            onClick = {
                                haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                                CastServerService.pushCommand("key", 0.0, "backspace")
                                if (textInput.isNotEmpty()) textInput = textInput.dropLast(1)
                            },
                            shape = RoundedCornerShape(10.dp),
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Icon(Icons.Default.Backspace, contentDescription = "Delete", modifier = Modifier.size(16.dp))
                            Spacer(Modifier.width(4.dp))
                            Text("Delete", fontSize = 12.sp)
                        }

                        OutlinedButton(
                            onClick = {
                                haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                                CastServerService.pushCommand("key", 0.0, "space")
                                textInput += " "
                            },
                            shape = RoundedCornerShape(10.dp),
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Text("Space", fontSize = 12.sp)
                        }

                        OutlinedButton(
                            onClick = {
                                haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                                CastServerService.pushCommand("key", 0.0, "clear")
                                textInput = ""
                            },
                            shape = RoundedCornerShape(10.dp),
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Text("Clear", fontSize = 12.sp)
                        }
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        if (textInput.isNotBlank()) {
                            CastServerService.pushCommand("typeAndEnter", 0.0, textInput)
                            showKeyboardDialog = false
                        }
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00E5FF)),
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Icon(Icons.Default.Search, contentDescription = null, tint = Color.Black, modifier = Modifier.size(16.dp))
                    Spacer(Modifier.width(6.dp))
                    Text("Send & Search", fontWeight = FontWeight.Bold, color = Color.Black)
                }
            },
            dismissButton = {
                TextButton(
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        if (textInput.isNotBlank()) {
                            CastServerService.pushCommand("type", 0.0, textInput)
                        }
                    }
                ) {
                    Text("Type Only", color = Color(0xFF00E5FF))
                }
            }
        )
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
            .padding(horizontal = 20.dp, vertical = 10.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(18.dp)
    ) {
        // TV Live Status Feedback Strip
        Surface(
            shape = RoundedCornerShape(16.dp),
            color = Color(0xFF0E1424),
            border = BorderStroke(1.dp, Color(0xFF1E293B)),
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier.padding(horizontal = 16.dp, vertical = 10.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Box(
                        modifier = Modifier
                            .size(8.dp)
                            .clip(CircleShape)
                            .background(if (isConnected) Color(0xFF22C55E) else Color(0xFF00E5FF))
                    )
                    Text(
                        if (isConnected) "VDO TV • LIVE SYNC" else "TV STANDBY",
                        style = MaterialTheme.typography.labelMedium,
                        fontWeight = FontWeight.Bold,
                        color = if (isConnected) Color(0xFF22C55E) else Color(0xFF00E5FF)
                    )
                }
                Text(
                    if (tvStatus.duration > 0) "${formatTime(tvStatus.currentTime)} / ${formatTime(tvStatus.duration)}" else "Ready",
                    style = MaterialTheme.typography.labelMedium,
                    color = Color(0xFF94A3B8)
                )
            }
        }

        // Remote Top Utility Bar (Power, Menu, Type on TV Keyboard, Mute)
        Row(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            FilledTonalIconButton(
                onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    CastServerService.pushCommand("stop")
                },
                modifier = Modifier.size(50.dp),
                shape = CircleShape,
                colors = IconButtonDefaults.filledTonalIconButtonColors(
                    containerColor = Color(0xFF200F17),
                    contentColor = Color(0xFFEF4444)
                )
            ) {
                Icon(Icons.Default.PowerSettingsNew, contentDescription = "TV Power", modifier = Modifier.size(24.dp))
            }

            FilledTonalIconButton(
                onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    CastServerService.pushCommand("menu")
                },
                modifier = Modifier.size(50.dp),
                shape = CircleShape,
                colors = IconButtonDefaults.filledTonalIconButtonColors(
                    containerColor = Color(0xFF131D31),
                    contentColor = Color(0xFF00E5FF)
                )
            ) {
                Icon(Icons.Default.Menu, contentDescription = "TV Menu OSD", modifier = Modifier.size(24.dp))
            }

            FilledTonalIconButton(
                onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    showKeyboardDialog = true
                },
                modifier = Modifier.size(50.dp),
                shape = CircleShape,
                colors = IconButtonDefaults.filledTonalIconButtonColors(
                    containerColor = Color(0xFF131D31),
                    contentColor = Color(0xFF38BDF8)
                )
            ) {
                Icon(Icons.Default.Keyboard, contentDescription = "Type on TV", modifier = Modifier.size(24.dp))
            }

            FilledTonalIconButton(
                onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    CastServerService.pushCommand("mute")
                },
                modifier = Modifier.size(50.dp),
                shape = CircleShape,
                colors = IconButtonDefaults.filledTonalIconButtonColors(
                    containerColor = Color(0xFF131D31),
                    contentColor = if (tvStatus.muted) Color(0xFFEF4444) else Color(0xFFF59E0B)
                )
            ) {
                Icon(
                    if (tvStatus.muted) Icons.Default.VolumeOff else Icons.Default.VolumeUp,
                    contentDescription = "Mute",
                    modifier = Modifier.size(24.dp)
                )
            }
        }

        // Tactile D-Pad Navigation Wheel
        TactileRemoteWheel(onCommand = { cmd ->
            when (cmd) {
                "up" -> CastServerService.pushCommand("seekRelative", 30.0)
                "down" -> CastServerService.pushCommand("seekRelative", -30.0)
                "left" -> CastServerService.pushCommand("seekRelative", -10.0)
                "right" -> CastServerService.pushCommand("seekRelative", 10.0)
                "ok" -> CastServerService.pushCommand("toggle")
            }
        })

        // Hardware-Style Dual Rocker Capsules (Volume & Seek)
        HardwareRockersRow(
            volume = tvStatus.volume,
            isMuted = tvStatus.muted,
            onVolumeChange = { delta ->
                CastServerService.pushCommand("volumeRelative", delta)
            },
            onSeekRelative = { offset ->
                CastServerService.pushCommand("seekRelative", offset)
            }
        )

        // Bottom Remote Action Row: Standby, Hero Play/Pause, Quick Aspect
        Row(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 10.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            OutlinedButton(
                onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    CastServerService.pushCommand("stop")
                },
                shape = RoundedCornerShape(14.dp),
                border = BorderStroke(1.dp, Color(0xFF334155)),
                modifier = Modifier.height(46.dp)
            ) {
                Icon(Icons.Default.ArrowBack, contentDescription = null, modifier = Modifier.size(16.dp))
                Spacer(Modifier.width(6.dp))
                Text("Standby")
            }

            FilledIconButton(
                onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    CastServerService.pushCommand("toggle")
                },
                modifier = Modifier.size(56.dp),
                shape = CircleShape,
                colors = IconButtonDefaults.filledIconButtonColors(containerColor = Color(0xFF00E5FF))
            ) {
                Icon(
                    if (tvStatus.status == "playing") Icons.Default.Pause else Icons.Default.PlayArrow,
                    contentDescription = "Play/Pause",
                    tint = Color.Black,
                    modifier = Modifier.size(30.dp)
                )
            }

            OutlinedButton(
                onClick = {
                    haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                    val nextAspect = when (tvStatus.aspectRatio) {
                        "contain" -> "cover"
                        "cover" -> "fill"
                        else -> "contain"
                    }
                    CastServerService.pushCommand("setAspect", 0.0, nextAspect)
                },
                shape = RoundedCornerShape(14.dp),
                border = BorderStroke(1.dp, Color(0xFF334155)),
                modifier = Modifier.height(46.dp)
            ) {
                Icon(Icons.Default.AspectRatio, contentDescription = null, modifier = Modifier.size(16.dp))
                Spacer(Modifier.width(6.dp))
                Text(when (tvStatus.aspectRatio) {
                    "cover" -> "Fill"
                    "fill" -> "Stretch"
                    else -> "Fit"
                })
            }
        }

        Spacer(Modifier.height(10.dp))
    }
}

@Composable
fun TactileRemoteWheel(onCommand: (String) -> Unit) {
    val haptic = LocalHapticFeedback.current

    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color(0xFF0E1424)),
        border = BorderStroke(1.dp, Color(0xFF1E293B)),
        shape = RoundedCornerShape(26.dp)
    ) {
        Column(
            modifier = Modifier.padding(22.dp).fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text("Directional Navigation Pad", style = MaterialTheme.typography.labelMedium, fontWeight = FontWeight.SemiBold, color = Color(0xFF94A3B8))
            Spacer(Modifier.height(14.dp))

            Box(
                modifier = Modifier
                    .size(220.dp)
                    .clip(CircleShape)
                    .background(Color(0xFF131D31)),
                contentAlignment = Alignment.Center
            ) {
                // UP (+30s)
                IconButton(
                    onClick = { haptic.performHapticFeedback(HapticFeedbackType.LongPress); onCommand("up") },
                    modifier = Modifier.align(Alignment.TopCenter).padding(top = 8.dp).size(52.dp)
                ) {
                    Icon(Icons.Default.KeyboardArrowUp, contentDescription = "Up", tint = Color(0xFF00E5FF), modifier = Modifier.size(34.dp))
                }

                // LEFT (-10s)
                IconButton(
                    onClick = { haptic.performHapticFeedback(HapticFeedbackType.LongPress); onCommand("left") },
                    modifier = Modifier.align(Alignment.CenterStart).padding(start = 8.dp).size(52.dp)
                ) {
                    Icon(Icons.Default.KeyboardArrowLeft, contentDescription = "Left", tint = Color(0xFF00E5FF), modifier = Modifier.size(34.dp))
                }

                // CENTER OK DISC
                FilledIconButton(
                    onClick = { haptic.performHapticFeedback(HapticFeedbackType.LongPress); onCommand("ok") },
                    modifier = Modifier.size(76.dp),
                    shape = CircleShape,
                    colors = IconButtonDefaults.filledIconButtonColors(containerColor = Color(0xFF00E5FF))
                ) {
                    Text("OK", fontWeight = FontWeight.ExtraBold, fontSize = 20.sp, color = Color.Black)
                }

                // RIGHT (+10s)
                IconButton(
                    onClick = { haptic.performHapticFeedback(HapticFeedbackType.LongPress); onCommand("right") },
                    modifier = Modifier.align(Alignment.CenterEnd).padding(end = 8.dp).size(52.dp)
                ) {
                    Icon(Icons.Default.KeyboardArrowRight, contentDescription = "Right", tint = Color(0xFF00E5FF), modifier = Modifier.size(34.dp))
                }

                // DOWN (-30s)
                IconButton(
                    onClick = { haptic.performHapticFeedback(HapticFeedbackType.LongPress); onCommand("down") },
                    modifier = Modifier.align(Alignment.BottomCenter).padding(bottom = 8.dp).size(52.dp)
                ) {
                    Icon(Icons.Default.KeyboardArrowDown, contentDescription = "Down", tint = Color(0xFF00E5FF), modifier = Modifier.size(34.dp))
                }
            }
        }
    }
}

@Composable
fun HardwareRockersRow(
    volume: Float,
    isMuted: Boolean,
    onVolumeChange: (Double) -> Unit,
    onSeekRelative: (Double) -> Unit
) {
    val haptic = LocalHapticFeedback.current

    Row(
        modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Volume Rocker Capsule
        Card(
            shape = RoundedCornerShape(26.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFF0E1424)),
            border = BorderStroke(1.dp, Color(0xFF1E293B)),
            modifier = Modifier.width(110.dp).height(160.dp)
        ) {
            Column(
                modifier = Modifier.fillMaxSize().padding(vertical = 8.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.SpaceBetween
            ) {
                IconButton(
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        onVolumeChange(0.05)
                    },
                    modifier = Modifier.size(44.dp)
                ) {
                    Icon(Icons.Default.Add, contentDescription = "Vol +", tint = Color(0xFF00E5FF))
                }

                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(
                        if (isMuted) Icons.Default.VolumeOff else Icons.Default.VolumeUp,
                        contentDescription = null,
                        tint = if (isMuted) Color(0xFFEF4444) else Color(0xFF00E5FF),
                        modifier = Modifier.size(20.dp)
                    )
                    Text(
                        if (isMuted) "MUTED" else "${(volume * 100).toInt()}%",
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF94A3B8)
                    )
                }

                IconButton(
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        onVolumeChange(-0.05)
                    },
                    modifier = Modifier.size(44.dp)
                ) {
                    Icon(Icons.Default.Remove, contentDescription = "Vol -", tint = Color(0xFF00E5FF))
                }
            }
        }

        // Seek Rocker Capsule
        Card(
            shape = RoundedCornerShape(26.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFF0E1424)),
            border = BorderStroke(1.dp, Color(0xFF1E293B)),
            modifier = Modifier.width(110.dp).height(160.dp)
        ) {
            Column(
                modifier = Modifier.fillMaxSize().padding(vertical = 8.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.SpaceBetween
            ) {
                IconButton(
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        onSeekRelative(15.0)
                    },
                    modifier = Modifier.size(44.dp)
                ) {
                    Icon(Icons.Default.FastForward, contentDescription = "FF 15s", tint = Color(0xFF818CF8))
                }

                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text("SEEK", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = Color(0xFF818CF8))
                    Text("±15s", fontSize = 10.sp, color = Color(0xFF64748B))
                }

                IconButton(
                    onClick = {
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        onSeekRelative(-15.0)
                    },
                    modifier = Modifier.size(44.dp)
                ) {
                    Icon(Icons.Default.FastRewind, contentDescription = "Rew 15s", tint = Color(0xFF818CF8))
                }
            }
        }
    }
}
EOF

# ==================== 2. TX3 MINI TV RECEIVER MODULE (:tv) ====================
cat << 'EOF' > tv/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.lancasttv"
    compileSdk = 34
    defaultConfig {
        applicationId = "com.example.lancasttv"
        minSdk = 21
        targetSdk = 34
        versionCode = 2
        versionName = "2.0"
    }
    signingConfigs {
        create("release") {
            storeFile = rootProject.file("release.keystore")
            storePassword = "vdocast"
            keyAlias = "vdocast"
            keyPassword = "vdocast"
        }
    }
    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
}
EOF

# TV Strings
cat << 'EOF' > tv/src/main/res/values/strings.xml
<resources>
    <string name="app_name">VDO TV</string>
</resources>
EOF

# Modern Professional TV Vector Icons & Leanback Banner
cat << 'EOF' > tv/src/main/res/drawable/ic_launcher_background.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#05070E"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#0D1526"
        android:pathData="M54,54m-46,0a46,46 0,1 1,92 0a46,46 0,1 1,-92 0" />
    <path
        android:fillColor="#152037"
        android:pathData="M54,54m-32,0a32,32 0,1 1,64 0a32,32 0,1 1,-64 0" />
</vector>
EOF

cat << 'EOF' > tv/src/main/res/drawable/ic_launcher_foreground.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <!-- Stand -->
    <path
        android:fillColor="#475569"
        android:pathData="M50,72 h8 v6 h-8 z M42,78 h24 v3 h-24 z" />

    <!-- Ultra-slim TV Bezel -->
    <path
        android:fillColor="#00E5FF"
        android:pathData="M24,30 h60 c3.3,0 6,2.7 6,6 v32 c0,3.3 -2.7,6 -6,6 h-60 c-3.3,0 -6,-2.7 -6,-6 v-32 c0,-3.3 2.7,-6 6,-6 z" />

    <!-- Cinema Display Inner Screen -->
    <path
        android:fillColor="#05070E"
        android:pathData="M27,33 h54 v28 h-54 z" />

    <!-- Luminous Play Mark -->
    <path
        android:fillColor="#00E5FF"
        android:pathData="M50,40 l12,7 -12,7 z" />

    <!-- Inward Reception Arc Signals -->
    <path
        android:strokeColor="#818CF8"
        android:strokeWidth="3"
        android:strokeLineCap="round"
        android:pathData="M40,24 a16,16 0 0,1 28,0" />
    <path
        android:strokeColor="#00E5FF"
        android:strokeWidth="3.2"
        android:strokeLineCap="round"
        android:pathData="M34,18 a24,24 0 0,1 40,0" />
</vector>
EOF

cat << 'EOF' > tv/src/main/res/drawable/ic_launcher.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#05070E"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#475569"
        android:pathData="M50,72 h8 v6 h-8 z M42,78 h24 v3 h-24 z" />
    <path
        android:fillColor="#00E5FF"
        android:pathData="M24,30 h60 c3.3,0 6,2.7 6,6 v32 c0,3.3 -2.7,6 -6,6 h-60 c-3.3,0 -6,-2.7 -6,-6 v-32 c0,-3.3 2.7,-6 6,-6 z" />
    <path
        android:fillColor="#05070E"
        android:pathData="M27,33 h54 v28 h-54 z" />
    <path
        android:fillColor="#00E5FF"
        android:pathData="M50,40 l12,7 -12,7 z" />
</vector>
EOF

# Premium Widescreen 16:9 Leanback TV Launcher Banner for VDO TV (320x180 dp)
cat << 'EOF' > tv/src/main/res/drawable/tv_banner.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="320dp"
    android:height="180dp"
    android:viewportWidth="320"
    android:viewportHeight="180">
    <!-- Studio Dark Gradient Background -->
    <path
        android:fillColor="#05070E"
        android:pathData="M0,0h320v180h-320z" />
    <path
        android:fillColor="#0D1627"
        android:pathData="M0,0 L320,180 L0,180 Z" />

    <!-- Left Cinema Display Graphic -->
    <path
        android:fillColor="#475569"
        android:pathData="M66,128 h16 v10 h-16 z M54,138 h40 v4 h-40 z" />
    <path
        android:fillColor="#00E5FF"
        android:pathData="M26,54 h96 c4,0 7,3 7,7 v60 c0,4 -3,7 -7,7 h-96 c-4,0 -7,-3 -7,-7 v-60 c0,-4 3,-7 7,-7 z" />
    <path
        android:fillColor="#05070E"
        android:pathData="M31,59 h86 v52 h-86 z" />
    <path
        android:fillColor="#00E5FF"
        android:pathData="M66,72 l22,13 -22,13 z" />

    <!-- Receiving Broadcast Signal Rays -->
    <path
        android:strokeColor="#818CF8"
        android:strokeWidth="4"
        android:strokeLineCap="round"
        android:pathData="M56,42 a24,24 0 0,1 36,0" />
    <path
        android:strokeColor="#00E5FF"
        android:strokeWidth="4"
        android:strokeLineCap="round"
        android:pathData="M46,32 a36,36 0 0,1 56,0" />

    <!-- "V D O" Typography -->
    <!-- 'V' -->
    <path
        android:fillColor="#00E5FF"
        android:pathData="M150,62 L163,116 L176,62 L188,62 L170,126 L156,126 L138,62 Z" />
    <!-- 'D' -->
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M198,62 H220 C234,62 244,72 244,86 L244,102 C244,116 234,126 220,126 H198 Z M210,74 V114 H219 C227,114 231,109 231,101 V87 C231,79 227,74 219,74 Z" />
    <!-- 'O' -->
    <path
        android:fillColor="#00E5FF"
        android:pathData="M272,62 C258,62 249,72 249,86 V102 C249,116 258,126 272,126 C286,126 295,116 295,102 V86 C295,72 286,62 272,62 Z M272,74 C279,74 282,79 282,87 V101 C282,109 279,114 272,114 C265,114 262,109 262,101 V87 C262,79 265,74 272,74 Z" />

    <!-- Subtitle: "TV • CINEMA RECEIVER" Accent Bar -->
    <path
        android:fillColor="#818CF8"
        android:pathData="M150,140 h145 v3 h-145 z" />
</vector>
EOF

cat << 'EOF' > tv/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

cat << 'EOF' > tv/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <uses-feature android:name="android.software.leanback" android:required="false" />
    <uses-feature android:name="android.hardware.touchscreen" android:required="false" />

    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:banner="@drawable/tv_banner"
        android:usesCleartextTraffic="true"
        android:theme="@android:style/Theme.Black.NoTitleBar.Fullscreen">
        <activity
            android:name=".TvReceiverActivity"
            android:exported="true"
            android:configChanges="orientation|screenSize|screenLayout|keyboardHidden">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
                <category android:name="android.intent.category.LEANBACK_LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- VDO Remote Keyboard Input Method Service for TX3 Mini & Android TV -->
        <service
            android:name=".VdoRemoteImeService"
            android:label="VDO Remote Keyboard"
            android:permission="android.permission.BIND_INPUT_METHOD"
            android:exported="true">
            <intent-filter>
                <action android:name="android.view.InputMethod" />
            </intent-filter>
            <meta-data
                android:name="android.view.im"
                android:resource="@xml/method" />
        </service>
    </application>
</manifest>
EOF

cat << 'EOF' > tv/src/main/res/xml/method.xml
<?xml version="1.0" encoding="utf-8"?>
<input-method xmlns:android="http://schemas.android.com/apk/res/android"
    android:settingsActivity="com.example.lancasttv.TvReceiverActivity" />
EOF

cat << 'EOF' > tv/src/main/java/com/example/lancasttv/TvReceiverActivity.kt
package com.example.lancasttv

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.media.AudioManager
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.os.Bundle
import android.view.Gravity
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.FrameLayout
import android.widget.TextView

class TvReceiverActivity : Activity() {

    private lateinit var nsdManager: NsdManager
    private var discoveryListener: NsdManager.DiscoveryListener? = null
    private lateinit var webView: WebView
    private lateinit var statusContainer: FrameLayout
    private lateinit var statusText: TextView
    private var connected = false

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure volume keys control media playback audio stream (fixes no sound / wrong audio stream on TV)
        volumeControlStream = AudioManager.STREAM_MUSIC
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        @Suppress("DEPRECATION")
        audioManager?.requestAudioFocus(null, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN)

        // Keep TV screen awake during casting
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        // Fullscreen immersive sticky mode
        @Suppress("DEPRECATION")
        window.decorView.systemUiVisibility = (
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
            or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
            or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
            or View.SYSTEM_UI_FLAG_FULLSCREEN
            or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
        )

        val root = FrameLayout(this).apply { setBackgroundColor(Color.BLACK) }

        webView = WebView(this).apply {
            visibility = View.GONE
            setBackgroundColor(Color.BLACK)
            settings.apply {
                javaScriptEnabled = true
                mediaPlaybackRequiresUserGesture = false
                domStorageEnabled = true
                databaseEnabled = true
                allowFileAccess = true
                allowContentAccess = true
                setSupportZoom(false)
                loadWithOverviewMode = true
                useWideViewPort = true
                cacheMode = WebSettings.LOAD_NO_CACHE
            }
            webChromeClient = WebChromeClient()
            webViewClient = object : WebViewClient() {
                override fun onReceivedError(view: WebView?, errorCode: Int, description: String?, failingUrl: String?) {
                    showDisconnectedState("Connection interrupted. Reconnecting to phone...")
                }
            }
        }

        statusContainer = FrameLayout(this).apply {
            setBackgroundColor(Color.parseColor("#05070E"))
        }

        statusText = TextView(this).apply {
            text = "VDO TV Receiver\n\nSearching for VDO Remote on Wi-Fi...\nMake sure your phone and TV are on the same Wi-Fi network."
            setTextColor(Color.parseColor("#00E5FF"))
            textSize = 20f
            gravity = Gravity.CENTER
            setLineSpacing(8f, 1.2f)
            setPadding(40, 40, 40, 40)
        }

        statusContainer.addView(statusText, FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT, Gravity.CENTER))
        root.addView(webView, FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT))
        root.addView(statusContainer, FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT))
        setContentView(root)

        nsdManager = getSystemService(Context.NSD_SERVICE) as NsdManager
        startDiscovery()
    }

    override fun onResume() {
        super.onResume()
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        @Suppress("DEPRECATION")
        audioManager?.requestAudioFocus(null, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN)
    }

    private fun startDiscovery() {
        discoveryListener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {}
            override fun onServiceFound(service: NsdServiceInfo) {
                val isTarget = service.serviceType.contains("_vdocast") || service.serviceType.contains("_lancast")
                if (isTarget && !connected) {
                    nsdManager.resolveService(service, object : NsdManager.ResolveListener {
                        override fun onResolveFailed(info: NsdServiceInfo, errorCode: Int) {}
                        override fun onServiceResolved(info: NsdServiceInfo) {
                            val host = info.host?.hostAddress ?: return
                            val port = info.port
                            connected = true
                            runOnUiThread {
                                statusContainer.visibility = View.GONE
                                webView.visibility = View.VISIBLE
                                webView.loadUrl("http://$host:$port/tv")
                            }
                        }
                    })
                }
            }
            override fun onServiceLost(service: NsdServiceInfo) {
                showDisconnectedState("Phone disconnected. Searching for VDO Remote on Wi-Fi...")
            }
            override fun onDiscoveryStopped(serviceType: String) {}
            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {}
            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {}
        }
        nsdManager.discoverServices("_vdocast._tcp.", NsdManager.PROTOCOL_DNS_SD, discoveryListener)
    }

    private fun showDisconnectedState(message: String) {
        connected = false
        runOnUiThread {
            webView.visibility = View.GONE
            statusContainer.visibility = View.VISIBLE
            statusText.text = "VDO TV Receiver\n\n$message"
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (connected) {
            when (keyCode) {
                KeyEvent.KEYCODE_DPAD_CENTER,
                KeyEvent.KEYCODE_ENTER,
                KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE -> {
                    webView.evaluateJavascript("window.handleTvKey('toggle')", null)
                    return true
                }
                KeyEvent.KEYCODE_MEDIA_PLAY -> {
                    webView.evaluateJavascript("window.handleTvKey('play')", null)
                    return true
                }
                KeyEvent.KEYCODE_MEDIA_PAUSE -> {
                    webView.evaluateJavascript("window.handleTvKey('pause')", null)
                    return true
                }
                KeyEvent.KEYCODE_DPAD_LEFT,
                KeyEvent.KEYCODE_MEDIA_REWIND -> {
                    webView.evaluateJavascript("window.handleTvKey('seek', -10)", null)
                    return true
                }
                KeyEvent.KEYCODE_DPAD_RIGHT,
                KeyEvent.KEYCODE_MEDIA_FAST_FORWARD -> {
                    webView.evaluateJavascript("window.handleTvKey('seek', 10)", null)
                    return true
                }
                KeyEvent.KEYCODE_DPAD_UP,
                KeyEvent.KEYCODE_VOLUME_UP -> {
                    webView.evaluateJavascript("window.handleTvKey('volume', 0.1)", null)
                    return true
                }
                KeyEvent.KEYCODE_DPAD_DOWN,
                KeyEvent.KEYCODE_VOLUME_DOWN -> {
                    webView.evaluateJavascript("window.handleTvKey('volume', -0.1)", null)
                    return true
                }
                KeyEvent.KEYCODE_MEDIA_STOP -> {
                    webView.evaluateJavascript("window.handleTvKey('back')", null)
                    return true
                }
                KeyEvent.KEYCODE_BACK -> {
                    webView.evaluateJavascript("window.handleTvKey('back')", null)
                    return true
                }
                KeyEvent.KEYCODE_MENU -> {
                    webView.evaluateJavascript("window.handleTvKey('menu')", null)
                    return true
                }
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onDestroy() {
        try { discoveryListener?.let { nsdManager.stopServiceDiscovery(it) } } catch (_: Exception) {}
        super.onDestroy()
    }
}
EOF

cat << 'EOF' > tv/src/main/java/com/example/lancasttv/VdoRemoteImeService.kt
package com.example.lancasttv

import android.inputmethodservice.InputMethodService
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.KeyEvent
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL

class VdoRemoteImeService : InputMethodService() {

    private val handler = Handler(Looper.getMainLooper())
    private var isPolling = false
    private var lastSeq = 0
    private var phoneHost: String? = null
    private var phonePort: Int = 5050
    private var nsdManager: NsdManager? = null
    private var discoveryListener: NsdManager.DiscoveryListener? = null
    private var infoView: TextView? = null

    override fun onCreate() {
        super.onCreate()
        nsdManager = getSystemService(NSD_SERVICE) as? NsdManager
        startNsdDiscovery()
    }

    override fun onCreateInputView(): View {
        val root = FrameLayout(this).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            setBackgroundColor(android.graphics.Color.parseColor("#E605070E"))
            setPadding(32, 20, 32, 20)
        }

        infoView = TextView(this).apply {
            text = "⌨️ VDO Remote Keyboard • Type on phone or use TX3 remote"
            setTextColor(android.graphics.Color.parseColor("#00E5FF"))
            textSize = 16f
            gravity = Gravity.CENTER
            setPadding(16, 12, 16, 12)
        }
        root.addView(infoView, FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT))
        return root
    }

    override fun onStartInputView(info: android.view.inputmethod.EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        startStatePolling()
    }

    override fun onFinishInputView(finishingInput: Boolean) {
        super.onFinishInputView(finishingInput)
        stopStatePolling()
    }

    private fun startNsdDiscovery() {
        discoveryListener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {}
            override fun onServiceFound(service: NsdServiceInfo) {
                val isTarget = service.serviceType.contains("_vdocast") || service.serviceType.contains("_lancast")
                if (isTarget) {
                    nsdManager?.resolveService(service, object : NsdManager.ResolveListener {
                        override fun onResolveFailed(info: NsdServiceInfo, errorCode: Int) {}
                        override fun onServiceResolved(info: NsdServiceInfo) {
                            phoneHost = info.host?.hostAddress
                            phonePort = info.port
                        }
                    })
                }
            }
            override fun onServiceLost(service: NsdServiceInfo) {}
            override fun onDiscoveryStopped(serviceType: String) {}
            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {}
            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {}
        }
        try {
            nsdManager?.discoverServices("_vdocast._tcp.", NsdManager.PROTOCOL_DNS_SD, discoveryListener)
        } catch (_: Exception) {}
    }

    private fun startStatePolling() {
        if (isPolling) return
        isPolling = true
        Thread {
            while (isPolling) {
                val host = phoneHost
                if (host != null) {
                    try {
                        val url = URL("http://$host:$phonePort/api/state")
                        val conn = (url.openConnection() as HttpURLConnection).apply {
                            connectTimeout = 1200
                            readTimeout = 1200
                        }
                        if (conn.responseCode == 200) {
                            val reader = BufferedReader(InputStreamReader(conn.inputStream))
                            val resp = reader.readText()
                            reader.close()
                            val json = JSONObject(resp)
                            val seq = json.optInt("seq", 0)
                            if (seq != lastSeq) {
                                lastSeq = seq
                                val cmd = json.optString("cmd", "")
                                val strVal = json.optString("strVal", "")
                                handler.post { handleCommand(cmd, strVal) }
                            }
                        }
                        conn.disconnect()
                    } catch (_: Exception) {}
                }
                try { Thread.sleep(200) } catch (_: Exception) {}
            }
        }.start()
    }

    private fun stopStatePolling() {
        isPolling = false
    }

    private fun handleCommand(cmd: String, strVal: String) {
        val ic = currentInputConnection
        when (cmd) {
            "type" -> {
                ic?.commitText(strVal, 1)
                injectShellText(strVal)
            }
            "typeAndEnter" -> {
                ic?.commitText(strVal, 1)
                ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_ENTER))
                ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_ENTER))
                injectShellText(strVal)
                injectShellKey(KeyEvent.KEYCODE_ENTER)
            }
            "key" -> {
                when (strVal.lowercase()) {
                    "backspace" -> {
                        ic?.deleteSurroundingText(1, 0)
                        injectShellKey(KeyEvent.KEYCODE_DEL)
                    }
                    "enter" -> {
                        ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_ENTER))
                        ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_ENTER))
                        injectShellKey(KeyEvent.KEYCODE_ENTER)
                    }
                    "space" -> {
                        ic?.commitText(" ", 1)
                        injectShellKey(KeyEvent.KEYCODE_SPACE)
                    }
                    "clear" -> {
                        ic?.deleteSurroundingText(100, 100)
                    }
                }
            }
        }
    }

    private fun injectShellText(text: String) {
        try {
            val safe = text.replace(" ", "%s").replace("'", "\\'")
            Runtime.getRuntime().exec(arrayOf("sh", "-c", "input text '$safe'"))
        } catch (_: Exception) {}
    }

    private fun injectShellKey(keyCode: Int) {
        try {
            Runtime.getRuntime().exec(arrayOf("sh", "-c", "input keyevent $keyCode"))
        } catch (_: Exception) {}
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return super.onKeyDown(keyCode, event)
    }

    override fun onDestroy() {
        stopStatePolling()
        try { discoveryListener?.let { nsdManager?.stopServiceDiscovery(it) } } catch (_: Exception) {}
        super.onDestroy()
    }
}
EOF

# Generate release keystore if not exists
if [ ! -f release.keystore ]; then
    keytool -genkeypair -v -keystore release.keystore -alias vdocast -keyalg RSA -keysize 2048 -validity 10000 -storepass vdocast -keypass vdocast -dname "CN=VDOCast, O=VDOCast, C=US"
fi

gradle wrapper --gradle-version 8.7
./gradlew :app:assembleRelease :tv:assembleRelease

cp app/build/outputs/apk/release/app-release.apk app/build/outputs/apk/release/vdo-remote-release.apk 2>/dev/null || true
cp tv/build/outputs/apk/release/tv-release.apk tv/build/outputs/apk/release/vdo-tv-release.apk 2>/dev/null || true
