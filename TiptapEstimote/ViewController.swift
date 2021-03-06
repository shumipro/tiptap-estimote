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
    var URL_NO_BEACON: String = URL_BASE
    var URL_ACTIVE_BEACON: String = URL_BASE + "#/?isPerformer=true"
    
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
        self.loadWebView(self.URL_NO_BEACON)
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
//            if currentURL != "" && currentURL.rangeOfString("#top") == nil {
              if currentURL != ""  {
//                println("break watching currentURL: " + currentURL)
                return
            }
        }
        if let neareastBeacon = beacons.first as? CLBeacon {
            if isBeacon(neareastBeacon, withUUID: BEACON_1_UUID, major: BEACON_1_MAJOR, minor: BEACON_1_MINOR) {
                // move to webview
                if !self.beaconActive {
                    self.loadWebView(self.URL_ACTIVE_BEACON + "&major_id=" + String(BEACON_1_MAJOR) + "&minor_id=" + String(BEACON_1_MINOR))
                    self.beaconActive = true
                }
            }
        } else {
            // no beacons found, show error page
            if self.beaconActive {
                self.loadWebView(self.URL_NO_BEACON)
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
    
    func loadWebView(url: String){
        let requestURL: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
        self.currentURL = url
        self.webView.loadRequest(requestURL)
        println("load: " + url)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func openSafari(url: NSURL) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if navigationType == UIWebViewNavigationType.LinkClicked {
        if navigationType == UIWebViewNavigationType.Other {
            println(request.URL?.host)
            if request.URL?.host! == "www.sandbox.paypal.com" {
                self.openSafari(request.URL!)
                return false
            }
        }
        return true
    }

    func webViewDidStartLoad(webView: UIWebView) {
        self.view.makeToastActivity()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
          self.view.hideToastActivity()
    }
}

