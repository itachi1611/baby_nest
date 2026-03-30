# Baby Nest

## A Flutter project for tracking baby feeding, using Firebase Realtime Database and following a repository pattern.

This project is built to help parents track their baby's feeding habits with ease. It features a clean architecture, reactive UI, and robust data visualization.

- Using Firebase Realtime Database for data storage.
- Using fl_chart for data visualization.
- Following repository pattern for data management.
- Multi-flavor support for Dev, UAT, and Prod.

## Installation

This repository requires [Flutter](https://flutter.dev/docs/get-started/install) to be installed and present in your development environment.

1. Clone the project and enter the project folder.

    ```sh
    git clone <repository_url>
    cd baby_nest
    ```

2. Get the dependencies.

    ```sh
    flutter pub get
    ```

3. Run the app via command line or through your development environment.

    ```sh
    # Run with a specific flavor
    flutter run --flavor dev -t lib/main.dart
    ```

## Pub packages

This repository makes use of the following pub packages:

| Package                                                              | Usage                                                |
|----------------------------------------------------------------------|------------------------------------------------------|
| [Intl](https://pub.dev/packages/intl)                                | Internationalization and date formatting             |
| [Animations](https://pub.dev/packages/animations)                    | Pre-built animations collection                      |
| [Gap](https://pub.dev/packages/gap)                                  | Easy spacing between widgets                         |
| [Package Info Plus](https://pub.dev/packages/package_info_plus)      | Application environment and flavor detection         |
| [Logger](https://pub.dev/packages/logger)                            | Custom logger for debugging                          |
| [Google Fonts](https://pub.dev/packages/google_fonts)                | High-quality fonts from Google                       |
| [Go Router](https://pub.dev/packages/go_router)                      | Declarative routing and navigation                   |
| [Firebase Core](https://pub.dev/packages/firebase_core)              | Core Firebase integration                            |
| [Firebase Database](https://pub.dev/packages/firebase_database)      | Real-time NoSQL cloud database                       |
| [Sticky Headers](https://pub.dev/packages/sticky_headers)            | Sticky headers for scrollable lists                  |
| [FL Chart](https://pub.dev/packages/fl_chart)                        | Powerful Flutter chart library                       |

## Changing the package and app name

To change the package name, you can use the `change_app_package_name` package or manually update the flavor configurations in `android/app/build.gradle` and iOS `.xcconfig` files.

## Note

After following the installation steps you can customize your project.

1. Theme

   _You can customize your brand colors in the [lib/common/app_theme.dart](./lib/common/app_theme.dart) file._

2. Firebase
   ```shell
   # Install the CLI if not already done so
   dart pub global activate flutterfire_cli

   # Run the `configure` command, select a Firebase project and platforms
   flutterfire configure
   ```

## Commands

#### Get the dependencies

```shell
flutter pub get
```

#### Clear the cache

```shell
flutter pub cache clean
flutter pub cache repair
```

#### For iOS only

##### Mac ARM

```shell
1. sudo arch -x86_64 gem install ffi
2. sudo arch -x86_64 pod install
```

##### Mac Intel

```shell
pod install
```

## CI/CD Setup with Fastlane and GitHub Actions

This project uses Fastlane to automate the build and distribution of three flavors: **dev**, **uat**, and **prod**.

### Flavors and Schemes

- **Android**: Each flavor has a unique `applicationIdSuffix` (`.dev`, `.uat`, or none for prod) and unique app name defined in `android/app/build.gradle`.
- **iOS**: Uses separate `.xcconfig` files (`Dev.xcconfig`, `Uat.xcconfig`, `Prod.xcconfig`) and schemes for each flavor.

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

## License

MIT
