
import Foundation
import Swinject
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class Bootstrapper {
    static var mainApplicationContainer = Container()
    static var loginContainer = Container()
    
    static func onApplicationFirstLoad() {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        AssemblyLogin.run(self.loginContainer)
        ServiceLocator.loginContainer = self.loginContainer
        
        let rootViewController = Bootstrapper.loginContainer.resolve(RootViewController.self)!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = rootViewController
        appDelegate.window?.makeKeyAndVisible()
        
        self.setServiceLocator()
    }
    
    static func showLogin() {
        let rootViewController = Bootstrapper.loginContainer.resolve(RootViewController.self)!
        rootViewController.presentLogIn()
    }

    class func logout() {
        self.mainApplicationContainer.removeAll()
        self.mainApplicationContainer = Container()
        self.showLogin()
    }

    class func loadMainApplication() {
        AssemblyMainApplicationModel.run(self.loginContainer, mainApplicationContainer: self.mainApplicationContainer)
        AssemblyMainApplicationUI.run(self.mainApplicationContainer)
        let _ = self.mainApplicationContainer.resolve(UINotificationActionsExecuter.self)
        let _ = self.mainApplicationContainer.resolve(NearableStriggerManager.self)
        let _ = self.mainApplicationContainer.resolve(NearableLocator.self)
        self.setServiceLocator()
        let rootViewController = Bootstrapper.loginContainer.resolve(RootViewController.self)!
        rootViewController.presentMainApplication()
    }

    class func setServiceLocator() {
        ServiceLocator.mainApplicationContainer = self.mainApplicationContainer
        ServiceLocator.loginContainer = self.loginContainer
    }

}
