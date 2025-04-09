plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.jjbic.inventorymanagement"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.jjbic.inventorymanagement"
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        minSdk = 23
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

     kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    buildToolsVersion = "36.0.0"
}

dependencies {
        implementation(platform("com.google.firebase:firebase-bom:33.11.0"))
        implementation("com.google.firebase:firebase-analytics")
    }

flutter {
    source = "../.."
}

apply(plugin = "com.google.gms.google-services")
