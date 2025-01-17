import SwiftUI
import Firebase
import FirebaseFirestore
import UserNotifications
import FirebaseMessaging
import RevenueCat
import FirebaseAnalytics
import GoogleMobileAds
@main
struct BClean_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

class AppDelegate:UIResponder,UIApplicationDelegate,MessagingDelegate, UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){ success, error in
            guard success else {return}
            print("Succes in APN registry")
        }
        application.registerForRemoteNotifications()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [GADSimulatorID]
           
        setup_revenuecat()
        return true
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else{return}
            print("Token : \(token)")
            TokenManager.shared.update(device: token)
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for Apple Remote Notifications")
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("application didFailToRegisterForRemoteNotificationsWithError")
    }
    func setup_revenuecat(){
        Purchases.logLevel = .warn
        Purchases.configure(withAPIKey: "appl_LCdQSthBfzEFOUPrWPxlClbaZbT")
    }
}

class TokenManager: ObservableObject {
    static let shared = TokenManager()
    @Published var device: String?
    private init() {}
    func update(device:String){
        self.device = device
    }
}
