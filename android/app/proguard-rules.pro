# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep your models and data classes
-keep class com.example.holom_said.models.** { *; }

# Shorebird specific rules (for when we add it later)
-keep class com.shorebirdtech.** { *; }

# Keep Play Core classes
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep Flutter Play Store classes
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Preserve all native method names and the names of their classes
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve all classes that have special meaning to the VM
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}