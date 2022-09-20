//
//  M2PBottomSheetViewController.swift
//  Trendyol
//
//  Created by SENTHIL KUMAR on 12/09/22.
//

//MARK: Implementation
/* let popupNavController = self.storyboard?.instantiateViewController(withIdentifier: "CheckBottomSheetNavigation") as! CheckBottomSheetNavigation
 popupNavController.height = 500
 popupNavController.topCornerRadius = 35
 popupNavController.presentDuration = 0.5
 popupNavController.dismissDuration = 0.5
 popupNavController.shouldDismissInteractivelty = true
 self.navigationController?.present(popupNavController, animated: true, completion: nil)
 
 import UIKit
 import iOSComponents
     
 class CheckBottomSheetNavigation: M2PBottomSheetNavigationController {

     var height: CGFloat?
     var topCornerRadius: CGFloat?
     var presentDuration: Double?
     var dismissDuration: Double?
     var shouldDismissInteractivelty: Bool?
     
     // Bottom popup attribute variables
     // You can override the desired variable to change appearance
     
     override var popupHeight: CGFloat {
         return height ?? CGFloat(300)
     }
     
     
     override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
     
     override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
     
     override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
     
     override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
     
     override var popupDimmingViewAlpha: CGFloat {
         return BottomPopupConstants.kDimmingViewDefaultAlphaValue
         
     }

 }

 */

import UIKit

// MARK: BottomPopupUtils
typealias BottomPresentableViewController = BottomPopupAttributesDelegate & UIViewController

public protocol BottomPopupDelegate: class {
    func bottomPopupViewLoaded()
    func bottomPopupWillAppear()
    func bottomPopupDidAppear()
    func bottomPopupWillDismiss()
    func bottomPopupDidDismiss()
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

public extension BottomPopupDelegate {
    func bottomPopupViewLoaded() { }
    func bottomPopupWillAppear() { }
    func bottomPopupDidAppear() { }
    func bottomPopupWillDismiss() { }
    func bottomPopupDidDismiss() { }
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) { }
}

public protocol BottomPopupAttributesDelegate: class {
    var popupHeight: CGFloat { get }
    var popupTopCornerRadius: CGFloat { get }
    var popupPresentDuration: Double { get }
    var popupDismissDuration: Double { get }
    var popupShouldDismissInteractivelty: Bool { get }
    var popupDimmingViewAlpha: CGFloat { get }
    var popupShouldBeganDismiss: Bool { get }
    var popupViewAccessibilityIdentifier: String { get }
}

public struct BottomPopupConstants {
    public static let kDefaultHeight: CGFloat = 377.0
    public static let kDefaultHeightMax: CGFloat = 377.0
    public static let kDefaultTopCornerRadius: CGFloat = 10.0
    public static let kDefaultPresentDuration = 0.5
    public static let kDefaultDismissDuration = 0.5
    public static let dismissInteractively = true
    public static let shouldBeganDismiss = true
    public static let kDimmingViewDefaultAlphaValue: CGFloat = 0.5
    public static let defaultPopupViewAccessibilityIdentifier: String = "bottomPopupView"
}

// MARK: M2PBottomSheetViewController
open class M2PBottomSheetViewController: UIViewController, BottomPopupAttributesDelegate {
    
    
    
    private var transitionHandler: BottomPopupTransitionHandler?
    open weak var popupDelegate: BottomPopupDelegate?
    
