//
//  M2PPageControlModel.swift
//  iOSComponents
//
//  Created by Shiny on 21/09/22.
//

import Foundation

public enum Alignment {
    case leftMost
    case any
}

public struct M2PPageControlConfig {
    
    var alignment: Alignment = .any
    var indicatorImage_active: UIImage?
    var indicatorImage_inactive: UIImage?
    var indicatorColor_active: UIColor = .secondaryRedColor
    var indicatorColor_inactive: UIColor = .secondaryInactive
    
    public init(indicatorsAlignment: Alignment? = nil, image_active: UIImage? = nil, image_inactive: UIImage? = nil, active_color: UIColor? = nil, inactive_color: UIColor? = nil) {
        self.indicatorImage_inactive = image_inactive
        self.indicatorImage_active = image_active
        if let color = active_color {
            self.indicatorColor_active = color
        }
        if let color = inactive_color {
            self.indicatorColor_inactive = color
        }
        if let alignment = indicatorsAlignment {
            self.alignment = alignment
        }
    }
    
}

