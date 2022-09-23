//
//  M2PDotLoader.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 13/09/22.
//

import UIKit
import QuartzCore
import CoreGraphics

public class M2PDotLoader: UIView {
    
    struct Constants {
        static let loaderMarginSide : CGFloat = 16.0
    }
    
    private var coverView : UIView?
    private var loadingView : M2PDotLoadingView?
    private var animated : Bool = true
    private var canUpdated = false
    
    private var config : M2PConfigDot = M2PConfigDot() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var shared: M2PDotLoader {
        struct Singleton {
            static let instance = M2PDotLoader(frame: CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: 80.0,height: 80.0)))
        }
        return Singleton.instance
    }
    
    public class func M2PDotLoaderShow(animated: Bool) {
        self.show(title: nil, animated: animated)
    }
    
    private class func show(title: String?, animated : Bool) {
        var currentWindow: UIWindow?
        if #available(iOS 13.0, *) {
            currentWindow = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            // Fallback on earlier versions
            currentWindow = UIApplication.shared.windows.first
        }
        
        guard let currentWindow = currentWindow else { return }
        
        let loader = M2PDotLoader.shared
        loader.canUpdated = true
        loader.animated = animated
        loader.update()
        
        NotificationCenter.default.addObserver(loader, selector: #selector(loader.rotated(notification: )),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        
        if (loader.superview == nil) {
            loader.coverView = UIView(frame: currentWindow.bounds)
            loader.coverView?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
            
            currentWindow.addSubview(loader.coverView!)
            currentWindow.addSubview(loader)
            loader.start()
        }
    }
    
    public class func M2PDotLoaderHide() {
        NotificationCenter.default.removeObserver(M2PLoader.shared)
        M2PDotLoader.shared.stop()
    }
    
    public class func M2PDotLoaderSetConfig(_ config: M2PConfigDot) {
        let loader = M2PDotLoader.shared
        loader.config = config
        loader.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                              size: CGSize(width: 80.0,
                                           height: 80.0))
    }
    
    @objc func rotated(notification: NSNotification) {
        let loader = M2PDotLoader.shared
        
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        loader.coverView?.frame = UIScreen.main.bounds
    }
    
    // MARK: - Private methods
    private func setup() {
        self.alpha = 0
        self.update()
    }
    
    private func start() {
//        self.loadingView?.start()
        self.loadingView?.showAnimatingDotsInImageView()
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (finished) -> Void in
                
            });
        } else {
            self.alpha = 1
        }
    }
    
    private func stop() {
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (finished) -> Void in
                self.removeFromSuperview()
                self.coverView?.removeFromSuperview()
//                self.loadingView?.stop()
                self.loadingView?.stopAnimate()
            });
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverView?.removeFromSuperview()
//            self.loadingView?.stop()
            self.loadingView?.stopAnimate()
        }
    }
    
    private func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        
        if (self.loadingView == nil) {
            self.loadingView = M2PDotLoadingView()
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = dotFrame
        }
    }
    
    var dotFrame: CGRect {
        let loadingViewSize = self.frame.size.width - (Constants.loaderMarginSide * 2)
        
        let yOffset = (self.center.y) - 10
        return CGRect(origin: CGPoint(x: (Constants.loaderMarginSide), y: yOffset), size: CGSize(width: loadingViewSize, height: 20.0))
    }
    
    // MARK: - Dot Loading View
    class M2PDotLoadingView : UIView {
        
        var backgroundLayer: CAReplicatorLayer?
        
        var config : M2PConfigDot = M2PConfigDot() {
            didSet {
                self.update()
            }
        }
        
        func update() {
            
        }
        
        func showAnimatingDotsInImageView() {
            backgroundLayer = CAReplicatorLayer()
            backgroundLayer?.frame = CGRect(x: self.center.x/2 - 16, y: self.layer.bounds.height/4, width: 0, height: 0) //yPos == 12
            let circle = CALayer()
            circle.frame = CGRect(x: 0, y: 0, width: 9, height: 9)
            circle.cornerRadius = circle.frame.width / 2
            circle.backgroundColor = config.indicatorColor.cgColor //lightGray.cgColor //UIColor.black.cgColor
            backgroundLayer?.addSublayer(circle)
            backgroundLayer?.instanceCount = 3
            backgroundLayer?.instanceTransform = CATransform3DMakeTranslation(16, 0, 0)
//            let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            let anim = CABasicAnimation()
            anim.keyPath = "opacity"
            anim.fromValue = 1.0
            anim.toValue = 0.2
            anim.duration = 0.9
            anim.repeatCount = .infinity
            circle.add(anim, forKey: nil)
            backgroundLayer?.instanceDelay = anim.duration / Double(backgroundLayer?.instanceCount ?? 0)
            self.layer.contentsCenter = backgroundLayer!.contentsCenter
            self.layer.addSublayer(backgroundLayer!)
        }
        
        func stopAnimate() {
            self.backgroundLayer?.removeFromSuperlayer()
            self.backgroundLayer?.removeAnimation(forKey: "opacity")
            self.backgroundLayer?.removeAllAnimations()
        }
    }
    
    // MARK: - Loader config
    public struct M2PConfigDot {
        
        /// Background color for loader
        public var backgroundColor = UIColor.background
        
        /// Background color for loader
        public var indicatorColor = UIColor.secondaryRedColor
        
        /// Foreground color
        public var foregroundColor = UIColor.black
        
        /// Foreground alpha CGFloat, between 0.0 and 1.0
        public var foregroundAlpha:CGFloat = 0.5
        
        /// Corner radius for loader
        public var cornerRadius : CGFloat = 10.0
        
        public init() {}
        
    }
}

// MARK: Implementation Code
/*
 func DotLoader() {
     var config : M2PDotLoader.M2PConfigDot = M2PDotLoader.M2PConfigDot()
     config.backgroundColor = UIColor.background
     config.foregroundColor = UIColor.black
     config.foregroundAlpha = 0.5
     
     M2PDotLoader.M2PDotLoaderSetConfig(config)
     M2PDotLoader.M2PDotLoaderShow(animated: true)
     delay(seconds: 6.0) { () -> () in
             M2PDotLoader.M2PDotLoaderHide()
     }
 }

func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
*/