    // MARK: Initializations
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        transitionHandler?.notifyViewLoaded(withPopupDelegate: popupDelegate)
        popupDelegate?.bottomPopupViewLoaded()
        self.view.accessibilityIdentifier = popupViewAccessibilityIdentifier
    }
    
    open override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        curveTopCorners()
        popupDelegate?.bottomPopupWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        popupDelegate?.bottomPopupDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        popupDelegate?.bottomPopupWillDismiss()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        popupDelegate?.bottomPopupDidDismiss()
    }
    
    //MARK: Private Methods
    
    private func initialize() {
        transitionHandler = BottomPopupTransitionHandler(popupViewController: self)
        transitioningDelegate = transitionHandler
        modalPresentationStyle = .custom
    }
    
    private func curveTopCorners() {
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: popupTopCornerRadius, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
    }
    
    //MARK: BottomPopupAttributesDelegate Variables
    
    open var popupHeight: CGFloat {
        get {
            return BottomPopupConstants.kDefaultHeight
        }
        set {
            popupHeight = newValue
        }
    }
   
    open var popupTopCornerRadius: CGFloat { return BottomPopupConstants.kDefaultTopCornerRadius }
    
    open var popupPresentDuration: Double { return BottomPopupConstants.kDefaultPresentDuration }
    
    open var popupDismissDuration: Double { return BottomPopupConstants.kDefaultDismissDuration }
    
    open var popupShouldDismissInteractivelty: Bool { return BottomPopupConstants.dismissInteractively }
    
    open var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }
    
    open var popupShouldBeganDismiss: Bool { return BottomPopupConstants.shouldBeganDismiss }
    
    open var popupViewAccessibilityIdentifier: String { return BottomPopupConstants.defaultPopupViewAccessibilityIdentifier }
}

extension M2PBottomSheetViewController {
    open func updatePopupHeight(to height: CGFloat) {
        transitionHandler?.setHeight(to: height)
    }
}

//MARK: BottomPopupDismissInteractionController
protocol BottomPopupDismissInteractionControllerDelegate: class {
    func dismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

final class BottomPopupDismissInteractionController: UIPercentDrivenInteractiveTransition {
    private let kMinPercentOfVisiblePartToCompleteAnimation = CGFloat(0.5)
    private let kSwipeDownThreshold = CGFloat(1000)
    private weak var presentedViewController: BottomPresentableViewController?
    private weak var transitioningDelegate: BottomPopupTransitionHandler?
    private unowned var attributesDelegate: BottomPopupAttributesDelegate
    weak var delegate: BottomPopupDismissInteractionControllerDelegate?
    
    private var currentPercent: CGFloat = 0 {
        didSet {
            delegate?.dismissInteractionPercentChanged(from: oldValue, to: currentPercent)
        }
    }
    
    init(presentedViewController: BottomPresentableViewController?, attributesDelegate: BottomPopupAttributesDelegate) {
        self.presentedViewController = presentedViewController
        self.transitioningDelegate = presentedViewController?.transitioningDelegate as? BottomPopupTransitionHandler
        self.attributesDelegate = attributesDelegate
        super.init()
        preparePanGesture(in: presentedViewController?.view)
    }
    
    private func finishAnimation(withVelocity velocity: CGPoint) {
        if currentPercent > kMinPercentOfVisiblePartToCompleteAnimation || velocity.y > kSwipeDownThreshold {
            finish()
        } else {
            
            cancel()
        }
    }
    
    private func preparePanGesture(in view: UIView?) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        presentedViewController?.view?.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ pan: UIPanGestureRecognizer) {
        guard attributesDelegate.popupShouldBeganDismiss else { return }
        let translationY = pan.translation(in: presentedViewController?.view).y
  
            currentPercent = min(max(translationY/(presentedViewController?.view.frame.size.height ?? 0), 0), 1)
    switch pan.state {
        case .began:
            transitioningDelegate?.isInteractiveDismissStarted = true
            presentedViewController?.dismiss(animated: true, completion: nil)
        case .changed:
        if currentPercent == 0 {
            
//                pan.setTranslation(CGPoint.zero, in: self.view)
//            let redY:CGFloat = (presentedViewController?.view.frame.origin.y ?? 0) + translationY
//                    presentedViewController?.view.frame.origin.y = CGFloat(redY)
//            presentedViewController?.view.layoutIfNeeded()
//            UIView.animate(withDuration: 0.2, animations: { () -> Void in
//                let newHeight = UIScreen.main.bounds.height - 120
//                self.presentedViewController?.view.frame.size.height = newHeight
//                self.presentedViewController?.view.layoutIfNeeded()
//            })
        } else {
            update(currentPercent)
        }
        default:
            let velocity = pan.velocity(in: presentedViewController?.view)
            transitioningDelegate?.isInteractiveDismissStarted = false
            finishAnimation(withVelocity: velocity)
        }
    }
}

