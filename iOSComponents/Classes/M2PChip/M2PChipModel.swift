//
//  M2PChipModel.swift
//  iOSComponents
//
//  Created by CHANDRU on 05/09/22.
//

// MARK: - BorderType
public enum ChipBorderType {
    case solid
    case outline
}

// MARK: - ContentType
public enum ChipContentType {
    case icons
    case text
    case textWithLeftIcon
    case textWithRightIcon
    case doubleSideIcon
}

// MARK: - ChipType
public enum ChipType {
    case neutral
    case primary
    case success
    case error
    case info
    case warning
    
    var backGroundColor: UIColor {
        switch self {
        case .neutral:
            return .DavysGrey16
        case .primary:
            return .primaryActive
        case .success:
            return .GreenPigment16
        case .error:
            return .ImperialRed16
        case .info:
            return .PacificBlue16
        case .warning:
            return .Yellow16
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .neutral:
            return .DavysGrey100
        case .primary:
            return .background
        case .success:
            return UIColor(red: 0.11, green: 0.349, blue: 0.165, alpha: 1)
        case .error:
            return UIColor(red: 0.6, green: 0.176, blue: 0.149, alpha: 1)
        case .info:
            return .PacificBlue100
        case .warning:
            return UIColor(red: 0.6, green: 0.499, blue: 0.192, alpha: 1)
        }
    }
}
