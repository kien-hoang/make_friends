//
//  DatingAppApp.swift
//  DatingApp
//
//  Created by Radley Hoang on 31/10/2021.
//

import SwiftUI
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging

@main
struct DatingAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var viewRouter = ViewRouter()
    
    init() {
        // This init function is didFinishLaunchWithOptions in UIKit
//        RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 1.5) as Date)
        Helper.configureToastView()
        Helper.configureProgressHUD()
        IQKeyboardManager.shared.enable = true
        
        if Helper.getLocalValue(withKey: K.UserDefaults.Token) != nil {
            viewRouter.currentView = .MainAppView
        } else {
            viewRouter.currentView = .LoginView
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewRouter)
                .preferredColorScheme(.light)
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                print("App State : Background")
            case .inactive:
                print("App State : Inactive")
            case .active:
                print("App State : Active")
            @unknown default:
                print("App State : Unknown")
            }
        }
    }
}

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min) // It sets how much Firebase will log. Setting this to min reduces the amount of data you’ll see in your debugger.
        Messaging.messaging().delegate = self
        configApplePush(application)
        
        return true
    }
    
    func configApplePush(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token)")
        }
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    private func handleNotification(_ notification: UNNotification) {
        guard let id = notification.request.content.userInfo["_id"] as? String,
              let imageUrl = notification.request.content.userInfo["image_url"] as? String,
              let likedUserId = notification.request.content.userInfo["liked_user_id"] as? String,
              let likedUserImageUrl = notification.request.content.userInfo["liked_user_image_url"] as? String else { return }
        var params: [String: Any] = [:]
        params["id"] = id
        params["imageUrl"] = imageUrl
        params["likedUserId"] = likedUserId
        params["likedUserImageUrl"] = likedUserImageUrl
        NotificationCenter.default.post(name: .DidGotMatch, object: params)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        handleNotification(notification)
        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
//        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(response.notification)
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        AppData.shared.deviceToken = fcmToken ?? ""
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}
