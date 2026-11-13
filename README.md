# PagePal

PagePal is a Flutter mobile application with Firebase authentication, a profile screen, and Saved/Browser navigation.

## Development setup (modern Flutter)

1. Install **Flutter 3.50.0**, the version used in CI, Android Studio and Android SDK; use **JDK 17** for Android builds.
2. Run `flutter doctor` and resolve toolchain warnings.
3. Run `flutter pub get` (regenerates `pubspec.lock` for the upgraded dependencies).
4. Check that the Firebase project `cis400-final` still exists and that Android/iOS app registrations and authentication/Firestore rules are configured correctly. The committed `firebase_options.dart` points to that original project. If necessary, run `flutterfire configure` and reconfigure the Firebase project you control.
5. Run `flutter run` on an Android emulator or connected device. On macOS, iOS development also requires Xcode and CocoaPods.

If upgrading an old checkout, run `flutter clean` then `flutter pub get` before rebuilding. Existing `pubspec.lock` was generated using the original Dart 2 ecosystem; regenerate it with the current SDK.

The browser and saved screens are currently placeholders in the original codebase, not implemented book-management features. This maintenance branch focuses on making the existing app start and authenticate reliably, and updating its toolchain.

### Limitations and troubleshooting

- If Firebase initialization or login fails, verify that the original Firebase project hasn't been deleted/disabled and that your device has network access.
- Check Android SHA signing fingerprints and enabled sign-in methods in Firebase as required by your authentication setup.
- Test with `flutter analyze` and `flutter run` locally. The Flutter checks workflow builds an Android debug APK and makes it available as a workflow artifact when the build succeeds.
- The release Android build uses debug signing, as in the original project. Set up proper release signing before distribution.
