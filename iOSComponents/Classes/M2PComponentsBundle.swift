//
//  M2PComponentsBundle.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 05/09/22.
//

import UIKit
import Foundation

/*To Get bundle Name*/
class M2PComponentsBundle {
    static var shared = M2PComponentsBundle()
    private init() { }
    
    /*Access from Resource Bundle*/
    var currentBundle: Bundle  {
        let frameworkBundle = Bundle(for: M2PComponentsBundle.self)
        let path = frameworkBundle.path(forResource: "Resources", ofType: "bundle")
        let resourcesBundle = Bundle(url: URL(fileURLWithPath: path!))!
//        let frameworkBundle = Bundle(identifier: "org.cocoapods.iOSComponents")!
        return resourcesBundle
    }
    
    /*To get DeviceId and BundleId*/
    var deviceId: String? { return UIDevice.current.identifierForVendor?.uuidString.filter { $0 != "-" } }
    var bundleId: String? { return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String }
}

