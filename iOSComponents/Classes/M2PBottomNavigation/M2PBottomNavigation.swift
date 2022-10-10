//
//  M2PBottomNavigation.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 06/09/22.
//

// MARK: Implementation

/* let tabbarController = M2PBottomNavigation()
 let tabBarItems = [M2PTabBarItems(storyboardName: "Main",
 controllerName: "blue",
 image: "Home_tab",
 selectedImage: "Home_tab_selected",
 order: 0,
 title: "home")]
 
 tabbarController.M2PTintColor = .green
 tabbarController.M2PSetUpTabbar(tabBarItems: tabBarItems)
 
 self.navigationController?.pushViewController(tabbarController, animated: true) */

import Foundation
import UIKit

public class M2PTabBarItems {
    public var storyboardName: String
    public var controllerName: String
    public var image: String
    public var selectedImage: String
    public var order: Int
    public var title: String
    
    public init(storyboardName: String, controllerName: String, image: String, selectedImage: String, order: Int, title: String) {
        self.storyboardName = storyboardName
        self.controllerName = controllerName
        self.image = image
        self.selectedImage = selectedImage
        self.order = order
        self.title = title
    }
}
public class M2PBottomNavigation: UITabBarController {
    
    public static let shared = M2PBottomNavigation()
    
    public var M2PTintColor: UIColor? {
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
        self.tabBar.tintColor = M2PTintColor
        self.tabBar.backgroundColor = .backgroundLightVarient
        
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes([.foregroundColor: UIColor.primaryActive], for: .selected)
                item.setTitleTextAttributes([.foregroundColor: UIColor.secondaryInactive], for: .normal)
            }
        }
    }
    
    
    public func M2PSetUpTabbar(tabBarItems: [M2PTabBarItems]) {
        let viewControllers = tabBarItems
            .sorted { $0.order < $1.order }
            .compactMap { toViewController(for: $0) }
        self.viewControllers = viewControllers
    }
    
    private func toViewController(for item: M2PTabBarItems) -> UIViewController {
        let tabBarItem = UITabBarItem(
            title: item.title,
            image: UIImage(named: item.image)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
            selectedImage: UIImage(named: item.selectedImage)
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
    public static func M2PPresentIndexController(controller: UIViewController, index: Int)  {
        controller.tabBarController?.selectedIndex = index
    }
    
    // MARK: To Fetch current index
    // MARK: Example Usage -> let currentIndex = M2PBottomNavigation.shared.getCurrentIndex(controller: self)
    public func M2PGetCurrentIndex(controller: UIViewController) -> Int {
        return controller.tabBarController?.selectedIndex ?? 0
    }
}

