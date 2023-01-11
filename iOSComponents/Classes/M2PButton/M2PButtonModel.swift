//
//  M2PButtonModel.swift
//  iOSComponents
//
//  Created by CHANDRU on 11/01/23.
//

import Foundation

// MARK: M2PButtonConfigModel
public class M2PButtonConfigModel {
    public var title: String?
    public var primaryIcon: UIImage?
    public var secondaryIcon: UIImage?
    public var titleFont: UIFont = .systemFont(ofSize: 14)
    public var colorConfig: M2PButtonColorConfigModel
    public var iconSize: CGFloat = 20
    
    public init(title: String?, primaryIcon: UIImage?, secondaryIcon: UIImage?, colorConfig: M2PButtonColorConfigModel, titleFont: UIFont = .systemFont(ofSize: 14), iconSize: CGFloat = 20) {
        self.title = title
        self.primaryIcon = primaryIcon
        self.secondaryIcon = secondaryIcon
        self.colorConfig = colorConfig
        self.titleFont = titleFont
        self.iconSize = iconSize
    }
}

// MARK: M2PButtonColorConfigModel
public class M2PButtonColorConfigModel {
    public var backgroundActive: UIColor?
    public var backgroundInActive: UIColor?
   
    public var borderActive: UIColor?
    public var borderInActive: UIColor?
    
    public var titleActive: UIColor?
    public var titleInActive: UIColor?
    
    public var primaryIconActive: UIColor?
    public var primaryIconInActive: UIColor?
    
    public var secondaryIconActive: UIColor?
    public var secondaryIconInActive: UIColor?
    
    public init() {
    }
}

public enum ButtonTypes {
    case primary
    case secondary
    case none
    
    var bool: Bool {
        switch self {
        case .primary:
            return true
        default:
            return false
        }
    }
}

public enum ButtonStyle : String {
    case text
    case icon
    case primaryIcon_text
    case secondaryIcon_text
    case icons_text
}

public enum ButtonStatus {
    case enable
    case disable

    var bool: Bool {
        switch self {
        case .enable:
            return true
        default:
            return false
        }
    }
}
