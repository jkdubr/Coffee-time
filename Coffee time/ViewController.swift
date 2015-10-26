//
//  ViewController.swift
//  Coffee time
//
//  Created by Jakub Dubrovsky on 07/10/15.
//  Copyright © 2015 Jakub Dubrovsky. All rights reserved.
//

import UIKit

import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let deviceToken: String = {
        if let deviceToken = PFInstallation.currentInstallation().deviceToken {
            return deviceToken
        }
        return ""
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        return locationManager
    }()
    /*
    lazy var beaconRegion:CLBeaconRegion = {
        var beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "39407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "cz.csas")
        return beaconRegion
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.startMonitoring()
    }
    
    //MARK: ---
    
    func apiEnterRegion(min:Int, max: Int) {
        let obj = [
            "min" : min,
            "max" : max,
            "deviceToken" : self.deviceToken
            ] as NSDictionary
        
        RestClient.sharedInstance.post("functions/regionEnter", object: obj) {
            json in
        }
    }
    
    
    func apiExitRegion(min:Int, max: Int) {
        let obj = [
            "min" : min,
            "max" : max,
            "deviceToken" : self.deviceToken
            ] as NSDictionary
        
        RestClient.sharedInstance.post("functions/regionExit", object: obj) {
            json in
        }
    }
    
    @IBAction func actionIN(sender: AnyObject) {
        /*
        mint min: 28580 max:56763
        */
        let obj = [
            "min" : 2,
            "max" : 2,
            "deviceToken" : self.deviceToken
            ] as NSDictionary
        
        RestClient.sharedInstance.post("functions/regionEnter", object: obj) {
            json in
        }
    }
    
    
    @IBAction func actionOUT(sender: AnyObject) {
    }
    
    
    //MARK: ---
    func inBackground() -> Bool{
        return false
    }
    
    
    
    
    //MARK:
    func startMonitoring(){
        /*
        NSUUID *motionUUID = [ESTBeaconManager
        motionProximityUUIDForProximityUUID:stillUUID];
        CLBeaconRegion *motionRegion =
        [[CLBeaconRegion alloc]
        initWithProximityUUID:motionUUID
        major:123 minor:456 identifier:@"moving"];
        */
        
        
        //let motionUUID = NSUUID(UUIDString: "39407F30-F5F8-466E-AFF9-25556B57FE6D")!
        
        // let motionRegion = CLBeaconRegion(proximityUUID: motionUUID, identifier: "MotionBeaconRegion") //, major: 56763, minor: 28580
        
        let staticUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
        let staticRegion = CLBeaconRegion(proximityUUID: staticUUID, identifier: "nonmmm")
        
        self.locationManager.startMonitoringForRegion(staticRegion)
        //        self.locationManager.startRangingBeaconsInRegion(staticRegion)
    }
    
    func stopMonitoring() {
   //     self.locationManager.stopMonitoringForRegion(self.beaconRegion)
        //      self.locationManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    
    
    //MARK LocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        let txt = "monitoring did fail for region"
        print(txt)
        //TODO: delegate error
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let txt = "did fail with error"
        print(txt)
        //TODO: delegate error
    }
    
    //NO needed
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        let txt = "did start monitor beacon "
        print(txt)
    }
    
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        print("determine state \(state.rawValue)")
        
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter")
        print(region)
        
        if let regionBeacon = region as? CLBeaconRegion {
            if let beaconMax = regionBeacon.major, let beaconMin = regionBeacon.minor {
                self.apiEnterRegion(beaconMin.integerValue, max: beaconMax.integerValue)
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        if beacons.count > 0 {
            
            
            //            print("did range in motion")
            //            print(beacons)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit")
        print(region)
        
        if let regionBeacon = region as? CLBeaconRegion, let beaconMax = regionBeacon.major, let beaconMin = regionBeacon.minor {
            self.apiExitRegion(beaconMin.integerValue, max: beaconMax.integerValue)
        }
        
        
    }
    
    
}

