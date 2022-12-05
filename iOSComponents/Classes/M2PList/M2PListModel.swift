//
//  M2PListModel.swift
//  iOSComponents
//
//  Created by CHANDRU on 07/09/22.
//

import Foundation
import UIKit

// MARK: - LeadingContentList
public class M2PLeadingContentList {
    public var headerTextLabel: M2PContentTextModel?
    public var subTextLabel: M2PContentTextModel?
    public var icon: M2PContentImageModel?
    public var isAvatorIcon: Bool
    
    public init?(headerTextLabel: M2PContentTextModel?, subTextLabel: M2PContentTextModel?, icon: M2PContentImageModel?, isAvatorIcon: Bool = false) {
        self.headerTextLabel = headerTextLabel
        self.subTextLabel = subTextLabel
        self.icon = icon
        self.isAvatorIcon = isAvatorIcon
    }
}

// MARK: - TrailingContentList
public class M2PTrailingContentList {
    public var contentType: M2PSecondayContentType
    public var actionTitleLabel: M2PContentTextModel?
    public var headerTextLabel: M2PContentTextModel?
    public var subTextLabel: M2PContentTextModel?
    public var icon: M2PContentImageModel?
   
    public init?(contentType: M2PSecondayContentType = .texts, headerTextLabel: M2PContentTextModel?, subTextLabel: M2PContentTextModel?, actionTitleLabel: M2PContentTextModel?, icon: M2PContentImageModel?) {
        self.actionTitleLabel = actionTitleLabel
        self.headerTextLabel = headerTextLabel
        self.subTextLabel = subTextLabel
        self.icon = icon
        self.contentType = contentType
    }
}

// MARK: - ContentTextLabelModel

public class M2PContentTextModel {
    public var text: String?
    public var textColor: UIColor?
    public var textFont: UIFont?
    public var textAlignment: NSTextAlignment?
    
    public init?(text: String?, textColor: UIColor?, textFont: UIFont = UIFont.systemFont(ofSize: 15), textAlignment: NSTextAlignment? = nil) {
        self.textColor = textColor
        self.text = text
        self.textFont = textFont
        self.textAlignment = textAlignment
    }
}

// MARK: - ContentImageModel
public class M2PContentImageModel {
    public var image: UIImage?
    public var tintColor: UIColor?
    
    public init(image: UIImage?, tintColor: UIColor?) {
        self.image = image
        self.tintColor = tintColor
    }
}

// MARK: - SecondayContentType
public enum M2PSecondayContentType {
    case texts
    case icon
    case button
    case toggle
    case radio
    case checkBox
}
