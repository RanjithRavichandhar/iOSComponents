//
//  M2PTopTabBarModel.swift
//  iOSComponents
//
//  Created by Shiny on 13/09/22.
//

public struct M2PTabBarItemConfig {
    public var titleFont: UIFont = UIFont.customFont(name: "Ilisarniq-Semi", size: .x16)
    public var imageWidth: CGFloat = 24 // Width of Image within the tabItem
    public var imageHeight: CGFloat = 24 // Height of Image within the tabItem
    public var itemLeftPadding: CGFloat = 20 // Left padding within tabbar item
    public var itemRightPadding: CGFloat = 20 // Right padding within tabbar item
    public var interElementSpacing: CGFloat = 12 // Spacing between elements within a tabbar item
    
    public init() {
    }
    
}

public struct M2PTabBarColorConfig {
    public var titleColor: UIColor = .focusedLine
    public var imageTintColor: UIColor = .focusedLine
    public var selectedBackground: UIColor = .formDisableFilled
    public var unselectedBackground: UIColor = .background
    public var indicatorLine_selected: UIColor = .secondaryRedColor
    public var indicatorLine_Unselected: UIColor = .formDisableFilled
    
    public init() {
    }
    
}

public struct M2PTopTabBarItem {
    var leftImage: UIImage?
    var title = "M2PTabItem"
    var rightImage: UIImage?
    
    var itemWidth: CGFloat?
    var spacingConfig: M2PTabBarItemConfig?
    var colorConfig: M2PTabBarColorConfig?
    
    public init(leftImage: UIImage? = nil, title: String, rightImage: UIImage? = nil) {
        self.leftImage = leftImage
        self.title = title
        self.rightImage = rightImage
    }
}
