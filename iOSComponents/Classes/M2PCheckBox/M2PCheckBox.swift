//
//  M2PCheckBox.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 07/09/22.
//

// MARK: Implementation

/* checkBox1.M2PSetUpCheckBox(forSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_fill"), darkModeImage: UIImage(named: "checkboxDark_fill")), forUnSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_unfill"), darkModeImage: UIImage(named: "checkbox_unfill")), initialState: .selected, checkBoxShapes: .box)
 
 checkBox2.M2PSetUpCheckBox(forSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_fill"), darkModeImage: UIImage(named: "checkbox_roundDark_fill")), forUnSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_unfill"), darkModeImage: UIImage(named: "checkbox_round_unfill")), initialState: .unSelected, checkBoxShapes: .round)
 
 
 checkBox1.M2POnClick = { (isSelected, sender) in
 print(isSelected)
 }
 checkBox1.M2PEnableDisableCheckBox(state: .enable, withState: .unSelected)
 checkBox2.M2PEnableDisableCheckBox(state: .disable, withState: .selected) */

import Foundation
import UIKit

// MARK: For CheckBox Selection State
public enum M2PCheckBoxSelectionState{
    case selected, unSelected
}

// MARK: For CheckBox Properties
public class M2PCheckBoxProperties {
    var lightModeImage: UIImage? = nil
    var darkModeImage: UIImage? = nil
    
    public init(lightModeImage: UIImage? = nil, darkModeImage: UIImage? = nil) {
        self.lightModeImage = lightModeImage
        self.darkModeImage = darkModeImage
    }
}

// MARK: For CheckBox State
public enum M2PCheckBoxState {
    case enable, disable
    public enum M2PWithState {
        case selected, unSelected
    }
}

// MARK: For CheckBox Shapes
public enum M2PCheckBoxShapes {
    case box, round
}

public class M2PCheckBox: UIView {
    
    // MARK: Store Selected/ UnSelected Image
    var selectedImageIconLight = UIImage()
    var UnSelectedImageIconLight = UIImage()
    var selectedImageIconDark = UIImage()
    var UnSelectedImageIconDark = UIImage()
    
    public var checkBoxShapes: M2PCheckBoxShapes = .box {
        didSet {
            self.setDefaultCheckBoxShape(shape: self.checkBoxShapes)
        }
    }
    //    // MARK: Store Selected/ UnSelected TintColor
    //    var selectedTintColor = UIColor()
    //    var UnSelectedTintColor = UIColor()
    
    // MARK: For Handling Enable/Disable
    var isEnable = true
    
    // MARK: For Click Action
    public var M2POnClick:((Bool, UITapGestureRecognizer) -> Void)?
    
