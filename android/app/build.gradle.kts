import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val signing = Properties()
val signingFile = rootProject.file("key.properties")
if (signingFile.exists()) signingFile.inputStream().use { signing.load(it) }
fun signingValue(env: String, property: String): String? =
    System.getenv(env) ?: signing.getProperty(property)

val storePath = signingValue("ANDROID_KEYSTORE_PATH", "storeFile")
val storePass = signingValue("ANDROID_KEYSTORE_PASSWORD", "storePassword")
val keyAliasValue = signingValue("ANDROID_KEY_ALIAS", "keyAlias")
val keyPass = signingValue("ANDROID_KEY_PASSWORD", "keyPassword")
val hasReleaseKey =
    listOf(storePath, storePass, keyAliasValue, keyPass).all { !it.isNullOrBlank() }

android {
    namespace = "com.deutschbangla"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.deutschbangla"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseKey) {
                storeFile = file(storePath!!)
                storePassword = storePass
                keyAlias = keyAliasValue
                keyPassword = keyPass
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
