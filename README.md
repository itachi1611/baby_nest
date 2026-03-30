# baby_nest

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## CI/CD Setup with Fastlane and GitHub Actions

This project uses Fastlane to automate the build and distribution of three flavors: **dev**, **uat**, and **prod**.

### Flavors and Schemes

- **Android**: Each flavor has a unique `applicationIdSuffix` (`.dev`, `.uat`, or none for prod) and unique app name.
- **iOS**: Uses separate `.xcconfig` files and schemes for each flavor.

### Prerequisites

1. **Firebase**:
   - Create separate Firebase projects/apps for each flavor.
   - Replace the placeholder `google-services.json` in `android/app/src/{flavor}/google-services.json`.
   - Replace the placeholder `GoogleService-Info.plist` in `ios/Firebase/{flavor}/GoogleService-Info.plist`.

2. **Fastlane Match (iOS)**:
   - Create a private Git repository to store your certificates and provisioning profiles.
   - Update `ios/fastlane/Matchfile` with your repository URL.
   - Run `fastlane match init` in the `ios/` directory if you haven't already.

### GitHub Secrets

To enable the automated release workflow (`.github/workflows/release.yml`), add the following secrets to your GitHub repository:

| Secret Name | Description |
| ----------- | ----------- |
| `FIREBASE_ANDROID_APP_ID_DEV` | Firebase App ID for Android (Dev) |
| `FIREBASE_ANDROID_APP_ID_UAT` | Firebase App ID for Android (UAT) |
| `FIREBASE_ANDROID_APP_ID_PROD` | Firebase App ID for Android (Prod) |
| `FIREBASE_IOS_APP_ID_DEV` | Firebase App ID for iOS (Dev) |
| `FIREBASE_IOS_APP_ID_UAT` | Firebase App ID for iOS (UAT) |
| `FIREBASE_IOS_APP_ID_PROD` | Firebase App ID for iOS (Prod) |
| `ANDROID_KEYSTORE_BASE64` | Base64 encoded `.jks` or `.keystore` file |
| `ANDROID_KEYSTORE_PASSWORD` | Password for the keystore |
| `ANDROID_KEYSTORE_ALIAS` | Alias for the key |
| `ANDROID_KEYSTORE_KEY_PASSWORD` | Password for the key |
| `MATCH_PASSWORD` | Password for your Fastlane Match repository |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Basic Auth for your Match Git repo |
| `APP_STORE_CONNECT_API_KEY_JSON` | App Store Connect API Key in JSON format |

### How to Trigger

The workflow is automatically triggered whenever you push or merge a change into the `release` branch.