    // MARK: Set Check Box Image
    private lazy var checkBoxImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.bounds.size = CGSize(width: self.frame.width, height: self.frame.height)
        return image
    }()
    
    // MARK: Set Disable View
    private lazy var disableView: UIView = {
        let view = UIView()
        view.backgroundColor = .formDisableFilled.withAlphaComponent(0.9)
        view.bounds.size = CGSize(width: self.frame.width, height: self.frame.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    // MARK: - LifeCycles
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: update color while changing Light and Dark Mode
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                if self.checkBoxImageView.image == self.selectedImageIconLight {
                    self.checkBoxImageView.image = self.selectedImageIconDark
                } else if self.checkBoxImageView.image == self.UnSelectedImageIconLight {
                    self.checkBoxImageView.image = self.UnSelectedImageIconDark
                }
            } else if self.traitCollection.userInterfaceStyle == .light {
                if self.checkBoxImageView.image == self.selectedImageIconDark{
                    self.checkBoxImageView.image = self.selectedImageIconLight
                } else if self.checkBoxImageView.image == self.UnSelectedImageIconDark {
                    self.checkBoxImageView.image = self.UnSelectedImageIconLight
                }
            }
        } else {
            if self.checkBoxImageView.image == self.selectedImageIconDark{
                self.checkBoxImageView.image = self.selectedImageIconLight
            } else if self.checkBoxImageView.image == self.UnSelectedImageIconDark {
                self.checkBoxImageView.image = self.UnSelectedImageIconLight
            }
        }
    }
    
    // MARK: Initial Loads
    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.checkBoxImageView)
        self.addSubview(self.disableView)
        self.disableView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        self.addGestureRecognizer(tap)
        self.setConstraints()
        self.checkBoxShapes = .box
        
    }
    
    func setDefaultCheckBoxShape(shape: M2PCheckBoxShapes) {
        let resourcesBundle = M2PComponentsBundle.shared.currentBundle
        let checkBoxBlackSelect = UIImage(named: "checkBoxBlackSelect.png", in: resourcesBundle, compatibleWith: nil)
        let checkBoxUnSelect = UIImage(named: "checkBoxUnSelect.png", in: resourcesBundle, compatibleWith: nil)
        let checkBoxWhiteSelect = UIImage(named: "checkBoxWhiteSelect.png", in: resourcesBundle, compatibleWith: nil)
        
        let checkRoundBlackSelect = UIImage(named: "checkRoundBlackSelect.png", in: resourcesBundle, compatibleWith: nil)
        let checkRoundUnSelect = UIImage(named: "checkRoundUnSelect.png", in: resourcesBundle, compatibleWith: nil)
        let checkRoundWhiteSelect = UIImage(named: "checkRoundWhiteSelect.png", in: resourcesBundle, compatibleWith: nil)
        
        guard let checkBoxBlackSelect = checkBoxBlackSelect, let checkBoxUnSelect = checkBoxUnSelect, let checkBoxWhiteSelect = checkBoxWhiteSelect, let checkRoundBlackSelect = checkRoundBlackSelect, let checkRoundUnSelect = checkRoundUnSelect, let checkRoundWhiteSelect = checkRoundWhiteSelect else {
            return
        }
        
        self.selectedImageIconLight = shape == .box ? checkBoxBlackSelect : checkRoundBlackSelect
        self.UnSelectedImageIconLight = shape == .box ? checkBoxUnSelect : checkRoundUnSelect
        self.selectedImageIconDark = shape == .box ? checkBoxWhiteSelect : checkRoundWhiteSelect
        self.UnSelectedImageIconDark = shape == .box ? checkBoxUnSelect : checkRoundUnSelect
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
//                print("Dark mode")
                self.checkBoxImageView.image = self.UnSelectedImageIconDark
            }
            else {
//                print("Light mode")
                self.checkBoxImageView.image = self.UnSelectedImageIconLight
            }
        } else {
            self.checkBoxImageView.image = self.UnSelectedImageIconLight
        }
    }
    
    // MARK: Tap Action
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        if isEnable {
            
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
//                    print("Dark mode")
                    if self.checkBoxImageView.image == self.selectedImageIconDark{
                        self.checkBoxImageView.image = self.UnSelectedImageIconDark
                        M2POnClick?(false, sender)
                    } else {
                        self.checkBoxImageView.image = self.selectedImageIconDark
                        M2POnClick?(true, sender)
                    }
                    
                }
                else {
//                    print("Light mode")
                    if self.checkBoxImageView.image == self.selectedImageIconLight{
                        self.checkBoxImageView.image = self.UnSelectedImageIconLight
                        M2POnClick?(false, sender)
                    } else {
                        self.checkBoxImageView.image = self.selectedImageIconLight
                        M2POnClick?(true, sender)
                    }
                }
            } else {
                if self.checkBoxImageView.image == self.selectedImageIconLight{
                    self.checkBoxImageView.image = self.UnSelectedImageIconLight
                    M2POnClick?(false, sender)
                } else {
                    self.checkBoxImageView.image = self.selectedImageIconLight
                    M2POnClick?(true, sender)
                }
            }
            
            
        }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.checkBoxImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.checkBoxImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.checkBoxImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.checkBoxImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            self.disableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.disableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.disableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.disableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: SetUp CheckBox
    public func M2PSetUpCheckBox(forSelectedImage: M2PCheckBoxProperties, forUnSelectedImage: M2PCheckBoxProperties, initialState: M2PCheckBoxSelectionState, checkBoxShapes: M2PCheckBoxShapes) {
        guard let selectedImageIconLight = forSelectedImage.lightModeImage, let selectedImageIconDark = forSelectedImage.darkModeImage else {
            return
        }
        
        guard let unSelectedImageIconLight = forUnSelectedImage.lightModeImage, let unSelectedImageIconDark = forUnSelectedImage.darkModeImage else {
            return
        }
        self.selectedImageIconLight = selectedImageIconLight
        self.UnSelectedImageIconLight = unSelectedImageIconLight
        self.selectedImageIconDark = selectedImageIconDark
        self.UnSelectedImageIconDark = unSelectedImageIconDark
        
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
//                print("Dark mode")
                self.checkBoxImageView.image = initialState == .selected ? self.selectedImageIconDark : self.UnSelectedImageIconDark
            }
            else {
//                print("Light mode")
                self.checkBoxImageView.image = initialState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
            }
        } else {
            self.checkBoxImageView.image = initialState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
        }
        
        checkBoxImageView.layer.masksToBounds = true
        self.disableView.layer.masksToBounds = true
        
        if checkBoxShapes == .box {
            self.layer.cornerRadius = 8
            self.checkBoxImageView.layer.cornerRadius = 8
            self.disableView.layer.cornerRadius = 8
        } else {
            self.layer.cornerRadius = self.frame.height/2
            self.disableView.layer.cornerRadius = self.disableView.frame.height/2
            self.checkBoxImageView.layer.cornerRadius = self.checkBoxImageView.frame.height/2
        }
    }
    
    // MARK: Update Check Box State
    public func M2PEnableDisableCheckBox(state: M2PCheckBoxState = .enable, withState: M2PCheckBoxState.M2PWithState = .selected) {
        self.isEnable = state == .enable ? true : false
        self.disableView.isHidden = state == .disable ? false : true
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
//                print("Dark mode")
                self.checkBoxImageView.image = withState == .selected ? self.selectedImageIconDark : self.UnSelectedImageIconDark
            }
            else {
//                print("Light mode")
                self.checkBoxImageView.image = withState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
            }
        } else {
            self.checkBoxImageView.image = withState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
        }
    }
}

