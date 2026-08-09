plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "rs.salarycurrencypro.salary_currency_pro"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications (added for PROMPT-003 Stage B item 7)
        // requires core library desugaring — see its README's Kotlin DSL
        // setup snippet, matched here.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "rs.salarycurrencypro.salary_currency_pro"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    // PROMPT-003J checkpoint 1: dev/prod build matrix. `dev` is for
    // owner/local QA only — distinct application ID (via suffix, so it
    // installs side-by-side with a real prod install on the same phone
    // rather than overwriting it) and distinct label/icon (see
    // src/dev/res/) so it can never be mistaken for production. `prod` is
    // production-equivalent QA and the eventual Play release; its
    // applicationId is deliberately unchanged from before this flavor
    // split so it matches whatever, if anything, is already installed
    // from earlier sessions.
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
        }
        create("prod") {
            dimension = "environment"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
    // Per-ABI splitting is handled by `flutter build apk --split-per-abi`
    // (raw APK distribution) or automatically by Play Store's App Bundle
    // delivery for `flutter build appbundle` (the actual Play Store
    // artifact) — a manual `splits { abi {...} }` block here conflicts
    // with the Flutter Gradle plugin's own NDK abiFilters management
    // ("Conflicting configuration ... ndk abiFilters cannot be present
    // when splits abi filters are set", confirmed by an actual failed
    // build attempt this session).
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
