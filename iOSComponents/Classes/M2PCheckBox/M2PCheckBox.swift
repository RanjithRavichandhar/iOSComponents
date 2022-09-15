//
//  M2PCheckBox.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 07/09/22.
//

// MARK: Implementation

/* checkBox1.setUpCheckBox(forSelectedImage: CheckBoxProperties(lightModeImage: UIImage(named: "checkbox_fill"), darkModeImage: UIImage(named: "checkboxDark_fill")), forUnSelectedImage: CheckBoxProperties(lightModeImage: UIImage(named: "checkbox_unfill"), darkModeImage: UIImage(named: "checkbox_unfill")), initialState: .selected, checkBoxShapes: .box)
 
 checkBox2.setUpCheckBox(forSelectedImage: CheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_fill"), darkModeImage: UIImage(named: "checkbox_roundDark_fill")), forUnSelectedImage: CheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_unfill"), darkModeImage: UIImage(named: "checkbox_round_unfill")), initialState: .unSelected, checkBoxShapes: .round)
 
 
 checkBox1.onClick = { (isSelected, sender) in
 print(isSelected)
 }
 checkBox1.enableDisableCheckBox(state: .enable, withState: .unSelected)
 checkBox2.enableDisableCheckBox(state: .disable, withState: .selected) */

import Foundation
import UIKit

// MARK: For CheckBox Selection State
public enum CheckBoxSelectionState{
    case selected, unSelected
}

// MARK: For CheckBox Properties
public class CheckBoxProperties {
    public var lightModeImage: UIImage? = nil
    public var darkModeImage: UIImage? = nil
    
    public init(lightModeImage: UIImage? = nil, darkModeImage: UIImage? = nil) {
        self.lightModeImage = lightModeImage
        self.darkModeImage = darkModeImage
    }
}

// MARK: For CheckBox State
public enum CheckBoxState {
    case enable, disable
    public enum WithState {
        case selected, unSelected
    }
}

// MARK: For CheckBox Shapes
public enum CheckBoxShapes {
    case box, round
}

public class M2PCheckBox: UIView {
    
    // MARK: Store Selected/ UnSelected Image
    var selectedImageIconLight = UIImage()
    var UnSelectedImageIconLight = UIImage()
    var selectedImageIconDark = UIImage()
    var UnSelectedImageIconDark = UIImage()
    
    public var checkBoxShapes: CheckBoxShapes = .box {
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
    public var onClick:((Bool, UITapGestureRecognizer) -> Void)?
    
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
        self.checkBoxShapes = .round
        
    }
    
    func setDefaultCheckBoxShape(shape: CheckBoxShapes) {
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
                print("Dark mode")
                self.checkBoxImageView.image = self.UnSelectedImageIconDark
            }
            else {
                print("Light mode")
                self.checkBoxImageView.image = self.UnSelectedImageIconLight
            }
        } else {
            self.checkBoxImageView.image = self.UnSelectedImageIconLight
        }
    }
    
    // MARK: Tap Action
    @objc public func tapAction(_ sender: UITapGestureRecognizer) {
        if isEnable {
            
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    print("Dark mode")
                    if self.checkBoxImageView.image == self.selectedImageIconDark{
                        self.checkBoxImageView.image = self.UnSelectedImageIconDark
                        onClick?(false, sender)
                    } else {
                        self.checkBoxImageView.image = self.selectedImageIconDark
                        onClick?(true, sender)
                    }
                    
                }
                else {
                    print("Light mode")
                    if self.checkBoxImageView.image == self.selectedImageIconLight{
                        self.checkBoxImageView.image = self.UnSelectedImageIconLight
                        onClick?(false, sender)
                    } else {
                        self.checkBoxImageView.image = self.selectedImageIconLight
                        onClick?(true, sender)
                    }
                }
            } else {
                if self.checkBoxImageView.image == self.selectedImageIconLight{
                    self.checkBoxImageView.image = self.UnSelectedImageIconLight
                    onClick?(false, sender)
                } else {
                    self.checkBoxImageView.image = self.selectedImageIconLight
                    onClick?(true, sender)
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
    public func setUpCheckBox(forSelectedImage: CheckBoxProperties, forUnSelectedImage: CheckBoxProperties, initialState: CheckBoxSelectionState, checkBoxShapes: CheckBoxShapes) {
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
                print("Dark mode")
                self.checkBoxImageView.image = initialState == .selected ? self.selectedImageIconDark : self.UnSelectedImageIconDark
            }
            else {
                print("Light mode")
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
    public func enableDisableCheckBox(state: CheckBoxState = .enable, withState: CheckBoxState.WithState = .selected) {
        self.isEnable = state == .enable ? true : false
        self.disableView.isHidden = state == .disable ? false : true
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                print("Dark mode")
                self.checkBoxImageView.image = withState == .selected ? self.selectedImageIconDark : self.UnSelectedImageIconDark
            }
            else {
                print("Light mode")
                self.checkBoxImageView.image = withState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
            }
        } else {
            self.checkBoxImageView.image = withState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
        }
    }
}
