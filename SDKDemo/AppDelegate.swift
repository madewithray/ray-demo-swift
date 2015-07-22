//
//  AppDelegate.swift
//  SDKDemo
//
//  Created by Sean Ooi on 6/5/15.
//  Copyright (c) 2015 Yella Inc. All rights reserved.
//

import UIKit
import RaySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var items = [[String: AnyObject]]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        RSDK.sharedInstanceWithApiKey("MyAPIKey")
        RSDK.sharedInstance.delegate = self
        RSDK.sharedInstance.subsequentRangingInterval = 5
        RSDK.sharedInstance.enableBackgroundProcessTimeExtension = true
        RSDK.sharedInstance.beaconMinimumThreshold = -69
        RSDK.sharedInstance.beaconExitTrigger = -70
        RSDK.sharedInstance.enableCustomWalkOut = true
        RSDK.sharedInstance.enableContinuousRanging = true
        RSDK.sharedInstance.setAuthorizationType(.Always)
        RSDK.sharedInstance.startMonitoring()
        
        return true
    }
    
}

extension AppDelegate: RaySDKDelegate {
    
    func rsdkDidRangeRayBeacon(beacon: [RSDKBeacon]!, inRegionWithIdentifier identifier: String) {
        println("Did range: \(beacon)")
    }
    
    func rsdkDidEnterRegionWithIdentifier(identifier: String) {
        println("Did enter region: \(identifier)")
    }
    
    func rsdkDidExitRegionWithIdentifier(identifier: String) {
        println("Did exit region: \(identifier)")
    }
    
    func rsdkDidWalkInToBeacon(beacon: RSDKBeacon!, inRegionWithIdentifier identifier: String) {
        println("Did walk in: \(beacon)")
        
        items.append(["beacon": beacon, "key": identifier])
        NSNotificationCenter.defaultCenter().postNotificationName(notificationRefreshKey, object: nil)
    }
    
    func rsdkDidWalkOutOfBeacon(beacon: RSDKBeacon!, inRegionWithIdentifier identifier: String) {
        println("Did walk out: \(beacon)")
        
        for (idx, item) in enumerate(items) {
            if let key = item["key"] as? String where key == identifier {
                items.removeAtIndex(idx)
                break
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(notificationRefreshKey, object: nil)
    }
    
    func rsdkDidFailWithError(error: NSError!) {
        println("Error: \(error)")
    }
    
    func rsdkBluetoothManagerDidUpdateState(state: BluetoothState) {
        switch state {
        case .Unknown:
            println("Bluetooth state unknown")
            
        case .Resetting:
            println("Bluetooth state resetting")
            
        case .Unsupported:
            println("Bluetooth state unsupported")
            
        case .Unauthorized:
            println("Bluetooth state unauthorized")
            
        case .PoweredOff:
            println("Bluetooth state powered off")
            
        case .PoweredOn:
            println("Bluetooth state powered on")
        }
    }
}