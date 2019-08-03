//
//  ViewController.swift
//  iBeaconBroadcaster
//
//  Created by Richard de Borja on 2019-07-17.
//  Copyright © 2019 Richard de Borja. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation


class ViewController: UIViewController, CBPeripheralManagerDelegate {

    // MARK: Properties
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Starting the app...")
        
        initLocalBeacon()
    }

    func initLocalBeacon() {
        print("Starting to broadcast a beacon...")

        if localBeacon != nil {
            stopLocalBeacon()
        }
    
        //let localBeaconUUID = "3310E569-48CE-4108-9EA6-9BBF3FA7A191"
        let localBeaconUUID = "5032B8A3-3F64-438D-B840-DCB2B7BEA524"
        let localBeaconMajor = 123
        let localBeaconMinor = 456
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(localBeaconMajor), minor: CLBeaconMinorValue(localBeaconMinor), identifier: "MyBeacon")
        
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        print("Broadcasting the beacon with major: \(localBeaconMajor), minor: \(localBeaconMinor)")
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
    
}

