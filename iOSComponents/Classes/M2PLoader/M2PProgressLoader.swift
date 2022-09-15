//
//  M2PProgressLoader.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 15/09/22.
//

import UIKit
import QuartzCore
import CoreGraphics

public class M2PProgressLoader: UIView {
    
    private var coverView : UIView?
    private var loadingView : M2PProgressView?
    private var animated : Bool = true
    private var canUpdated = false
//    private var indicatorValue: Float = 0.0

    private var config : ConfigProgress = ConfigProgress() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var shared: M2PProgressLoader {
        struct Singleton {
            static let instance = M2PProgressLoader(frame: CGRect(origin: CGPoint(x: 16.0,y: 16.0),size: CGSize(width: (UIScreen.main.bounds.size.width - 32.0),height: 120.0)))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated)
    }
    
    public class func show(title: String?, animated : Bool) {
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
        
        let loader = M2PProgressLoader.shared
        loader.canUpdated = true
        loader.animated = animated
        loader.loadingView?.titleLbl?.text = title
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
    
    public class func updateProgress(title: String, percent: Float) {
        let loader = M2PProgressLoader.shared
        loader.loadingView?.titleLbl?.text = title
//        loader.indicatorValue = percent
//        loader.indicatorValue += 0.01
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            if percent <= 1.01 {
                loader.loadingView?.progressView?.setProgress(percent, animated: true)
            }
        })
        let percentage = ((loader.loadingView?.progressView?.progress ?? 0.0) * 100)
        loader.loadingView?.percentageLbl?.text = "\(Int(percentage))%"
    }
    
    public class func hide() {
        NotificationCenter.default.removeObserver(M2PProgressLoader.shared)
        M2PProgressLoader.shared.stop()
    }
    
    public class func setConfig(_ config: ConfigProgress) {
        let loader = M2PProgressLoader.shared
        loader.config = config
        loader.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                              size: CGSize(width: (UIScreen.main.bounds.size.width - 32.0),
                                           height: loader.config.size))
    }
    
    @objc func rotated(notification: NSNotification) {
        let loader = M2PProgressLoader.shared
        
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        loader.coverView?.frame = UIScreen.main.bounds
    }
    
    private func start() {
        self.loadingView?.startAnimating()
        
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
                self.loadingView?.stopAnimating()
            });
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverView?.removeFromSuperview()
            self.loadingView?.stopAnimating()
        }
    }
    
    private func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        
        if (self.loadingView == nil) {
            self.loadingView = M2PProgressView()
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = progressFrame
        }
    }
    
    var progressFrame: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (UIScreen.main.bounds.size.width - 32.0), height: config.size))
    }
    
    // MARK: - Dot Loading View
    class M2PProgressView : UIView {

        private var logoImage : UIImageView?
        private var logoView : UIView?
        public var progressView : UIProgressView?
        public var titleLbl : UILabel?
        public var percentageLbl : UILabel?
        private var observation: NSKeyValueObservation?

        var config : ConfigProgress = ConfigProgress() {
            didSet {
                self.update()
            }
        }
        
        func update() {
            let width = UIScreen.main.bounds.size.width
            if (self.progressView == nil) {
                self.progressView = UIProgressView(frame: CGRect(origin: CGPoint(x: 0, y: 68.0), size: CGSize(width: (width - 32.0), height: 8.0)))
                self.progressView?.layer.cornerRadius = 8.0
//                self.progressView?.layer.masksToBounds = true
                self.progressView?.transform = (self.progressView?.transform.scaledBy(x: 1.0, y: 2.0))!
                self.progressView?.progressTintColor = config.progressTintColor
                self.progressView?.trackTintColor = config.trackTintColor
                self.progressView?.progress = 0.0
                self.addSubview(self.progressView!)
            }
            
            if (self.logoImage == nil) {
                self.logoView = UIView(frame: CGRect(origin: CGPoint(x: ((width/2) - 40.0), y: 4.0), size: CGSize(width: 44.0, height: 44.0)))
                self.logoView?.backgroundColor = config.logoColor
                self.logoView?.layer.cornerRadius = 8.0
                self.logoView?.layer.masksToBounds = true
                self.logoImage = UIImageView(frame: CGRect(origin: CGPoint(x: 2.0, y: 2.0), size: CGSize(width: 40.0, height: 40.0)))
                self.logoImage?.backgroundColor = .clear
                self.logoImage?.image = config.logo
                self.logoImage?.contentMode = .scaleAspectFit
                self.logoView?.addSubview(self.logoImage!)
                self.addSubview(self.logoView!)
            }
            
            if (self.percentageLbl == nil) && (self.titleLbl == nil) {
                self.titleLbl = UILabel()
//                self.titleLbl?.text = "Processing..."
                self.titleLbl?.textAlignment = .left
                self.titleLbl?.backgroundColor = .clear
                self.titleLbl?.font = config.titleTextFont
                self.titleLbl?.textColor = config.titleTextColor
                
                self.percentageLbl = UILabel()
//                self.percentageLbl?.text = "20%"
                self.percentageLbl?.textAlignment = .right
                self.percentageLbl?.backgroundColor = .clear
                self.percentageLbl?.font = config.percentageTextFont
                self.percentageLbl?.textColor = config.percentageTextColor
                
                let stackView   = UIStackView(frame: CGRect(origin: CGPoint(x: 0, y: 74.0), size: CGSize(width: (width - 32.0), height: 28.0)))
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                stackView.spacing = 4.0
                stackView.addArrangedSubview(self.titleLbl!)
                stackView.addArrangedSubview(self.percentageLbl!)
                self.addSubview(stackView)
            }
        }
        
        func startAnimating() {
//            observation = task.progress.observe(\.fractionCompleted) { progress, _ in
//              DispatchQueue.main.async {
//                self.progressView.progress = Float(progress.completedUnitCount)
//              }
//            }

        }
        
        func stopAnimating() {
            self.observation?.invalidate()
        }
        
        deinit {
            self.observation?.invalidate()
        }

    }
    
    
    // MARK: - Loader config
    public struct ConfigProgress {
        
        /// Size of loader
        public var size : CGFloat = 120.0
        
        /// Color of progressTint view
        public var progressTintColor = UIColor.secondaryRedColor
        
        /// Line width
        public var trackTintColor = UIColor.background
        
        /// Color of title text
        public var titleTextColor = UIColor.primaryActive
        
        /// Color of percentage text
        public var percentageTextColor = UIColor.primaryActive
        
        /// Speed of the spinner
        public var speed : Int = 1
        
        /// Font for title text in loader
        public var titleTextFont : UIFont = UIFont.customFont(name: "ArialMT", size: .x13)
        
        /// Font for precentage text in loader
        public var percentageTextFont : UIFont = UIFont.customFont(name: "Arial-BoldMT", size: .x13)
        
        /// Background color for loader
        public var backgroundColor = UIColor.background
        
        /// Logo color for loader
        public var logoColor = UIColor.background
        
        /// Foreground color
        public var foregroundColor = UIColor.clear
        
        /// Foreground alpha CGFloat, between 0.0 and 1.0
        public var foregroundAlpha : CGFloat = 0.0
        
        /// Corner radius for loader
        public var cornerRadius : CGFloat = 10.0
        
        /// Corner radius for loader
        public var logo : UIImage = UIImage(named: "m2plogo", in: M2PComponentsBundle.shared.currentBundle, compatibleWith: nil)!
        
        public init() {}
        
    }
}

/*
func progressLoader() {
    var config : M2PProgressLoader.ConfigProgress = M2PProgressLoader.ConfigProgress()
    config.backgroundColor = UIColor.clear
    config.logoColor = UIColor.background
    config.foregroundColor = UIColor.black
    config.foregroundAlpha = 0.5
    
    M2PProgressLoader.setConfig(config)
    M2PProgressLoader.show(animated: true)
    delay(seconds: 10.0) { () -> () in
        M2PProgressLoader.hide()
    }
}


func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
*/
