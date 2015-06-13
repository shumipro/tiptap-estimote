//
//  ViewController.swift
//  TiptapEstimote
//

import UIKit

let BEACON_1_UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
let BEACON_1_MAJOR: CLBeaconMajorValue = 42051
let BEACON_1_MINOR: CLBeaconMinorValue = 29428

//let BEACON_2_UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
//let BEACON_2_MAJOR: CLBeaconMajorValue = 52557
//let BEACON_2_MINOR: CLBeaconMinorValue = 31007

let URL_BASE: String = "https://bigtiptap-battlehack.herokuapp.com/"


func isBeacon(beacon: CLBeacon, withUUID UUIDString: String, #major: CLBeaconMajorValue, #minor: CLBeaconMinorValue) -> Bool {
    return beacon.proximityUUID.UUIDString == UUIDString && beacon.major.unsignedShortValue == major && beacon.minor.unsignedShortValue == minor
}

class ViewController: UIViewController, ESTBeaconManagerDelegate, UIWebViewDelegate {

    // beacon
    let beaconManager = ESTBeaconManager()
    let beaconRegion1 = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: BEACON_1_UUID), major: BEACON_1_MAJOR, minor: BEACON_1_MINOR, identifier: "beaconRegion1")
    
    // webview
    var webView: UIWebView = UIWebView()
    var beaconActive:Bool = false
    var currentURL:String = ""
    
    // constants
    let URL_NO_BEACON: String = URL_BASE + "error?isWatching=true"
    let URL_ACTIVE_BEACON: String = URL_BASE + "?isWatching=true"
    
//    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // beacon
        self.beaconManager.delegate = self
        self.beaconManager.returnAllRangedBeaconsAtOnce = true
        self.beaconManager.requestWhenInUseAuthorization()
        
        // initialize webview
        let selfFrame: CGRect = self.view.frame
        self.webView.frame = view.bounds
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        
        // set default page
        self.openWebView(self.URL_NO_BEACON)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion1)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion1)
    }

    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if let currentURL = self.webView.request?.URL?.absoluteString {
            if currentURL != "" && currentURL.rangeOfString("isWatching=true") == nil {
                println("break watching currentURL: " + currentURL)
                return
            }
        }
        if let neareastBeacon = beacons.first as? CLBeacon {
            if isBeacon(neareastBeacon, withUUID: BEACON_1_UUID, major: BEACON_1_MAJOR, minor: BEACON_1_MINOR) {
                // move to webview
                if !self.beaconActive {
                    self.openWebView(self.URL_ACTIVE_BEACON)
                    self.beaconActive = true
                }
            }
        } else {
            // no beacons found, show error page
            if self.beaconActive {
                self.openWebView(self.URL_NO_BEACON)
                self.beaconActive = false
            }
        }
    }

    func beaconManager(manager: AnyObject!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied || status == .Restricted {
            NSLog("Location Services authorization denied, can't range")
        }
    }

    func beaconManager(manager: AnyObject!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        NSLog("Ranging beacons failed for region '%@'\n\nMake sure that Bluetooth and Location Services are on, and that Location Services are allowed for this app. Also note that iOS simulator doesn't support Bluetooth.\n\nThe error was: %@", region.identifier, error);
    }
    
    func openWebView(url: String){
        let requestURL: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
        self.currentURL = url
        self.webView.loadRequest(requestURL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

