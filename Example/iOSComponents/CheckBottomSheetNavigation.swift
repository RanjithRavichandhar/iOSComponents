//
//  Fie.swift
//  iOSComponents_Example
//
//  Created by CHANDRU on 19/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import iOSComponents

class CheckBottomSheetNavigation: M2PBottomSheetNavigationController {

    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    override var popupHeight: CGFloat {
        return height ?? CGFloat(300)
    }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var popupDimmingViewAlpha: CGFloat {
        return BottomPopupConstants.kDimmingViewDefaultAlphaValue
        
    }
}

