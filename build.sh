#!/usr/bin/env bash
set -e

mkdir -p app/src/main/java/com/example/lancast
mkdir -p gradle/wrapper

cat << 'EOF' > settings.gradle.kts
pluginManagement {
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories { google(); mavenCentral() }
}
rootProject.name = "LanCastTV"
include(":app")
EOF

cat << 'EOF' > build.gradle.kts
plugins {
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}
EOF

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
        versionCode = 1
        versionName = "1.0"
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
    implementation("androidx.compose.material3:material3")
}
EOF

cat << 'EOF' > app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <application
        android:label="LanCast TV"
        android:usesCleartextTraffic="true"
        android:theme="@android:style/Theme.Material.NoActionBar">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            <!-- Allows sharing any video directly from Gallery/Files/WhatsApp to TV -->
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
import android.app.Service
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import fi.iki.elonen.NanoHTTPD
import org.json.JSONObject
import java.io.FileInputStream
import java.util.concurrent.atomic.AtomicInteger

class CastServerService : Service() {

    companion object {
        var currentVideoUri: Uri? = null
        var lastCommand: String = ""
        var lastValue: Double = 0.0
        val seq = AtomicInteger(0)

        fun pushCommand(cmd: String, value: Double = 0.0) {
            lastCommand = cmd
            lastValue = value
            seq.incrementAndGet()
        }
    }

    private var server: VideoHttpServer? = null

    override fun onCreate() {
        super.onCreate()
        startForegroundNotification()
        server = VideoHttpServer(5050).apply { start(NanoHTTPD.SOCKET_READ_TIMEOUT, false) }
    }

    override fun onDestroy() {
        server?.stop()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startForegroundNotification() {
        val channelId = "lancast_server"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, "LanCast Streaming", NotificationManager.IMPORTANCE_LOW)
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("LanCast TV Active")
            .setContentText("Streaming video to your TX3 Mini browser")
            .setSmallIcon(android.R.drawable.ic_media_play)
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
                    }
                    newFixedLengthResponse(Response.Status.OK, "application/json", json.toString())
                }
                "/stream" -> streamCurrentVideo(session)
                else -> newFixedLengthResponse(Response.Status.NOT_FOUND, "text/plain", "Not Found")
            }
        }

        private fun streamCurrentVideo(session: IHTTPSession): Response {
            val uri = currentVideoUri ?: return newFixedLengthResponse(Response.Status.NOT_FOUND, "text/plain", "No video")
            val mime = contentResolver.getType(uri) ?: "video/mp4"
            val pfd = contentResolver.openFileDescriptor(uri, "r")
                ?: return newFixedLengthResponse(Response.Status.INTERNAL_ERROR, "text/plain", "Cannot open")

            val fileSize = pfd.statSize
            val rangeHeader = session.headers["range"]

            return if (rangeHeader != null && rangeHeader.startsWith("bytes=")) {
                val parts = rangeHeader.removePrefix("bytes=").split("-")
                val start = parts[0].toLongOrNull() ?: 0L
                val end = if (parts.size > 1 && parts[1].isNotEmpty()) parts[1].toLong() else fileSize - 1
                val length = (end - start) + 1
                val fis = FileInputStream(pfd.fileDescriptor)
                fis.channel.position(start)
                newFixedLengthResponse(Response.Status.PARTIAL_CONTENT, mime, fis, length).apply {
                    addHeader("Accept-Ranges", "bytes")
                    addHeader("Content-Range", "bytes $start-$end/$fileSize")
                    addHeader("Content-Length", length.toString())
                }
            } else {
                val fis = FileInputStream(pfd.fileDescriptor)
                newFixedLengthResponse(Response.Status.OK, mime, fis, fileSize).apply {
                    addHeader("Accept-Ranges", "bytes")
                    addHeader("Content-Length", fileSize.toString())
                }
            }
        }
    }

    private val TV_HTML = """
        <!DOCTYPE html>
        <html><head><meta charset="utf-8"><title>TX3 Mini TV</title>
        <style>
          *{margin:0;padding:0;box-sizing:border-box}
          body{background:#000;color:#fff;font-family:system-ui,sans-serif;height:100vh;display:flex;align-items:center;justify-content:center;overflow:hidden}
          video{width:100vw;height:100vh;object-fit:contain;display:none}
          #idle{text-align:center} h1{color:#38bdf8;margin-bottom:10px}
        </style></head><body>
        <div id="idle"><h1>TX3 Mini Connected</h1><p>Select or Share any video on your phone to play.</p></div>
        <video id="v" controls autoplay playsinline></video>
        <script>
        const v = document.getElementById('v'), idle = document.getElementById('idle');
        let lastSeq = 0;
        setInterval(async () => {
          try {
            const r = await fetch('/api/state'); const s = await r.json();
            if (s.seq === lastSeq) return;
            lastSeq = s.seq;
            if (s.cmd === 'load') {
              idle.style.display = 'none'; v.style.display = 'block';
              v.src = '/stream?t=' + s.seq;
              v.play().catch(()=>{});
            } else if (s.cmd === 'toggle') { v.paused ? v.play() : v.pause(); }
            else if (s.cmd === 'seek') { v.currentTime = Math.max(0, v.currentTime + (s.val||0)); }
            else if (s.cmd === 'mute') { v.muted = !v.muted; }
          } catch(e){}
        }, 500);
        </script></body></html>
    """.trimIndent()
}
EOF

