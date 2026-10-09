# Firebase
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.firebase.** { *; }
-keep class com.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# flutter_local_notifications
-keep class com.dexterous.** { *; }
-keepattributes *Annotation*

# Riverpod
-keep class org.jetbrains.annotations.** { *; }

# PostHog
-keep class com.posthog.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# General
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Play Core (referenced optionally by Flutter engine, not bundled)
-dontwarn com.google.android.play.core.**
