plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sushiapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // ⚙️ Dùng Java 8 để tương thích với plugin qr_code_scanner
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true  // Giữ desugaring để QR hoạt động
    }

    kotlinOptions {
        jvmTarget = "1.8"  // ⚙️ Đồng bộ JVM với Java 8
    }

    defaultConfig {
        applicationId = "com.example.sushiapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
// ✅ Ép toàn project dùng Kotlin JVM 1.8
allprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
        kotlinOptions {
            jvmTarget = "1.8"
        }
    }
}

dependencies {
    // ✅ Bật thư viện desugaring để hỗ trợ Java 8 APIs
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
