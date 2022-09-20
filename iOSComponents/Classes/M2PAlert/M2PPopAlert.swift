//
//  CustomAlert.swift
//  iOSComponents
//
//  Created by Balaji  on 07/09/22.
//

import UIKit


public protocol M2PPopAlertDelegate: AnyObject {
    func okButtonPressed(_ alert: M2PPopAlert, alertTag: Int)
    func cancelButtonPressed(_ alert: M2PPopAlert, alertTag: Int)
    func learnButtonPressed(_ alert: M2PPopAlert, alertTag: Int)
}

public class M2PPopAlert: UIViewController {
    
    public enum AlertFramePosition {
        case Top, Center, Bottom
    }
    
    public enum buttonType {
        case Leading, Center, Trailing
    }
    
    @IBOutlet private weak var horizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var messageLabel: UILabel!
    @IBOutlet weak public var trailingButton: M2PButton!
    @IBOutlet weak public var centerButton: M2PButton!
    @IBOutlet weak public var leadingButton: M2PButton!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var alertView: UIView!{
        didSet{
            self.alertView.layer.cornerRadius = 20
        }
    }
    
    public var alertBgColor: UIColor? = .white
    public var bgImgColor: UIColor = .DavysGrey100
    public var alertTitle: String?
    public var alertTitleColor: UIColor? = .black
    public var titleFont: UIFont?
    public var alertMessage: String?
    public var alertMessageColor: UIColor? = .black
    public var messageFont: UIFont?
    public var alertTag = 0
    public var isHideAlertImage = false
    public var statusImage: UIImage?
    public weak var delegate: M2PPopAlertDelegate?
    public var posistion: AlertFramePosition = .Center
    public var enableButtonList: [buttonType] = [.Leading,.Center,.Trailing]
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    
    public func show() {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    fileprivate func setupAlert() {
        self.statusView.isHidden = self.isHideAlertImage
        self.titleLabel.text = self.alertTitle
        self.messageLabel.text = self.alertMessage
        self.statusImageView.image = self.statusImage
        self.titleLabel.textColor = self.alertTitleColor
        self.messageLabel.textColor = self.alertMessageColor
        self.titleLabel.font = self.titleFont
        self.messageLabel.font = self.messageFont
        self.alertView.backgroundColor = self.alertBgColor
        self.backgroundImgView.backgroundColor = self.bgImgColor.withAlphaComponent(0.8)
        
        
        self.statusView.isHidden = (self.statusImage == nil) ? true : false
        self.titleView.isHidden = (self.alertTitle == "" || self.alertTitle == nil) ? true : false
        self.messageView.isHidden = (self.alertMessage == "" || self.alertMessage == nil) ? true : false
        
        self.setupframe()
        
        switch posistion {
        case .Top:
            self.alertView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        case .Bottom:
            self.alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        default:
            self.alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        switch self.enableButtonList {
        case [.Leading ,.Center],[.Center ,.Leading]:
            trailingButton.isHidden = true
        case [.Leading ,.Trailing ], [.Trailing ,.Leading ]:
            centerButton.isHidden = true
        case [.Center ,.Trailing ], [.Center ,.Trailing ]:
            leadingButton.isHidden = true
        case [.Leading ]:
            trailingButton.isHidden = true
            centerButton.isHidden = true
        case [.Trailing]:
            leadingButton.isHidden = true
            centerButton.isHidden = true
        case [.Center ]:
            leadingButton.isHidden = true
            trailingButton.isHidden = true
        default:   leadingButton.isHidden = false
            trailingButton.isHidden = false
            centerButton.isHidden = false
        }
    }
    
    func setupframe() {
        self.view.removeConstraint(self.horizontalConstraint)
    }
    
    @IBAction func actionOnOkButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.okButtonPressed(self, alertTag: alertTag)
    }
    
    @IBAction func actionOnCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.cancelButtonPressed(self, alertTag: alertTag)
    }
    
    @IBAction func actionOnLearnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.learnButtonPressed(self, alertTag: alertTag)
    }
}

