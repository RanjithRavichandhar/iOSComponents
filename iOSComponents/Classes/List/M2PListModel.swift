//
//  M2PListModel.swift
//  iOSComponents
//
//  Created by CHANDRU on 07/09/22.
//

import Foundation

// MARK: - LeadingContentList
public class LeadingContentList {
    public var headerTextLabel: ContentTextModel?
    public var subTextLabel: ContentTextModel?
    public var icon: UIImage?
    public var isAvatorIcon: Bool
    
    public init?(headerTextLabel: ContentTextModel?, subTextLabel: ContentTextModel?, icon: UIImage?, isAvatorIcon: Bool = false) {
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
    public var icon: UIImage?
    public var isToggleEnable: SwitchState
    public var isToggleOn: SwitchState.WithState
    
    public init?(contentType: SecondayContentType = .texts, headerTextLabel: ContentTextModel?, subTextLabel: ContentTextModel?, actionTitleLabel: ContentTextModel?, icon: UIImage?, isToggleEnable: SwitchState = .enable, isToggleOn: SwitchState.WithState = .on) {
        self.actionTitleLabel = actionTitleLabel
        self.headerTextLabel = headerTextLabel
        self.subTextLabel = subTextLabel
        self.icon = icon
        self.contentType = contentType
        self.isToggleOn = isToggleOn
        self.isToggleEnable = isToggleEnable
    }
}

// MARK: - ContentTextLabel
public class ContentTextModel {
    public var text: String?
    public var textColor: UIColor?
    public var textFont: UIFont?
    
    public init?(text: String?, textColor: UIColor = UIColor.black, textFont: UIFont = UIFont.systemFont(ofSize: 15)) {
        self.textColor = textColor
        self.text = text
        self.textFont = textFont
    }
}

// MARK: - SecondayContentType
public enum SecondayContentType {
    case texts
    case icon
    case button
    case toggle
}
