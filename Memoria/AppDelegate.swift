

import UIKit
import SwiftDate


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var vc : UIViewController!
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        Bootstrapper.run()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil))
        let rootViewController = Bootstrapper.container.resolve(NavigationController.self)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        self .navigationBarAppearance()
        

        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            let beaconIdentifier = IBeaconIdentifier(uuid: "124", major: "123", minor: "123")
            let date = Date() - 3.hours
            _ = Task(taskName: "להוציא את הכלב", taskTime: date, taskVoiceURL: URL(string: "www.google.com")!, taskBeaconIdentifier: beaconIdentifier, taskTimePriorityHi: true)
            
//            self.vc = Bootstrapper.container.resolve(TaskNotificationPopUp.self, argument: task)
//            self.vc = Bootstrapper.container.resolve(TaskVerificationPopUp.self, argument: task)
//            self.vc = Bootstrapper.container.resolve(TaskWarningPopUp.self, argument: task)
            
//            rootViewController!.presentViewController(self.vc, animated: true, completion: nil)
            
        }

        return true
    }
    
    func navigationBarAppearance() {
        let image = UIImage(named: "navigationBar")
        let navigationBarBackgroundImage = image
        UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: UIBarMetrics.default)
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("Did recive task notification at time")
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.TaskTimeNotification), object: notification)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

