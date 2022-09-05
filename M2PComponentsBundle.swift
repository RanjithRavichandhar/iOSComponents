//
//  Bundle.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 05/09/22.
//

import UIKit
import Foundation

/*To Get bundle Name*/
class M2PBundle {
    static var shared = M2PBundle()
    private init() { }
    
    /*Access from Resource Bundle*/
    var currentBundle: Bundle  {
        let frameworkBundle = Bundle(identifier: "iOS.M2PCardSystem.SDK")!
        return frameworkBundle
    }
    
    /*To get DeviceId and BundleId*/
    var deviceId: String? { return UIDevice.current.identifierForVendor?.uuidString.filter { $0 != "-" } }
    var bundleId: String? { return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String }
}

