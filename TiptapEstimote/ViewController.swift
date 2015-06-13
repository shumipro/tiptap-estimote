//
//  ViewController.swift
//  TiptapEstimote
//

import UIKit

let BEACON_1_UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
let BEACON_1_MAJOR: CLBeaconMajorValue = 42051
let BEACON_1_MINOR: CLBeaconMinorValue = 29428

let BEACON_2_UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
let BEACON_2_MAJOR: CLBeaconMajorValue = 52557
let BEACON_2_MINOR: CLBeaconMinorValue = 31007

func isBeacon(beacon: CLBeacon, withUUID UUIDString: String, #major: CLBeaconMajorValue, #minor: CLBeaconMinorValue) -> Bool {
    return beacon.proximityUUID.UUIDString == UUIDString && beacon.major.unsignedShortValue == major && beacon.minor.unsignedShortValue == minor
}

class ViewController: UIViewController, ESTBeaconManagerDelegate {

    let beaconManager = ESTBeaconManager()

    let beaconRegion1 = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: BEACON_1_UUID), major: BEACON_1_MAJOR, minor: BEACON_1_MINOR, identifier: "beaconRegion1")
    let beaconRegion2 = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: BEACON_2_UUID), major: BEACON_2_MAJOR, minor: BEACON_2_MINOR, identifier: "beaconRegion2")

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.beaconManager.delegate = self
        self.beaconManager.returnAllRangedBeaconsAtOnce = true

        self.beaconManager.requestWhenInUseAuthorization()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion1)
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion2)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion1)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion2)
    }

    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if let neareastBeacon = beacons.first as? CLBeacon {
            if isBeacon(neareastBeacon, withUUID: BEACON_1_UUID, major: BEACON_1_MAJOR, minor: BEACON_1_MINOR) {
                // beacon #1
                self.label.text = "You're near beacon #1"
                self.imageView.image = UIImage(named: "Beacon1")
            } else if isBeacon(neareastBeacon, withUUID: BEACON_2_UUID, major: BEACON_2_MAJOR, minor: BEACON_2_MINOR) {
                // beacon #2
                self.label.text = "You're near beacon #2"
                self.imageView.image = UIImage(named: "Beacon2")
            }
        } else {
            // no beacons found
            self.label.text = "There are no beacons nearby"
            self.imageView.image = UIImage(named: "NoBeacons")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

