import Flutter
import UIKit

public class SwiftClearNotificationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clear_notification", binaryMessenger: registrar.messenger())
    let instance = SwiftClearNotificationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let notificationCenter = UNUserNotificationCenter.current()

    switch call.method {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break
      case "clearAllNotifications":
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        result(true)
        break
      case "clearIOSNotificationWithIDs":
        guard let args = call.arguments as? [String : Any] else {
            result(
              FlutterError(
                code: "400",
                message: "Bad request",
                details: "Missing arguments"
              )
            )
            return
        }
        guard let notificationIDsList = args["notificationIDs"] as? [String] else {
            result(
              FlutterError(
                code: "400",
                message: "Bad request",
                details: "Notification ID list nil"
              )
            )
            return
        }
        if notificationIDsList.count == 0 {
            result(
              FlutterError(
                code: "400",
                message: "Bad request",
                details: "Notification ID list empty"
              )
            )
            return
        }
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIDsList)
        notificationCenter.removeDeliveredNotifications(withIdentifiers: notificationIDsList)
        notificationCenter.getDeliveredNotifications { notificationInfoList in
            UIApplication.shared.applicationIconBadgeNumber = notificationInfoList.count
        }
        result(true)
        break
      case "clearNotificationWithKeyValues":
        guard let args = call.arguments as? [String : Any] else {
            result(
              FlutterError(
                code: "400",
                message: "Bad request",
                details: "Missing arguments"
              )
            )
            return
        }
        guard let keyToFilter = args["keyToFilter"] as? String else {
            result(
              FlutterError(
                code: "400",
                message: "Bad request",
                details: "keyToFilter is missing"
              )
            )
            return
        }

        guard let valueDataType = args["valueDataType"] as? Int else {
            result(
              FlutterError(
                code: "400",
                message: "Bad request",
                details: "valueDataType is missing"
              )
            )
            return
        }
        
        var valuesToFilter: [Any] = []
        if valueDataType == 0 {
            guard let tmpValuesToFilter = args["valuesToFilter"] as? [Int] else {
                result(
                  FlutterError(
                    code: "400",
                    message: "Bad request",
                    details: "valuesToFilter data type missmatch! Expected Int type!"
                  )
                )
                return
            }
            valuesToFilter = tmpValuesToFilter
        }
        else {
            guard let tmpValuesToFilter = args["valuesToFilter"] as? [String] else {
                result(
                  FlutterError(
                    code: "400",
                    message: "Bad request",
                    details: "valuesToFilter data type missmatch! Expected String type!"
                  )
                )
                return
            }
            valuesToFilter = tmpValuesToFilter
        }
        
        if valuesToFilter.count == 0 {
            result(
              FlutterError(
                code: "400",
                message: "Bad request",
                details: "valuesToFilter list empty"
              )
            )
            return
        }
        
        if let valuesToClear = valuesToFilter as? [String] {
            self.removePendingNotifications(apsKeyToCompare: keyToFilter, valueList: valuesToClear)
        }
        else if let valuesToClear = valuesToFilter as? [Int] {
            self.removePendingNotifications(apsKeyToCompare: keyToFilter, valueList: valuesToClear)
        }
        else {
            result(false)
            return
        }
        result(true)
        break
      default:
        result(
          FlutterError(
            code: "404",
            message: "Method not found",
            details: "\(call.method.uppercased()) not implemented in iOS"
          )
        )
        break
    }
  }
    
    func removePendingNotifications(apsKeyToCompare: String, valueList: [String]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { pendingNotificationRequests in
            var notificationsIDList: [String] = []
            for pendingNotificationInfo in pendingNotificationRequests {
                if let notificationTOGroupID = pendingNotificationInfo.content.userInfo[apsKeyToCompare] as? String, valueList.contains(notificationTOGroupID) {
                    notificationsIDList.append(pendingNotificationInfo.identifier)
                }
            }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationsIDList)
            self.removeDeliveredNotifications(apsKeyToCompare: apsKeyToCompare, valueList: valueList)
        }
    }

    func removeDeliveredNotifications(apsKeyToCompare: String, valueList: [String]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getDeliveredNotifications { deliveredNotificationList in
            var notificationsIDList: [String] = []
            for deliveredNotificationInfo in deliveredNotificationList {
                if let notificationTOGroupID = deliveredNotificationInfo.request.content.userInfo[apsKeyToCompare] as? String, valueList.contains(notificationTOGroupID) {
                    notificationsIDList.append(deliveredNotificationInfo.request.identifier)
                }
            }
            notificationCenter.removeDeliveredNotifications(withIdentifiers: notificationsIDList)
        }
    }
    
    func removePendingNotifications(apsKeyToCompare: String, valueList: [Int]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { pendingNotificationRequests in
            var notificationsIDList: [String] = []
            for pendingNotificationInfo in pendingNotificationRequests {
                if let notificationTOGroupID = pendingNotificationInfo.content.userInfo[apsKeyToCompare] as? Int, valueList.contains(notificationTOGroupID) {
                    notificationsIDList.append(pendingNotificationInfo.identifier)
                }
            }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationsIDList)
            self.removeDeliveredNotifications(apsKeyToCompare: apsKeyToCompare, valueList: valueList)
        }
    }

    func removeDeliveredNotifications(apsKeyToCompare: String, valueList: [Int]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getDeliveredNotifications { deliveredNotificationList in
            var notificationsIDList: [String] = []
            for deliveredNotificationInfo in deliveredNotificationList {
                if let notificationTOGroupID = deliveredNotificationInfo.request.content.userInfo[apsKeyToCompare] as? Int, valueList.contains(notificationTOGroupID) {
                    notificationsIDList.append(deliveredNotificationInfo.request.identifier)
                }
            }
            notificationCenter.removeDeliveredNotifications(withIdentifiers: notificationsIDList)
        }
    }

}
