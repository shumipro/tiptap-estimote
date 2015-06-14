//
//  AppDelegate.swift
//  TiptapEstimote
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    let beaconManager = ESTBeaconManager()
    var viewController: ViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.viewController = ViewController()
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()

        // estimote setup
        ESTCloudManager.setupAppID("tiptap-estimote", andAppToken: "deb74379a8a4da9e5112749b5a5fdcf0")
        
//        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert, categories: nil))
//        
//        beaconManager.delegate = self
//        beaconManager.requestAlwaysAuthorization()
//        
//        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), major: 42051, minor: 29428, identifier: "blue beacon")
//        beaconManager.startMonitoringForRegion(region)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if let fullPath = url.absoluteString {
            // tiptap:// -> 9
            var redirectURL = (fullPath as NSString).substringFromIndex(9)
            println("custom scheme redirect: " + redirectURL)
            self.viewController?.loadWebView("https://" + redirectURL)
        }
        return true
    }


}

