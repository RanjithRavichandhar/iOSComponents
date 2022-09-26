//
//  M2PCustomAlert.swift
//  iOSComponents
//
//  Created by Balaji  on 09/09/22.
//

import UIKit

public protocol M2PCustomAlertDelegate: AnyObject {
    func submitButtonPressed(_ alert: M2PCustomAlert, alertTag: Int)
    func secondaryButtonPressed(_ alert: M2PCustomAlert, alertTag: Int)
    func closeButtonPressed(_ alert: M2PCustomAlert, alertTag: Int)
}


public class M2PCustomAlert: UIViewController {
    
    public enum AlertFramePosition {
        case Top, Center, Bottom
    }
    
    public enum buttonType {
        case primary, secondary
    }
    
    @IBOutlet private weak var horizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var messageLabel: UILabel!
    @IBOutlet weak public var submitView: UIView!
    @IBOutlet weak public var textFieldView: UIView!
    @IBOutlet weak public var submitButton: M2PButton!
    @IBOutlet weak public var secondaryButton: M2PButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var secondaryView: UIView!
    @IBOutlet weak public var textField: UITextField!{
        didSet{
            self.textField.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak public var statusImageView: UIImageView!
    @IBOutlet weak public var alertView: UIView!{
        didSet{
            self.alertView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak public var closeButton: UIButton!
    @IBOutlet weak public var stackView: UIStackView!
    
    @IBOutlet weak var backgroundImgView: UIImageView!
    public var alertBgColor: UIColor = .white
    public var bgImgColor: UIColor = .DavysGrey100
    public var alertTitle: String?
    public var alertTitleColor : UIColor?
    public var titleFont : UIFont?
    public var alertMessage: String?
    public var alertMessageColor : UIColor?
    public var messageFont : UIFont?
    public var submitButtonTitle = "Ok"
    public var placeHolderText = "Type Here"
    public var alertTag = 0
    public var statusImage: UIImage?
    public var closeImage = UIImage(named: "close.png", in: M2PComponentsBundle.shared.currentBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    public var text = ""
    public weak var delegate: M2PCustomAlertDelegate?
    public var posistion: AlertFramePosition = .Center
    public var didChange: ((String) -> Void)?
    public var closeTintColor: UIColor?
    public var enableButtonList: [buttonType] = [.primary,.secondary]
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        self.titleLabel.text = self.alertTitle
        self.messageLabel.text = self.alertMessage
        self.statusImageView.image = self.statusImage
        self.closeButton.setBackgroundImage(self.closeImage, for: .normal)
        self.submitButton.setTitle(self.submitButtonTitle, for: .normal)
        self.textField.placeholder = self.placeHolderText
        self.titleLabel.font = self.titleFont
        self.messageLabel.font = self.messageFont
        self.closeButton.tintColor = self.closeTintColor
        self.titleLabel.textColor = self.alertTitleColor
        self.messageLabel.textColor = self.alertMessageColor
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
        case [.primary ]:
            secondaryView.isHidden = true
        case [.secondary]:
            secondaryView.isHidden = true
            textFieldView.isHidden = true
        default:
            secondaryView.isHidden = false
            textFieldView.isHidden = false
            secondaryView.isHidden = false
        }
    }
    
    func setupframe() {
        self.view.removeConstraint(self.horizontalConstraint)
        
    }
    
    @objc fileprivate func didChangeText(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        self.text = text
        didChange?(sender.text!)
    }
    
    @IBAction func actionOnSubmitButton(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        delegate?.submitButtonPressed(self, alertTag: alertTag)
    }
    
    @IBAction func actionOnSecondaryButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.secondaryButtonPressed(self, alertTag: alertTag)
    }
    
    @IBAction func actionOnCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.closeButtonPressed(self, alertTag: alertTag)
    }
}


extension M2PCustomAlert {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

 // Code implementation
 // MARK: - CUSTOM ALERT
 /*
  @IBAction func alertCustomActn(_ sender: UIButton){
      let customAlert = M2PCustomAlert(nibName: "M2PCustomAlert", bundle: M2PComponentsBundle.shared.currentBundle)
      customAlert.enableButtonList = [.primary, .secondary]
      customAlert.posistion = .Bottom // .Top , .Center , .Bottom
      customAlert.alertBgColor = UIColor.background
      customAlert.alertTitleColor = UIColor.primaryActive
      customAlert.alertMessageColor = UIColor.focusedLine
      customAlert.titleFont = UIFont.customFont(name: "Arial-BoldMT", size: .x20)
      customAlert.messageFont = UIFont.customFont(name: "Arial", size: .x18)
      customAlert.alertTitle = "Verification"
      customAlert.alertMessage = "Your Information in the audit, Please wait!"
      customAlert.statusImage = UIImage.init(named: "alert")
      customAlert.delegate = self
      customAlert.alertTag = 1
      customAlert.closeTintColor = .primaryActive
      customAlert.delegate = self
      customAlert.bgImgColor = .DavysGrey100
      customAlert.show()
      // MARK: M2PButton should configure after present Pop (i.e) after called func show()
      customAlert.submitButton.config(type: .custom,title: "Submit", isPrimary: false, bgColor: .backgroundLightVarient)
      customAlert.secondaryButton.config(type: .custom, title: "Cancel", bgColor: .backgroundLightVarient)
      // Textfield
      customAlert.didChange = { text in
          print(text)
      }
  }

 }*/
