#!/usr/bin/env bash
set -euo pipefail

package=com.bjpellegrino.cis400_final
diagnostics=startup-diagnostics
mkdir -p "$diagnostics"

capture_diagnostics() {
  adb shell uiautomator dump /sdcard/pagepal-window.xml >/dev/null || true
  adb pull /sdcard/pagepal-window.xml "$diagnostics/window.xml" || true
  adb exec-out screencap -p > "$diagnostics/screenshot.png" || true
  adb logcat -d -s AndroidRuntime flutter > "$diagnostics/logcat.txt" || true
}
trap capture_diagnostics EXIT

adb shell input keyevent 82
adb install build/app/outputs/flutter-apk/app-debug.apk
adb logcat -c
adb shell am start -W -n "$package/.MainActivity"

for attempt in {1..20}; do
  if adb shell uiautomator dump /sdcard/pagepal-window.xml >/dev/null &&
     adb shell cat /sdcard/pagepal-window.xml > "$diagnostics/window.xml"; then
    if grep -Fq 'Unable to start PagePal' "$diagnostics/window.xml"; then
      echo "PagePal showed its startup error."
      exit 1
    fi
    if grep -Fq 'Log in / Sign up' "$diagnostics/window.xml" &&
       grep -Fq 'Forgot Password' "$diagnostics/window.xml"; then
      echo "PagePal installed, initialized Firebase, and displayed the signed-out login screen."
      exit 0
    fi
  fi
  sleep 2
done

echo "PagePal did not reach the signed-out login screen."
exit 1
