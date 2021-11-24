import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func applicationWillTerminate(_ application: UIApplication) {
        FinanceStorageManager.shared.saveContext()
    }
    
}

