//
//  Typography.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 05/09/22.
//

import Foundation
import UIKit

/* Custom font size */
public enum FontSize: CGFloat {
    case x10 = 10.0
    case x11 = 11.0
    case x12 = 12.0
    case x13 = 13.0
    case x14 = 14.0
    case x15 = 15.0
    case x16 = 16.0
    case x17 = 17.0
    case x18 = 18.0
    case x20 = 20.0
    case x22 = 22.0
    case x25 = 25.0
    case x28 = 28.0
    case x34 = 34.0
}

extension UIFont {
    public static func customFont(name: String, size: FontSize) -> UIFont {
        let font = UIFont(name: name, size: size.rawValue)
        return font ?? UIFont.systemFont(ofSize: size.rawValue)
    }
}