cat << 'EOF' > app/src/main/java/com/example/lancast/MainActivity.kt
package com.example.lancast

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import java.net.Inet4Address
import java.net.NetworkInterface

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val serviceIntent = Intent(this, CastServerService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(serviceIntent)
        else startService(serviceIntent)

        // Handle "Share -> LanCast TV" from Gallery / File Manager / WhatsApp
        val sharedUri: Uri? = if (intent?.action == Intent.ACTION_SEND) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.getParcelableExtra(Intent.EXTRA_STREAM)
            }
        } else null

        if (sharedUri != null) {
            CastServerService.currentVideoUri = sharedUri
            CastServerService.pushCommand("load")
        }

        setContent {
            MaterialTheme(colorScheme = darkColorScheme()) {
                Surface(modifier = Modifier.fillMaxSize()) {
                    LanCastScreen(ipAddress = getLocalIpAddress(), initialUri = sharedUri)
                }
            }
        }
    }

    private fun getLocalIpAddress(): String {
        val interfaces = NetworkInterface.getNetworkInterfaces() ?: return "127.0.0.1"
        for (intf in interfaces) {
            for (addr in intf.inetAddresses) {
                if (!addr.isLoopbackAddress && addr is Inet4Address) return addr.hostAddress ?: "127.0.0.1"
            }
        }
        return "127.0.0.1"
    }
}

@Composable
fun LanCastScreen(ipAddress: String, initialUri: Uri?) {
    var selectedUri by remember { mutableStateOf(initialUri ?: CastServerService.currentVideoUri) }

    val picker = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.PickVisualMedia()
    ) { uri ->
        if (uri != null) {
            selectedUri = uri
            CastServerService.currentVideoUri = uri
            CastServerService.pushCommand("load")
        }
    }

    Column(
        modifier = Modifier.fillMaxSize().padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text("LanCast TV", style = MaterialTheme.typography.headlineMedium)

        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("Open on TX3 Mini Browser:", style = MaterialTheme.typography.titleSmall)
                Spacer(Modifier.height(6.dp))
                Text("http://$ipAddress:5050", style = MaterialTheme.typography.headlineSmall, color = MaterialTheme.colorScheme.primary)
            }
        }

        Button(
            onClick = { picker.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.VideoOnly)) },
            modifier = Modifier.fillMaxWidth().height(54.dp)
        ) {
            Text(if (selectedUri == null) "Select Video to Cast" else "Change Video")
        }

        if (selectedUri != null) {
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    Text("TV Remote Controls", style = MaterialTheme.typography.titleSmall)
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedButton(onClick = { CastServerService.pushCommand("seek", -15.0) }, modifier = Modifier.weight(1f)) { Text("-15s") }
                        Button(onClick = { CastServerService.pushCommand("toggle") }, modifier = Modifier.weight(1.3f)) { Text("Play / Pause") }
                        OutlinedButton(onClick = { CastServerService.pushCommand("seek", 15.0) }, modifier = Modifier.weight(1f)) { Text("+15s") }
                    }
                    OutlinedButton(onClick = { CastServerService.pushCommand("mute") }, modifier = Modifier.fillMaxWidth()) { Text("Mute / Unmute TV") }
                }
            }
        }
    }
}
EOF

gradle wrapper --gradle-version 8.7
./gradlew assembleDebug
