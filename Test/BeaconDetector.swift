//
//  BeaconDetector.swift
//  Test
//
//  Created by Guilherme on 14/09/22.
//

import Combine
import Foundation
import CoreLocation

extension BeaconDetector: CLLocationManagerDelegate{
    
}

class BeaconDetector: CLLocationManager, ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    var locationManager: CLLocationManager?
    var lastDistance = CLProximity.unknown
    var beaconId: UUID = UUID()
    
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for:
                                                        CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("Teste")
                }
            }
        }
    }
    
    func startScanning(myID: UUID) {
    
        let constraint = CLBeaconIdentityConstraint(uuid: myID, major: 1, minor: 4)

        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
        //locationManager?.startRangingBeacons(in: beaconRegion)
        
        print("Regioes \(locationManager?.monitoredRegions)")
        print("RangedBeaconConstraints \(locationManager?.rangedBeaconConstraints)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion
    ) {
        if let beacon = beacons.first {
            print("Encontrou Beacon")
            update(distance: beacon.proximity)
        } else {
            print("Beacon list is empty")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon],
                         satisfying beaconConstraint: CLBeaconIdentityConstraint)
    {
        print("didRange: \(beacons) ----- BeaconConstraint: \(beaconConstraint)")
        
    }
    
    func update(distance: CLProximity) {
        lastDistance = distance
        print("ultima distancia: \(lastDistance)")
        self.objectWillChange.send()
    }
    
}
