//
//  M2PBottomSheetViewController.swift
//  Trendyol
//
//  Created by SENTHIL KUMAR on 12/09/22.
//

//MARK: Implementation\
//MARK: Note:- Root View Controller must be set in appDelegate.
/* let popupNavController = self.storyboard?.instantiateViewController(withIdentifier: "CheckBottomSheetNavigation") as! CheckBottomSheetNavigation
 popupNavController.height = 500
 popupNavController.topCornerRadius = 35
 popupNavController.presentDuration = 0.5
 popupNavController.dismissDuration = 0.5
 popupNavController.shouldBeganDismiss = true // dismiss using both tap and swipe
 popupNavController.shouldDismissInteractivelty = true // used to restrict the swipe dismiss
 self.navigationController?.present(popupNavController, animated: true, completion: nil)
 
 import UIKit
 import iOSComponents
     
 //MARK: Note:- In storyboard, set this class name to the NavigationController
 class CheckBottomSheetNavigation: M2PBottomSheetNavigationController {

     var height: CGFloat?
     var topCornerRadius: CGFloat?
     var presentDuration: Double?
     var dismissDuration: Double?
     var shouldDismissInteractivelty: Bool?
     var shouldBeganDismiss: Bool?
     
     // Bottom popup attribute variables
     // You can override the desired variable to change appearance
     
     override var M2PPopupHeight: CGFloat {
         return height ?? CGFloat(300)
     }
     
     
     override var M2PPopupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
     
     override var M2PPopupPresentDuration: Double { return presentDuration ?? 1.0 }
     
     override var M2PPopupDismissDuration: Double { return dismissDuration ?? 1.0 }
     
     override var M2PPopupShouldBeganDismiss: Bool { return shouldBeganDismiss ?? true }
 
     override var M2PPopupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
     
     override var M2PPopupDimmingViewAlpha: CGFloat {
         return M2PBottomPopupConstants.kDimmingViewDefaultAlphaValue
         
     }

 }

 */

import UIKit

// MARK: BottomPopupUtils
typealias BottomPresentableViewController = M2PBottomPopupAttributesDelegate & UIViewController

public protocol M2PBottomPopupDelegate: AnyObject {
    func M2PBottomPopupViewLoaded()
    func M2PBottomPopupWillAppear()
    func M2PBottomPopupDidAppear()
    func M2PBottomPopupWillDismiss()
    func M2PBottomPopupDidDismiss()
    func M2PBottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

public extension M2PBottomPopupDelegate {
    func M2PBottomPopupViewLoaded() { }
    func M2PBottomPopupWillAppear() { }
    func M2PBottomPopupDidAppear() { }
    func M2PBottomPopupWillDismiss() { }
    func M2PBottomPopupDidDismiss() { }
    func M2PBottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) { }
}

public protocol M2PBottomPopupAttributesDelegate: AnyObject {
    var M2PPopupHeight: CGFloat { get }
    var M2PPopupTopCornerRadius: CGFloat { get }
    var M2PPopupPresentDuration: Double { get }
    var M2PPopupDismissDuration: Double { get }
    var M2PPopupShouldDismissInteractivelty: Bool { get }
    var M2PPopupDimmingViewAlpha: CGFloat { get }
    var M2PPopupShouldBeganDismiss: Bool { get }
    var M2PPopupViewAccessibilityIdentifier: String { get }
}

public struct M2PBottomPopupConstants {
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
open class M2PBottomSheetViewController: UIViewController, M2PBottomPopupAttributesDelegate {
    
    
    
    private var transitionHandler: M2PBottomPopupTransitionHandler?
    open weak var popupDelegate: M2PBottomPopupDelegate?
    
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
        popupDelegate?.M2PBottomPopupViewLoaded()
        self.view.accessibilityIdentifier = M2PPopupViewAccessibilityIdentifier
    }
    
    open override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        popupDelegate?.M2PBottomPopupWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        popupDelegate?.M2PBottomPopupDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        popupDelegate?.M2PBottomPopupWillDismiss()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        popupDelegate?.M2PBottomPopupDidDismiss()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        curveTopCorners()
    }
    
    //MARK: Private Methods
    
    private func initialize() {
        transitionHandler = M2PBottomPopupTransitionHandler(popupViewController: self)
        transitioningDelegate = transitionHandler
        modalPresentationStyle = .custom
    }
    
    private func curveTopCorners() {
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: M2PPopupTopCornerRadius, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
    }
    
    //MARK: BottomPopupAttributesDelegate Variables
    
    open var M2PPopupHeight: CGFloat {
        return M2PBottomPopupConstants.kDefaultHeight
    }
   
    open var M2PPopupTopCornerRadius: CGFloat { return M2PBottomPopupConstants.kDefaultTopCornerRadius }
    
    open var M2PPopupPresentDuration: Double { return M2PBottomPopupConstants.kDefaultPresentDuration }
    
    open var M2PPopupDismissDuration: Double { return M2PBottomPopupConstants.kDefaultDismissDuration }
    
    open var M2PPopupShouldDismissInteractivelty: Bool { return M2PBottomPopupConstants.dismissInteractively }
    
    open var M2PPopupDimmingViewAlpha: CGFloat { return M2PBottomPopupConstants.kDimmingViewDefaultAlphaValue }
    
    open var M2PPopupShouldBeganDismiss: Bool { return M2PBottomPopupConstants.shouldBeganDismiss }
    
    open var M2PPopupViewAccessibilityIdentifier: String { return M2PBottomPopupConstants.defaultPopupViewAccessibilityIdentifier }
}

