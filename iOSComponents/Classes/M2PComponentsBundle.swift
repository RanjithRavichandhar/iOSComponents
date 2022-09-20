//
//  M2PComponentsBundle.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 05/09/22.
//

import UIKit
import Foundation

/*To Get bundle Name*/
public class M2PComponentsBundle {
    public static var shared = M2PComponentsBundle()
     init() { }
    
    /*Access from Resource Bundle*/
   public var currentBundle: Bundle  {
        let frameworkBundle = Bundle(for: M2PComponentsBundle.self)
        let path = frameworkBundle.path(forResource: "Resources", ofType: "bundle")
        let resourcesBundle = Bundle(url: URL(fileURLWithPath: path!))!
//        let frameworkBundle = Bundle(identifier: "org.cocoapods.iOSComponents")!
        return resourcesBundle
    }
    
    /*To get DeviceId and BundleId*/
    public var deviceId: String? { return UIDevice.current.identifierForVendor?.uuidString.filter { $0 != "-" } }
    public var bundleId: String? { return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String }
}

