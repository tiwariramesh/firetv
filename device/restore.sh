#!/bin/sh
set -eu

: "${ANDROID_SERIAL:?Set ANDROID_SERIAL to the verified Fire TV adb serial, for example <fire-tv-ip>:5555}"

ADB="${ADB:-adb}"

for package in \
  com.amazon.kso.blackbird \
  com.amazon.client.metrics.api \
  com.amazon.tv.fw.metrics \
  com.amazon.wirelessmetrics.service \
  com.amazon.perfcollection \
  com.amazon.perfc \
  com.amazon.dp.logger \
  com.amazon.ceviche \
  com.amazon.tv.developer.dataservice \
  com.amazon.tv.acr \
  com.amazon.sneakpeek \
  com.amazon.hybridadidservice \
  com.amazon.tv.easyupgrade \
  com.amazon.shoptv.client \
  com.amazon.shoptv.firetv.client \
  com.amazon.hedwig \
  com.amazon.tv.livetv \
  com.amazon.franktvinput \
  com.amazon.gamehub \
  com.amazon.tv.releasenotes
do
  "$ADB" -s "$ANDROID_SERIAL" shell pm enable --user 0 "$package"
done

disabled=$("$ADB" -s "$ANDROID_SERIAL" shell pm list packages -d)
for package in \
  com.amazon.kso.blackbird \
  com.amazon.client.metrics.api \
  com.amazon.tv.fw.metrics \
  com.amazon.wirelessmetrics.service \
  com.amazon.perfcollection \
  com.amazon.perfc \
  com.amazon.dp.logger \
  com.amazon.ceviche \
  com.amazon.tv.developer.dataservice \
  com.amazon.tv.acr \
  com.amazon.sneakpeek \
  com.amazon.hybridadidservice \
  com.amazon.tv.easyupgrade \
  com.amazon.shoptv.client \
  com.amazon.shoptv.firetv.client \
  com.amazon.hedwig \
  com.amazon.tv.livetv \
  com.amazon.franktvinput \
  com.amazon.gamehub \
  com.amazon.tv.releasenotes
do
  if printf '%s\n' "$disabled" | grep -Fxq "package:$package"; then
    echo "restore verification failed: $package is still disabled" >&2
    exit 1
  fi
done

echo "All session-disabled packages were re-enabled."

