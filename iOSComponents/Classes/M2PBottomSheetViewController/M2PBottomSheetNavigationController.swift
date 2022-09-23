//
//  BottomPopupNavigationController.swift
//  BottomPopup
//
//  Created by SENTHIL KUMAR on 12/09/22.
//

import UIKit

open class M2PBottomSheetNavigationController: UINavigationController, M2PBottomPopupAttributesDelegate {
    
    
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
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        curveTopCorners()
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

extension M2PBottomSheetNavigationController {
    open func updatePopupHeight(to height: CGFloat) {
        transitionHandler?.setHeight(to: height)
    }
}


