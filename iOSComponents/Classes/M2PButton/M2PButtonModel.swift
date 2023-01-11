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
    
    public init(title: String?, primaryIcon: UIImage?, secondaryIcon: UIImage?, colorConfig: M2PButtonColorConfigModel) {
        self.title = title
        self.primaryIcon = primaryIcon
        self.secondaryIcon = secondaryIcon
        self.colorConfig = colorConfig
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
    case Primary
    case Secondary
    case None
    
    var bool: Bool {
        switch self {
        case .Primary:
            return true
        default:
            return false
        }
    }
}

public enum ButtonStyle : String {
    case NOICON
    case ONLYICON
    case LEFT_SIDE_ICON
    case RIGHT_SIDE_ICON
    case DOUBLE_SIDE_ICON
}

public enum ButtonStatus {
    case ENABLE
    case DISABLE

    var bool: Bool {
        switch self {
        case .ENABLE:
            return true
        default:
            return false
        }
    }
}
