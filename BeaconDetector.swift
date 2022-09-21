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
    var didChange = PassthroughSubject<Void, Never>()
    var locationManager: CLLocationManager?
    var lastDistance = CLProximity.unknown
    
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
                    // we are ready to go
                }
            }
        }
    }
    
    func startScanning(myID: UUID) {
        let constraint = CLBeaconIdentityConstraint(uuid: myID, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
        
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
        }
    }
    
    func update(distance: CLProximity) {
        lastDistance = distance
        print("ultima distancia: \(lastDistance)")
        didChange.send(())
    }
    
}
