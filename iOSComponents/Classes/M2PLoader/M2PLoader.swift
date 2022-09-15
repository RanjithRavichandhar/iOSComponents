//
//  M2PLoader.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 13/09/22.
//

import UIKit
import QuartzCore
import CoreGraphics

public class M2PLoader: UIView {
    
    struct Constants {
        static let loaderSpinnerMarginSide : CGFloat = 35.0
        static let loaderSpinnerMarginTop : CGFloat = 20.0
        static let loaderTitleMargin : CGFloat = 5.0
    }
    
    private var coverView : UIView?
    private var titleLabel : UILabel?
    private var loadingView : M2PLoadingView?
    private var animated : Bool = true
    private var canUpdated = false
    private var title: String?
    private var speed = 1

    private var config : Config = Config() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var shared: M2PLoader {
        struct Singleton {
            static let instance = M2PLoader(frame: CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: 126.0,height: 126.0)))
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
        
        let loader = M2PLoader.shared
        loader.canUpdated = true
        loader.animated = animated
        loader.title = title
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
    
    public class func hide() {
        NotificationCenter.default.removeObserver(M2PLoader.shared)
        M2PLoader.shared.stop()
    }
    
    public class func setConfig(_ config: Config) {
        let loader = M2PLoader.shared
        loader.config = config
        loader.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                              size: CGSize(width: loader.config.size,
                                           height: loader.config.size))
    }
    
    @objc func rotated(notification: NSNotification) {
        let loader = M2PLoader.shared
        
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
//            self.loadingView?.stop()
            self.loadingView?.stopAnimating()
        }
    }
    
    private func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (Constants.loaderSpinnerMarginSide * 2)
        
        if (self.loadingView == nil) {
            self.loadingView = M2PLoadingView(frame: spinnerFrame)
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = spinnerFrame
        }
        
        if (self.titleLabel == nil) {
            self.titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: Constants.loaderTitleMargin, y: Constants.loaderSpinnerMarginTop + loadingViewSize), size: CGSize(width: self.frame.width - Constants.loaderTitleMargin*2, height:  42.0)))
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = CGRect(origin: CGPoint(x: Constants.loaderTitleMargin, y: Constants.loaderSpinnerMarginTop + loadingViewSize), size: CGSize(width: self.frame.width - Constants.loaderTitleMargin*2, height: 42.0))
        }
        
        self.titleLabel?.font = self.config.titleTextFont
        self.titleLabel?.textColor = self.config.titleTextColor
        self.titleLabel?.text = self.title
        self.titleLabel?.isHidden = self.title == nil
    }
    
    var spinnerFrame: CGRect {
        let loadingViewSize = self.frame.size.width - (Constants.loaderSpinnerMarginSide * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(origin: CGPoint(x: Constants.loaderSpinnerMarginSide, y: yOffset), size: CGSize(width: loadingViewSize, height: loadingViewSize))
        }
        return CGRect(origin: CGPoint(x: Constants.loaderSpinnerMarginSide, y: Constants.loaderSpinnerMarginTop), size: CGSize(width: loadingViewSize, height: loadingViewSize))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Spinner Loading View
    class M2PLoadingView : UIView {
        
        private var speed : Int?
        private var lineWidth : Float?
        private var lineTintColor : UIColor?
        private var backgroundLayer : CAShapeLayer?
        private var isSpinning : Bool?
        private var duration: TimeInterval = 1.25
        private var timingFunction: CAMediaTimingFunction?

        var config : Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        // MARK: Setup loading view
        func setup() {
            self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
        
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = CAShapeLayerLineCap.round
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        func update() {
            self.lineWidth = self.config.spinnerLineWidth
            self.speed = self.config.speed
            
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
        }
        
        // MARK: Draw Circle
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        func drawBackgroundCircle(partial: Bool) {
            let startAngle : CGFloat = CGFloat.pi / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat.pi) + startAngle
            
            let center : CGPoint = CGPoint(x: self.bounds.size.width / 2,y: self.bounds.size.height / 2)
            let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat.pi) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath;
        }
        
        // MARK: - Start and stop spinning
        
        func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
            rotationAnimation.duration = 1;
            rotationAnimation.isCumulative = true;
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        func stop() {
            self.drawBackgroundCircle(partial: false)
            
            self.backgroundLayer?.removeAnimation(forKey: "com.zevwings.animation.rotate")
            self.backgroundLayer?.removeAnimation(forKey: "com.zevwings.animation.stroke")
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
        
        func startAnimating() {
            
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            
            let animation = CABasicAnimation()
            animation.keyPath = "transform.rotation"
            animation.duration = duration / 0.575
            animation.fromValue = 0
            animation.toValue = CGFloat(2 * Double.pi)
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false
            self.backgroundLayer?.add(animation, forKey: "com.zevwings.animation.rotate")
            
            let headAnimation = CABasicAnimation()
            headAnimation.keyPath = "strokeStart"
            headAnimation.duration = duration / 1.5
            headAnimation.fromValue = 0
            headAnimation.toValue = 0.25
            headAnimation.timingFunction = timingFunction;
            
            let tailAnimation = CABasicAnimation()
            tailAnimation.keyPath = "strokeEnd"
            tailAnimation.duration = duration / 1.5
            tailAnimation.fromValue = 0
            tailAnimation.toValue = 1
            tailAnimation.timingFunction = timingFunction;
            
            let endHeadAnimation = CABasicAnimation()
            endHeadAnimation.keyPath = "strokeStart";
            endHeadAnimation.beginTime = duration / 1.5
            endHeadAnimation.duration = duration / 3.0
            endHeadAnimation.fromValue = 0.25
            endHeadAnimation.toValue = 1.0
            endHeadAnimation.timingFunction = timingFunction;
            
            let endTailAnimation = CABasicAnimation()
            endTailAnimation.keyPath = "strokeEnd"
            endTailAnimation.beginTime = duration / 1.5
            endTailAnimation.duration = duration / 3.0
            endTailAnimation.fromValue = 1.0
            endTailAnimation.toValue = 1.0
            endTailAnimation.timingFunction = timingFunction;
            
            let animations = CAAnimationGroup()
            animations.duration = duration
            animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
            animations.repeatCount = Float.infinity
            animations.isRemovedOnCompletion = false
            self.backgroundLayer?.add(animations, forKey: "com.zevwings.animation.stroke")
        }
        
        func stopAnimating() {
            self.drawBackgroundCircle(partial: false)
            
            self.backgroundLayer?.removeAnimation(forKey: "com.zevwings.animation.rotate")
            self.backgroundLayer?.removeAnimation(forKey: "com.zevwings.animation.stroke")
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
        
        func showAnimatingDotsInImageView() {
            
            let lay = CAReplicatorLayer()
            lay.frame = CGRect(x: M2PLoader.shared.loadingView?.bounds.minX ?? 0, y: M2PLoader.shared.loadingView?.bounds.maxY ?? 0, width: 60, height: 10) //yPos == 12
            let circle = CALayer()
            circle.frame = CGRect(x: 0, y: 0, width: 9, height: 9)
            circle.cornerRadius = circle.frame.width / 2
            circle.backgroundColor = UIColor.secondaryRedColor.cgColor //lightGray.cgColor //UIColor.black.cgColor
            lay.addSublayer(circle)
            lay.instanceCount = 3
            lay.instanceTransform = CATransform3DMakeTranslation(14, 0, 0)
            let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            anim.fromValue = 1.0
            anim.toValue = 0.2
            anim.duration = 1
            anim.repeatCount = .infinity
            circle.add(anim, forKey: nil)
            lay.instanceDelay = anim.duration / Double(lay.instanceCount)
            
            self.backgroundLayer?.addSublayer(lay)
        }
    }
    
    // MARK: - Loader config
    public struct Config {
        
        /// Size of loader
        public var size : CGFloat = 126.0
        
        /// Color of spinner view
        public var spinnerColor = UIColor.secondaryRedColor
        
        /// Line width
        public var spinnerLineWidth : Float = 2.0
        
        /// Color of title text
        public var titleTextColor = UIColor.primaryActive
        
        /// Speed of the spinner
        public var speed :Int = 1
        
        /// Font for title text in loader
        public var titleTextFont : UIFont = UIFont.customFont(name: "Arial-BoldMT", size: .x13)
        
        /// Background color for loader
        public var backgroundColor = UIColor.background
        
        /// Foreground color
        public var foregroundColor = UIColor.primaryActive
        
        /// Foreground alpha CGFloat, between 0.0 and 1.0
        public var foregroundAlpha: CGFloat = 0.5
        
        /// Corner radius for loader
        public var cornerRadius : CGFloat = 10.0
        
        public init() {}
        
    }
}

// MARK: Implementation Code
/*
func SpinnerLoader() {
    var config : M2PLoader.Config = M2PLoader.Config()
//        config.size = 120
    config.backgroundColor = UIColor.background//UIColor(red:0.03, green:0.82, blue:0.7, alpha:1)
//        config.spinnerColor = UIColor.secondaryRedColor
//        config.titleTextColor = UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
    config.spinnerLineWidth = 2.0
    config.foregroundColor = UIColor.black
    config.foregroundAlpha = 0.5
    
    M2PLoader.setConfig(config)
    
    //M2PLoader.show(animated: true)
    M2PLoader.show(title: "Processing...", animated: true)
    
//        delay(seconds: 3.0) { () -> () in
//            M2PLoader.show(title: "Loading...", animated: true)
//        }
//
    delay(seconds: 6.0) { () -> () in
//            M2PLoader.hide()
    }
}
 
 func delay(seconds: Double, completion: @escaping () -> Void) {
     DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
 }
 
 */
