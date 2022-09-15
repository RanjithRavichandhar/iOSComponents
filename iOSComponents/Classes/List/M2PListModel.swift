//
//  M2PListModel.swift
//  iOSComponents
//
//  Created by CHANDRU on 07/09/22.
//

import Foundation
import UIKit

// MARK: - LeadingContentList
public class LeadingContentList {
    public var headerTextLabel: ContentTextModel?
    public var subTextLabel: ContentTextModel?
    public var icon: ContentImageModel?
    public var isAvatorIcon: Bool
    
    public init?(headerTextLabel: ContentTextModel?, subTextLabel: ContentTextModel?, icon: ContentImageModel?, isAvatorIcon: Bool = false) {
        self.headerTextLabel = headerTextLabel
        self.subTextLabel = subTextLabel
        self.icon = icon
        self.isAvatorIcon = isAvatorIcon
    }
}

// MARK: - TrailingContentList
public class TrailingContentList {
    public var contentType: SecondayContentType
    public var actionTitleLabel: ContentTextModel?
    public var headerTextLabel: ContentTextModel?
    public var subTextLabel: ContentTextModel?
    public var icon: ContentImageModel?
   
    public init?(contentType: SecondayContentType = .texts, headerTextLabel: ContentTextModel?, subTextLabel: ContentTextModel?, actionTitleLabel: ContentTextModel?, icon: ContentImageModel?) {
        self.actionTitleLabel = actionTitleLabel
        self.headerTextLabel = headerTextLabel
        self.subTextLabel = subTextLabel
        self.icon = icon
        self.contentType = contentType
    }
}

// MARK: - ContentTextLabelModel

public class ContentTextModel {
    public var text: String?
    public var textColor: UIColor?
    public var textFont: UIFont?
    public var textAlignment: NSTextAlignment?
    
    public init?(text: String?, textColor: UIColor = UIColor.black, textFont: UIFont = UIFont.systemFont(ofSize: 15), textAlignment: NSTextAlignment? = nil) {
        self.textColor = textColor
        self.text = text
        self.textFont = textFont
        self.textAlignment = textAlignment
    }
}

// MARK: - ContentImageModel
public class ContentImageModel {
    public var image: UIImage?
    public var tintColor: UIColor
    
    public init(image: UIImage?, tintColor: UIColor = UIColor.black) {
        self.image = image
        self.tintColor = tintColor
    }
}

// MARK: - SecondayContentType
public enum SecondayContentType {
    case texts
    case icon
    case button
    case toggle
    case radio
}