// MARK: BottomPopupTransitionHandler
final class BottomPopupTransitionHandler: NSObject, UIViewControllerTransitioningDelegate {
    private let presentAnimator: BottomPopupPresentAnimator
    private let dismissAnimator: BottomPopupDismissAnimator
    private var interactionController: BottomPopupDismissInteractionController?
    private var bottomPopupPresentationController: BottomPopupPresentationController?
    private unowned var popupViewController: BottomPresentableViewController
    fileprivate weak var popupDelegate: BottomPopupDelegate?
    var isInteractiveDismissStarted = false
    
    init(popupViewController: BottomPresentableViewController) {
        self.popupViewController = popupViewController
        
        presentAnimator = BottomPopupPresentAnimator(attributesOwner: popupViewController)
        dismissAnimator = BottomPopupDismissAnimator(attributesOwner: popupViewController)
    }
    
    //MARK: Public
    func notifyViewLoaded(withPopupDelegate delegate: BottomPopupDelegate?) {
        self.popupDelegate = delegate
        if popupViewController.popupShouldDismissInteractivelty {
            interactionController = BottomPopupDismissInteractionController(presentedViewController: popupViewController, attributesDelegate: popupViewController)
            interactionController?.delegate = self
        }
    }
    
    //MARK: Specific animators
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        bottomPopupPresentationController = BottomPopupPresentationController(presentedViewController: presented, presenting: presenting, attributesDelegate: popupViewController)
        return bottomPopupPresentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractiveDismissStarted ? interactionController : nil
    }
}

extension BottomPopupTransitionHandler: BottomPopupDismissInteractionControllerDelegate {
    func dismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        popupDelegate?.bottomPopupDismissInteractionPercentChanged(from: oldValue, to: newValue)
    }
}
extension BottomPopupTransitionHandler {
     func setHeight(to height: CGFloat) {
         bottomPopupPresentationController?.setHeight(to: height)
     }
 }

// MARK: BottomPopupPresentationController
final class BottomPopupPresentationController: UIPresentationController {
    private var dimmingView: UIView!
    private var popupHeight: CGFloat
    private unowned var attributesDelegate: BottomPopupAttributesDelegate
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            return CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height - popupHeight), size: CGSize(width: presentedViewController.view.frame.size.width, height: popupHeight))
        }
    }
    
    private func changeDimmingViewAlphaAlongWithAnimation(to alpha: CGFloat) {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        })
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, attributesDelegate: BottomPopupAttributesDelegate) {
        self.attributesDelegate = attributesDelegate
        popupHeight = attributesDelegate.popupHeight
        presentingViewController?.view.frame = CGRect.init(x: 0, y: CGFloat(50), width: UIScreen.main.bounds.width, height: popupHeight)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        changeDimmingViewAlphaAlongWithAnimation(to: attributesDelegate.popupDimmingViewAlpha)
    }
    
    override func dismissalTransitionWillBegin() {
        changeDimmingViewAlphaAlongWithAnimation(to: 0)
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        guard attributesDelegate.popupShouldBeganDismiss else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        guard attributesDelegate.popupShouldBeganDismiss else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

private extension BottomPopupPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = [.down, .up]
        dimmingView.isUserInteractionEnabled = true
        [tapGesture, swipeGesture].forEach { dimmingView.addGestureRecognizer($0) }
    }
}

extension BottomPopupPresentationController {
     func setHeight(to height: CGFloat) {
        popupHeight = height
        UIView.animate(withDuration: attributesDelegate.popupPresentDuration) {
            self.containerViewWillLayoutSubviews()
        }
     }
 }


// MARK: BottomPopupDismissAnimator
final class BottomPopupDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private unowned var attributesOwner: BottomPresentableViewController
    
    init(attributesOwner: BottomPresentableViewController) {
        self.attributesOwner = attributesOwner
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return attributesOwner.popupDismissDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let dismissFrame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height), size: fromVC.view.frame.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = dismissFrame
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

// MARK: BottomPopupPresentAnimator
final class BottomPopupPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private unowned var attributesOwner: BottomPresentableViewController
    
    init(attributesOwner: BottomPresentableViewController) {
        self.attributesOwner = attributesOwner
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return attributesOwner.popupPresentDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        transitionContext.containerView.addSubview(toVC.view)
        let presentFrame = transitionContext.finalFrame(for: toVC)
        let initialFrame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height), size: presentFrame.size)
        toVC.view.frame = initialFrame
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.frame = presentFrame
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
