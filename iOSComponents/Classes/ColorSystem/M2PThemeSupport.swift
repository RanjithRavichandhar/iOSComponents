//
//  ThemeSupport.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 29/08/22.
//

import Foundation
import UIKit

@propertyWrapper
public struct M2PTheme {
    let light: UIColor
    let dark: UIColor

    public var wrappedValue: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return self.dark
                } else {
                    return self.light
                }
            }
        } else {
            return ThemeManager.isDarkModeEnabled ? self.dark : self.light
        }
    }
}

enum ThemeManager {
    static var isDarkModeEnabled = false
}
