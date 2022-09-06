//
//  M2PBottomNavigation.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 06/09/22.
//

// MARK: Implementation

/* let tabbarController = M2PBottomNavigation()
 let tabBarItems = [TabBarItems(storyboardName: "Main",
 controllerName: "blue",
 image: "Home_tab",
 selectedIimage: "Home_tab_selected",
 order: 0,
 title: "home")]
 
 tabbarController.tintColor = .green
 tabbarController.setUpTabbar(tabBarItems: tabBarItems)
 
 self.navigationController?.pushViewController(tabbarController, animated: true) */

import Foundation
import UIKit

public class TabBarItems {
    public var storyboardName: String
    public var controllerName: String
    public var image: String
    public var selectedIimage: String
    public var order: Int
    public var title: String
    
    public init(storyboardName: String, controllerName: String, image: String, selectedIimage: String, order: Int, title: String) {
        self.storyboardName = storyboardName
        self.controllerName = controllerName
        self.image = image
        self.selectedIimage = selectedIimage
        self.order = order
        self.title = title
    }
}
public class M2PBottomNavigation: UITabBarController {
    
    public static let shared = M2PBottomNavigation()
    
    public var tintColor: UIColor? {
        didSet {
            updateColor()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: update color while changing Light and Dark Mode
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateColor()
    }
    
    // MARK: Updating color for TabBar
    func updateColor() {
        self.tabBar.tintColor = tintColor
        self.tabBar.backgroundColor = .backgroundLightVarient
        
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes([.foregroundColor: UIColor.primaryActive], for: .selected)
                item.setTitleTextAttributes([.foregroundColor: UIColor.secondaryInactive], for: .normal)
            }
        }
    }
    
    
    public func setUpTabbar(tabBarItems: [TabBarItems]) {
        let viewControllers = tabBarItems
            .sorted { $0.order < $1.order }
            .compactMap { toViewController(for: $0) }
        self.viewControllers = viewControllers
    }
    
    private func toViewController(for item: TabBarItems) -> UIViewController {
        let tabBarItem = UITabBarItem(
            title: item.title,
            image: UIImage(named: item.image)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
            selectedImage: UIImage(named: item.selectedIimage)
        )
        tabBarItem.tag = item.order
        
        let foreGroundColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UITabBarItem.appearance().setTitleTextAttributes(foreGroundColor, for: .normal)
        
        let storyBoard = UIStoryboard(name: item.storyboardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: item.controllerName)
        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.tabBarItem = tabBarItem
        return navigationViewController
    }
    
    // MARK: To Present viewController for particular index
    // MARK: Example Usage -> M2PBottomNavigation.presentIndexController(controller: self, index: 2)
    public static func presentIndexController(controller: UIViewController, index: Int)  {
        controller.tabBarController?.selectedIndex = index
    }
    
    // MARK: To Fetch current index
    // MARK: Example Usage -> let currentIndex = M2PBottomNavigation.shared.getCurrentIndex(controller: self)
    public func getCurrentIndex(controller: UIViewController) -> Int {
        return controller.tabBarController?.selectedIndex ?? 0
    }
}

