# Continue the AFTKA Fire TV project on macOS

Paste the block under **Codex handoff prompt** into a new Codex conversation after cloning this repository.

## Repository state

- Upstream: `https://github.com/Gathin23/cleanyourtv.git`
- Upstream commit used as the base: `718f98c96e6823045fd1fd82edd73d70deaf01fa`
- Target device: Amazon Fire TV Stick 4K Max, first generation (`AFTKA`, `kara`)
- Fire OS 7.7.1.3 / Android 9 / API 28, build `PS7713.5443N`
- Amazon Home must remain installed and enabled.
- No device serial, MAC address, account, Wi-Fi name, ADB key, public IP, screenshot or backup is stored here.

The customizations already present in this branch are:

- Six-app dock: Skyglass, Moviebox Pro, Stremio, YouTube, Prime Video and RBTV.
- Greeting: **Ramesh & Aasma**.
- Wilson, Western Australia coordinates for the offline sun/sky calculation.
- Dark dynamic sky, cinematic shelf, frosted-glass dock, spring/glass focus and app-colour glow.
- App library, tile management and a NordVPN status pill.
- Weather add-on: Celsius, seven forecast days, humidity, wind and AQI.

The three customized files are:

- `launcher/app/src/main/res/values/config.xml`
- `themes/glass/config.json`
- `addons/weather/app/src/main/res/values/options.xml`

## Device state already verified

Twenty Amazon packages were disabled reversibly with `pm disable-user --user 0`; see
[`device/debloat.txt`](device/debloat.txt). They remained disabled after a controlled reboot. Amazon Home,
Alexa, Wi-Fi, Appstore, Prime Video and the required third-party apps returned and worked.

`com.android.nfc` was already disabled before this work and is not part of the session restore list.

Required installed apps and package names:

| App | Package |
|---|---|
| Skyglass | `com.equiptv.xciptvskyglas` |
| Moviebox Pro | `com.movieboxpro.androidtv` |
| Stremio | `com.stremio.one` |
| NordVPN | `com.nordvpn.android` |
| YouTube | `com.amazon.firetv.youtube` |
| RBTV | `com.rblive.app` |
| Prime Video | `com.amazon.firebat` |
| Downloader | `com.esaba.downloader` |
| Amazon Appstore | `com.amazon.venezia` |

Alexa was tested by temporarily disabling `com.amazon.vizzini`. The microphone button became inert without
breaking normal navigation. It was then re-enabled and must stay enabled because app voice search is required.
Do not disable `vizzini`, `aria`, `tcomm`, Ivona TTS, Alexa datastore or the directive broker.

NordVPN remained installed after reboot but its tunnel did not reconnect at the verification point. Review
NordVPN's own auto-connect/Always-on setting; do not treat that as a debloat failure.

## Skyglass startup finding

The reported automatic Skyglass launch was not reproduced during a controlled reboot:

- Fire OS started FallbackHome and then Amazon Home.
- Skyglass does not claim `HOME`.
- It had no running service or alarm.
- Its `BOOT_COMPLETED` receiver is AndroidX WorkManager's generic rescheduler.
- No boot event launched Skyglass.

The likely distinction is full reboot versus sleep/wake resume, or an internal Skyglass setting. Return to Home
before sleep, wake once, and compare with a real reboot. Inspect Skyglass for “start on boot”, “launch on startup”
or “resume playback”. Do not disable WorkManager components without stronger evidence.

## Build on macOS

Install JDK 17 and Android SDK platform/build tools 34 from official sources. The projects require:

- JDK 17
- Android SDK platform 34
- Android build-tools 34.0.0

Build and test from source:

```sh
cd launcher
./gradlew --no-daemon testReleaseUnitTest lintRelease assembleRelease
cd ../addons/weather
./gradlew --no-daemon testReleaseUnitTest lintRelease assembleRelease
```

Do not use prebuilt third-party APKs. Keep the launcher release APK below the repository's size gate.

## Safe installation order

1. Verify the current Fire TV IP and connect with official `adb`; never scan the LAN.
2. Confirm the model/build and compare `pm list packages -d` with `device/debloat.txt`.
3. Install the launcher APK as an ordinary app first.
4. Start it explicitly with `am start -W -n com.gathin.tvhome/.MainActivity`.
5. Do **not** disable `com.amazon.tv.launcher`.
6. Test every D-pad edge, Back, Settings, Appstore, all dock apps, the app library and NordVPN pill.
7. Install the weather add-on, open it, choose **Wilson, Western Australia**, and test the seven-day forecast.
8. Apply the customized `themes/glass` theme and inspect screenshots pulled from the TV.
9. Only then prepare a separate, reversible Fire TV Home-button redirect experiment.
10. Test the physical remote: injected Home is not proof. Test tap, rapid taps, long press, held volume, Alexa and reboot.
11. Keep Amazon Home as the fail-safe and write the redirect removal commands before enabling it.
12. When finished, turn ADB debugging off and verify port 5555 is closed.

Fire OS normally refuses standard HOME handover. A successful `set-home-activity` message is not proof. Existing
redirect approaches use an accessibility/Home watcher and have shown cases where injected Home passed but the
physical Fire TV remote later opened Amazon Home. Treat the redirect as experimental.

## Codex handoff prompt

```text
Continue this Fire TV Stick 4K Max project from the checked-out repository. Read AGENTS.md and
CONTINUE_ON_MAC.md completely before acting. The customized launcher/theme/weather files are already in the
working tree. Work on the real AFTKA/kara Fire OS 7.7.1.3 device carefully and reversibly.

First verify the current device IP, ADB identity, build, HOME owner and disabled-package list. Do not scan the LAN.
Do not uninstall packages, use root, disable Amazon Home, disable OTA/recovery, or change Alexa voice components.
Preserve every required app listed in CONTINUE_ON_MAC.md.

Install official JDK 17 and Android SDK platform/build-tools 34 if absent. Build the launcher and weather add-on
from source, run their unit tests and lint, and report APK sizes. Install the launcher only as an ordinary app and
launch it explicitly before discussing Home redirection. Install and configure the weather add-on for Wilson,
Western Australia. Apply the customized glass theme. Verify the UI with TV screenshots and the physical remote.

After the ordinary-app UI passes, present an exact reversible plan for an experimental Fire TV Home-button
redirect. Keep com.amazon.tv.launcher installed and enabled. Do not enable an accessibility watcher until its
permissions, source revision, physical-remote tests and complete removal steps have been shown and approved.

CURRENT DEVICE CONNECTION
- Fire TV IP: 192.168.1.109
- ADB endpoint: 192.168.1.109:5555
- ADB debugging is enabled
- This Mac may require a new “Allow USB debugging?” confirmation on the TV
- Verify the IP in Settings > My Fire TV > About > Network before connecting because DHCP may change it
- Device: Fire TV Stick 4K Max, 1st generation
- Reported model: AFTKA
- Device codename: kara
- Fire OS: 7.7.1.3
- Build: PS7713.5443N
- Android: 9 / API 28
- Fire TV Home: com.amazon.tv.launcher/.ui.HomeActivity_vNext
- The OTG hub has an Ethernet adapter, but the previous Android network inspection showed the active connection as Wi-Fi/wlan0

Also continue the Skyglass diagnosis by distinguishing full reboot from sleep/wake resume; do not disable its
generic WorkManager receiver without evidence. At completion, provide build/install/restore documentation and
close ADB port 5555 after debugging is turned off.
```

