
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
   
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
     
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
      
    }

    
    
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type == "com.GBC_TodoList.home" {
            
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let contact = vc.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
            self.window?.rootViewController?.present(contact, animated: true, completion: nil)
            
        } else if shortcutItem.type == "com.GBC_TodoList.newlist" {
//            return
            
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let contact = vc.instantiateViewController(withIdentifier: "Add New Task") as! AddNewTaskViewController
            self.window?.rootViewController?.present(contact, animated: true, completion: nil)
            
        }
        
    }

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "GBC_TodoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

