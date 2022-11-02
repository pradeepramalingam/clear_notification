package com.pratt.notifications.clear_notification

import android.app.NotificationManager
import android.app.Notification
import android.content.Context
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import android.util.Log ;
import android.service.notification.StatusBarNotification

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ClearNotificationPlugin */
class ClearNotificationPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "clear_notification")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
        return
      }
      "clearAllNotifications" -> {
        val notificationManager = ContextCompat.getSystemService(
          context,
          NotificationManager::class.java
        ) as NotificationManager
        notificationManager.cancelAll()
        result.success(true)
        return
      }
      "clearAndroidNotificationWithIDs" -> {
        val notificationIDs = call.argument<List<Int>>("notificationIDs")
        if (notificationIDs == null) {
          result.error("400", "Bad request", "Notification ID list null")
          return
        }
        else if (notificationIDs.isEmpty()) {
          result.error("400", "Bad request", "Notification ID list empty")
          return
        }

        val notificationManager = ContextCompat.getSystemService(
          context,
          NotificationManager::class.java
        ) as NotificationManager

        for (notiID in notificationIDs) {
          notificationManager.cancel(notiID)
        }
        result.success(true)
        return
      }
      "clearNotificationWithKeyValues" -> {
        val keyToFilter = call.argument<String>("keyToFilter")
        if (keyToFilter == null) {
          result.error("400", "Bad request", "keyToFilter is missing")
          return
        }

        val valueDataType = call.argument<Int>("valueDataType")
        if (valueDataType == null) {
          result.error("400", "Bad request", "valueDataType is missing")
          return
        }

        val tmpValuesToFilter = call.argument<List<String>>("valuesToFilter").guard {
          result.error("400", "Bad request", "valuesToFilter data error!")
          return@guard
        }

        val valuesToFilter = tmpValuesToFilter ?: listOf()
        if (valuesToFilter.isEmpty()) {
          result.error("400", "Bad request", "valuesToFilter list empty")
          return
        }

//        val notifier: NotificationManager =
//          this.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//        val activeNotifications = notifier.activeNotifications

//        for (activeNotification in activeNotifications) {
//          val activeNotificationPayload: HashMap<String, Any> = HashMap()
//          activeNotificationPayload["id"] = activeNotification.id
//          val notification: Notification = activeNotification.notification
//        }

        val notificationManager = ContextCompat.getSystemService(
          context,
          NotificationManager::class.java
        ) as NotificationManager
        val notificationList: Array<StatusBarNotification> = notificationManager.activeNotifications
        Log.i("notificationListCount: ", "${notificationList.size}")
        Log.i("notificationList: ", "${notificationList}")

        for (notificationInfo in notificationList) {
          Log.i("notificationInfo-id: ", "${notificationInfo.getId()}")
          Log.i("notificationInfo-notification: ", "${notificationInfo.getNotification()}")
          Log.i("notificationInfo-notification-desc: ", "${notificationInfo.getNotification().extras}")
          val notificationData: Notification = notificationInfo.notification
          Log.i("notification-data: ", "${notificationData.extras}")
        }
        result.success(false)
        return
      }
      else -> {
        result.error("404", "Method not found", "${call.method.uppercase()} not implemented in Android")
        return
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

inline fun <T> T.guard(block: T.() -> Unit): T {
  if (this == null) block(); return this
}