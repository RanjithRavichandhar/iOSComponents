//
//  M2PInputFieldModel.swift
//  iOSComponents
//
//  Created by Shiny on 26/09/22.
//

import Foundation

public enum M2PInputFieldType {
    case Default_TextField
    case Password
    case Dropdown
    case CalendarDefault
    case CalendarCustom
}

public enum M2PInputFieldStyle {
    case Form_Default
    case Form_Floating
    case BottomLine_Default
    case BottomLine_Floating
}

public struct M2PInputFieldConfig {
    var titleText: String?
    var placeholderText: String = "Placeholder"
    var fieldStyle: M2PInputFieldStyle = .Form_Floating
    var fieldFonts = M2PInputFieldFontConfig()
    var fieldColors = M2PInputFieldColorConfig()
    
    init() {
    }
    
    public init(title: String? = nil, placeholder: String, fieldStyle: M2PInputFieldStyle, fieldFonts: M2PInputFieldFontConfig? = nil, fieldColors: M2PInputFieldColorConfig? = nil) {
        
        self.placeholderText = placeholder
        self.titleText = title ?? placeholder
        self.fieldStyle = fieldStyle
        if let fonts = fieldFonts {
            self.fieldFonts = fonts
        }
        if let colors = fieldColors {
            self.fieldColors = colors
        }
        
    }
}

public struct M2PInputFieldFontConfig {
    public var titleFont: UIFont = UIFont.customFont(name: "Ilisarniq-Regular", size: .x13)
    public var placeHolderFont: UIFont = UIFont.customFont(name: "Ilisarniq-Regular", size: .x17)
    public var valueTextFont: UIFont = UIFont.customFont(name: "Ilisarniq-Regular", size: .x17)
    public var errorFont: UIFont = UIFont.customFont(name: "Ilisarniq-Regular", size: .x10)
    
    public init() {
    }
    
}

public struct M2PInputFieldColorConfig {
    public var title: UIColor = .DavysGrey66
    public var placeholder: UIColor = .secondaryInactive
    public var valueText: UIColor = .primaryActive
    public var defaultBorder: UIColor = .lightGray
    public var activeBorder: UIColor = .primaryActive
    public var successState: UIColor = .GreenPigment100
    public var failureState: UIColor = .PrincetonOrange100
    public var disabledState: UIColor = .formDisableFilled
    
    public init() {
    }
}

public struct M2PFieldTypeImageConfig {
    public var clearImage: UIImage?
    public var password_on: UIImage?
    public var password_off: UIImage?
    public var dropdown_default: UIImage?
    public var dropdown_active: UIImage?
    public var calendar_default: UIImage?
    public var calendar_active: UIImage?
    
    public init() {
    }
}
