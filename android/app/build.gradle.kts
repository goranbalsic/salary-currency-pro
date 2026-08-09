import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// PROMPT-003J checkpoint 4: real release-signing scaffold. Reads
// android/key.properties if present (never committed — see .gitignore's
// existing `android/key.properties`/`*.jks`/`*.keystore` entries, already
// in place before this checkpoint). Falls back to null when absent so
// `flutter build`/`flutter run --release` keep working exactly as before
// for anyone without a real keystore yet — see the release buildType's
// own signingConfig selection below for the actual fallback-to-debug
// behavior. No real signing secret is read, generated, or touched by
// this environment; the owner runs `keytool` themselves (see
// PROJECT_CONTEXT.md's release-signing section for the exact command)
// and drops the resulting keystore + key.properties in place locally.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasRealSigningConfig = keystorePropertiesFile.exists()
if (hasRealSigningConfig) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
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

    signingConfigs {
        if (hasRealSigningConfig) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // Real signing once android/key.properties exists (see the
            // scaffold above); until then, falls back to the debug keys
            // so `flutter build`/`flutter run --release` keep working —
            // this fallback is exactly why every release artifact built
            // in this environment is explicitly disclosed as debug-signed
            // rather than upload-ready (see DECISIONS.md D-034).
            signingConfig = if (hasRealSigningConfig) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
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