extension M2PBottomSheetViewController {
    open func updatePopupHeight(to height: CGFloat) {
        transitionHandler?.setHeight(to: height)
    }
}

//MARK: BottomPopupDismissInteractionController
protocol BottomPopupDismissInteractionControllerDelegate: AnyObject {
    func dismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

final class M2PBottomPopupDismissInteractionController: UIPercentDrivenInteractiveTransition {
    private let kMinPercentOfVisiblePartToCompleteAnimation = CGFloat(0.5)
    private let kSwipeDownThreshold = CGFloat(1000)
    private weak var presentedViewController: BottomPresentableViewController?
    private weak var transitioningDelegate: M2PBottomPopupTransitionHandler?
    private unowned var attributesDelegate: M2PBottomPopupAttributesDelegate
    weak var delegate: BottomPopupDismissInteractionControllerDelegate?
    
    private var currentPercent: CGFloat = 0 {
        didSet {
            delegate?.dismissInteractionPercentChanged(from: oldValue, to: currentPercent)
        }
    }
    
    init(presentedViewController: BottomPresentableViewController?, attributesDelegate: M2PBottomPopupAttributesDelegate) {
        self.presentedViewController = presentedViewController
        self.transitioningDelegate = presentedViewController?.transitioningDelegate as? M2PBottomPopupTransitionHandler
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
        guard attributesDelegate.M2PPopupShouldBeganDismiss else { return }
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
final class M2PBottomPopupTransitionHandler: NSObject, UIViewControllerTransitioningDelegate {
    private let presentAnimator: M2PBottomPopupPresentAnimator
    private let dismissAnimator: M2PBottomPopupDismissAnimator
    private var interactionController: M2PBottomPopupDismissInteractionController?
    private var bottomPopupPresentationController: M2PBottomPopupPresentationController?
    private unowned var popupViewController: BottomPresentableViewController
    fileprivate weak var popupDelegate: M2PBottomPopupDelegate?
    var isInteractiveDismissStarted = false
    
    init(popupViewController: BottomPresentableViewController) {
        self.popupViewController = popupViewController
        
        presentAnimator = M2PBottomPopupPresentAnimator(attributesOwner: popupViewController)
        dismissAnimator = M2PBottomPopupDismissAnimator(attributesOwner: popupViewController)
    }
    
    //MARK: Public
    func notifyViewLoaded(withPopupDelegate delegate: M2PBottomPopupDelegate?) {
        self.popupDelegate = delegate
        if popupViewController.M2PPopupShouldDismissInteractivelty {
            interactionController = M2PBottomPopupDismissInteractionController(presentedViewController: popupViewController, attributesDelegate: popupViewController)
            interactionController?.delegate = self
        }
    }
    
    //MARK: Specific animators
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        bottomPopupPresentationController = M2PBottomPopupPresentationController(presentedViewController: presented, presenting: presenting, attributesDelegate: popupViewController)
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

extension M2PBottomPopupTransitionHandler: BottomPopupDismissInteractionControllerDelegate {
    func dismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        popupDelegate?.M2PBottomPopupDismissInteractionPercentChanged(from: oldValue, to: newValue)
    }
}
extension M2PBottomPopupTransitionHandler {
     func setHeight(to height: CGFloat) {
         bottomPopupPresentationController?.setHeight(to: height)
     }
 }

// MARK: BottomPopupPresentationController
final class M2PBottomPopupPresentationController: UIPresentationController {
    private var dimmingView: UIView!
    private var popupHeight: CGFloat
    private unowned var attributesDelegate: M2PBottomPopupAttributesDelegate
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            return CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height - popupHeight), size: CGSize(width: UIScreen.main.bounds.width, height: popupHeight))
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
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, attributesDelegate: M2PBottomPopupAttributesDelegate) {
        self.attributesDelegate = attributesDelegate
        popupHeight = attributesDelegate.M2PPopupHeight
        presentingViewController?.view.frame = CGRect.init(x: 0, y: CGFloat(50), width: UIScreen.main.bounds.width, height: popupHeight)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        changeDimmingViewAlphaAlongWithAnimation(to: attributesDelegate.M2PPopupDimmingViewAlpha)
    }
    
    override func dismissalTransitionWillBegin() {
        changeDimmingViewAlphaAlongWithAnimation(to: 0)
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        guard attributesDelegate.M2PPopupShouldBeganDismiss else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        guard attributesDelegate.M2PPopupShouldBeganDismiss else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

private extension M2PBottomPopupPresentationController {
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

extension M2PBottomPopupPresentationController {
     func setHeight(to height: CGFloat) {
        popupHeight = height
        UIView.animate(withDuration: attributesDelegate.M2PPopupPresentDuration) {
            self.containerViewWillLayoutSubviews()
        }
     }
 }


// MARK: BottomPopupDismissAnimator
final class M2PBottomPopupDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private unowned var attributesOwner: BottomPresentableViewController
    
    init(attributesOwner: BottomPresentableViewController) {
        self.attributesOwner = attributesOwner
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return attributesOwner.M2PPopupDismissDuration
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
final class M2PBottomPopupPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private unowned var attributesOwner: BottomPresentableViewController
    
    init(attributesOwner: BottomPresentableViewController) {
        self.attributesOwner = attributesOwner
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return attributesOwner.M2PPopupPresentDuration
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


