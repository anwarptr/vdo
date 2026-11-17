# CLAUDE.md

This file provides guidance when working with code in this repository.

## Repository shape: everything lives in `build.sh`

This repo has no checked-in Android source. `build.sh` is the single source of truth: it uses `cat << 'EOF'` heredocs to **generate** the entire Gradle project (settings, root/module `build.gradle.kts`, manifests, XML drawables/resources, Kotlin sources), then creates a Gradle wrapper and builds both Release APKs.

- To change any code, config, or dependency, edit the corresponding heredoc inside `build.sh`. Files under `app/`, `tv/`, `gradle/`, `settings.gradle.kts`, etc. are build outputs and get overwritten on every run.
- Heredocs are quoted (`'EOF'`), so `$` in Kotlin string templates (e.g. `"http://$host:$port/tv"`) is literal and must stay that way; don't switch to unquoted `EOF`.
- If you add a new source file or resource directory, also add its `mkdir -p` (if it's in a new directory) and its own heredoc block.

## Build

```bash
bash build.sh          # generates project, signs, and runs: ./gradlew :app:assembleRelease :tv:assembleRelease
```

Requirements: JDK 17, Android SDK, and a system `gradle` on PATH (the script generates a release keystore and runs `gradle wrapper --gradle-version 8.7` to bootstrap the wrapper). After a first run you can iterate with `./gradlew :app:assembleRelease` or `./gradlew :tv:assembleRelease`, but remember that edits to generated files are lost on the next `build.sh`.

Outputs:
- `app/build/outputs/apk/release/vdo-remote-release.apk`
- `tv/build/outputs/apk/release/vdo-tv-release.apk`

CI (`.github/workflows/build-apk.yml`) runs `bash build.sh` on every push and uploads both Release APKs as the `VDOCast-Release-APKs` artifact. There are no tests or lint configured.

Toolchain pins (in the root `build.gradle.kts` heredoc): AGP 8.5.2, Kotlin 1.9.24, Compose compiler extension 1.5.14 (must stay compatible with the Kotlin version), Compose BOM 2024.09.00, compileSdk/targetSdk 34.

## Architecture: VDO Cast Suite (VDO Remote → VDO TV)

Two Android apps in one Gradle project (`rootProject.name = "VDOCastSuite"`):

### 1. `:app` — VDO Remote (`com.example.lancast`, minSdk 24, Jetpack Compose)
- **Role**: Full-featured mobile TV remote controller & LAN video streaming server with Google TV Soft palette (`#0F131C` velvet slate, `#8AB4F8` periwinkle).
- **Branding & Assets**: Custom adaptive vector launcher icon (`ic_launcher.xml`, smartphone remote in Google TV periwinkle & velvet slate), labeled `VDO Remote`.
- **UI & Controls (`MainActivity.kt`)**:
  - Live Now Playing card with real-time drag-and-seek timeline scrubber (synchronized with TV).
  - Primary media transport cluster (Play/Pause hero button, Skip ±10s, Skip ±30s).
  - **Feature 1: Navigation Cluster**: `🏠 Home` (returns TV to launcher), `↩ Back` (exits menus/popups or returns video to standby), `☰ Menu` (TV OSD), `⚡ Standby` (standby mode).
  - **Feature 2: Dual Controller Modes**: Mode toggle pill between `🔘 D-Pad Wheel` and `👆 Swipe Trackpad` (horizontal swipe seeking, vertical swipe volume, tap to Play/Pause).
  - **Feature 4: Voice Dictation & Search**: Phone speech-to-text button (`🎙️`) using `RecognizerIntent` sending queries straight to TV search fields or `VdoRemoteImeService`.
  - Type on TV keyboard dialog with voice dictation and direct query dispatch.
  - Hardware-style dual rocker capsules (Volume +/− & Seek ±15s).
  - Volume control card (smooth linear slider + mute toggle with active state indicator).
  - Quick action chips: playback speed (0.75x, 1.0x, 1.25x, 1.5x, 2.0x) and aspect ratio (Fit, Fill, Stretch).
  - Network info modal showing phone's Wi-Fi IP and direct connect guidance.
  - Haptic feedback on all remote button taps and gesture swipes.
- **Direct Device Remote (`AdbClient.kt`, `DeviceRemote.kt`)**: `VDO TV App` / `TX3 Direct` toggle on the Remote tab. In TX3 Direct mode the phone talks ADB-over-Wi-Fi (port 5555, RSA key stored in `filesDir/adbkey`) straight to the TV box, so no app is needed on the TV. Buttons become `input keyevent` (D-pad 19–23, Home 3, Back 4, Menu 82, Power 26, Vol 24/25, Mute 164, Play/Pause 85, FF/REW 90/89), and the keyboard/voice use `input text`. Supports manual IP or a /24 scan for open port 5555. One-time setup on the box: enable USB debugging, then accept the "Allow USB debugging?" prompt.
- **Service (`CastServerService.kt`)**:
  - Starts as a foreground media playback service with notification transport controls (Play/Pause, Rewind, FastForward, Stop).
  - Keeps Wi-Fi MulticastLock and WakeLock so casting never drops when screen turns off.
  - NanoHTTPD on **port 5050**, advertised over NSD/mDNS as `_vdocast._tcp.` (`VDOCastPhone`).
  - Endpoints:
    - `/` or `/tv` → Embedded cinema player & ambient display (`TV_HTML`)
    - `/api/state` → JSON `{seq, cmd, val, strVal}` consumed by TV
    - `/api/status` → Real-time playback telemetry received from TV (currentTime, duration, status, volume, muted, speed, aspect, title), reactive Compose state updates
    - `/stream` → Android ContentResolver streaming with HTTP Range support for seeking

### 2. `:tv` — VDO TV (`com.example.lancasttv`, minSdk 21, plain Views + WebView, Leanback)
- **Role**: Big-screen cinema receiver targeting Android TV & TV boxes.
- **Branding & Assets**: Custom cinema TV vector icon and Leanback launcher banner (`tv_banner.xml`, 320x180 dp with bold VDO TV cinema graphics), labeled `VDO TV`.
- **Activity (`TvReceiverActivity.kt`)**:
  - Automatic NSD discovery of `_vdocast._tcp.` (and fallback `_lancast._tcp.`).
  - Fullscreen sticky immersive mode, `FLAG_KEEP_SCREEN_ON` to prevent TV sleep.
  - Hardware Remote Key Listener: Intercepts physical D-pad remotes (IR/Bluetooth) on Android TV boxes (DPAD_CENTER, MEDIA_PLAY_PAUSE, DPAD_LEFT/RIGHT for seeking, UP/DOWN for volume, BACK to standby).
- **Embedded Web Player (`TV_HTML`)**:
  - **Ambient Standby Screen**: Smooth dark glowing backdrop, live digital clock and date, Wi-Fi status pill and connection instructions.
  - **Cinema OSD (On-Screen Display)**: Top title bar, resolution/speed badges, bottom progress bar with buffered range visualization, and timecodes (auto-hides after 3 seconds).
  - **Heads-Up Display (HUD) Alerts**: Floating central toasts for volume changes, seek jumps, speed changes, aspect ratio changes, and play/pause state.
  - **Bidirectional Telemetry**: Automatically posts status back to `/api/status` every 500ms and on media events.

Both apps set `usesCleartextTraffic="true"` because all traffic is plain HTTP on the local network.
