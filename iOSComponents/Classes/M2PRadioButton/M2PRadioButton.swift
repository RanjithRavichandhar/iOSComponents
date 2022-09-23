//
//  M2PRadioButton.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 08/09/22.
//

// MARK: Implementation

/*
 radio1.M2PSetUpRadioButton(forSelectedImage: M2PRadioButtonProperties(lightModeImage: UIImage(named: "radioSelectLight"), darkModeImage: UIImage(named: "radioSelectDark")), forUnSelectedImage: M2PRadioButtonProperties(lightModeImage: UIImage(named: "radioUnSelect"), darkModeImage: UIImage(named: "radioUnSelect")), initialState: .unSelected)

radio1.M2POnClick = { (sender) in
    self.radio1.M2PSetSelected()
    self.radio2.M2PSetUnSelected()
    self.radio3.M2PSetUnSelected()
    self.radio4.M2PSetUnSelected()
    self.radio5.M2PSetUnSelected()
 
 radio5.M2PEnableDisableRadioButton(state: .disable, withState: .selected)
}
*/
 
import Foundation

// MARK: For Radio Button Selection State
public enum M2PRadioButtonSelectionState{
    case selected, unSelected
}

// MARK: For Radio Button Properties
public class M2PRadioButtonProperties {
     var lightModeImage: UIImage? = nil
     var darkModeImage: UIImage? = nil
    
    public init(lightModeImage: UIImage? = nil, darkModeImage: UIImage? = nil) {
        self.lightModeImage = lightModeImage
        self.darkModeImage = darkModeImage
    }
}

// MARK: For Radio Button State
public enum M2PRadioButtonState {
    case enable, disable
    public enum M2PWithState {
        case selected, unSelected
    }
}

public class M2PRadioButton: UIView {
    
    // MARK: Store Selected/ UnSelected Image
    var selectedImageIconLight = UIImage()
    var UnSelectedImageIconLight = UIImage()
    var selectedImageIconDark = UIImage()
    var UnSelectedImageIconDark = UIImage()

//    // MARK: Store Selected/ UnSelected TintColor
//    var selectedTintColor = UIColor()
//    var UnSelectedTintColor = UIColor()
    
    // MARK: For Handling Enable/Disable
    var isEnable = true
    
    // MARK: For Click Action
    public var M2POnClick:((UITapGestureRecognizer) -> Void)?
    
    // MARK: Set Radio Button Image
    private lazy var radioButtonImageView: UIImageView = {
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
        self.radioButtonImageView.layer.masksToBounds = true
        self.disableView.layer.masksToBounds = true
        
        self.layer.cornerRadius = self.frame.height/2
        self.disableView.layer.cornerRadius = self.disableView.frame.height/2
        self.radioButtonImageView.layer.cornerRadius = self.radioButtonImageView.frame.height/2
    }
    
    
    // MARK: update color while changing Light and Dark Mode
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                if self.radioButtonImageView.image == self.selectedImageIconLight {
                    self.radioButtonImageView.image = self.selectedImageIconDark
                } else if self.radioButtonImageView.image == self.UnSelectedImageIconLight {
                    self.radioButtonImageView.image = self.UnSelectedImageIconDark
                }
            } else if self.traitCollection.userInterfaceStyle == .light {
                if self.radioButtonImageView.image == self.selectedImageIconDark{
                    self.radioButtonImageView.image = self.selectedImageIconLight
                } else if self.radioButtonImageView.image == self.UnSelectedImageIconDark {
                    self.radioButtonImageView.image = self.UnSelectedImageIconLight
                }
            }
        } else {
            if self.radioButtonImageView.image == self.selectedImageIconDark{
                self.radioButtonImageView.image = self.selectedImageIconLight
            } else if self.radioButtonImageView.image == self.UnSelectedImageIconDark {
                self.radioButtonImageView.image = self.UnSelectedImageIconLight
            }
        }
    }
    
    // MARK: Initial Loads
    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.radioButtonImageView)
        self.addSubview(self.disableView)
        self.disableView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        self.addGestureRecognizer(tap)
        self.setConstraints()
        self.setDefaultRadioButton()
    }
    
    func setDefaultRadioButton() {
        let resourcesBundle = M2PComponentsBundle.shared.currentBundle
        let radioSelectDark = UIImage(named: "radioSelectDark.png", in: resourcesBundle, compatibleWith: nil)
        let radioSelectLight = UIImage(named: "radioSelectLight.png", in: resourcesBundle, compatibleWith: nil)
        let radioUnSelect = UIImage(named: "radioUnSelect.png", in: resourcesBundle, compatibleWith: nil)
        
        
        guard let radioSelectDark = radioSelectDark, let radioSelectLight = radioSelectLight, let radioUnSelect = radioUnSelect else {
            return
        }
        
        self.selectedImageIconLight = radioSelectLight
        self.UnSelectedImageIconLight = radioUnSelect
        self.selectedImageIconDark = radioSelectDark
        self.UnSelectedImageIconDark = radioUnSelect
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
//                print("Dark mode")
                self.radioButtonImageView.image = self.UnSelectedImageIconDark
            }
            else {
//                print("Light mode")
                self.radioButtonImageView.image = self.UnSelectedImageIconLight
            }
        } else {
            self.radioButtonImageView.image = self.UnSelectedImageIconLight
        }
    }
    
    // MARK: Tap Action
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        if isEnable {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
//                    print("Dark mode")
                    self.radioButtonImageView.image = self.selectedImageIconDark
                }
                else {
//                    print("Light mode")
                    self.radioButtonImageView.image = self.selectedImageIconLight
                }
            } else {
                self.radioButtonImageView.image = self.selectedImageIconLight
            }
            M2POnClick?(sender)
        }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.radioButtonImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.radioButtonImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.radioButtonImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.radioButtonImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            self.disableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.disableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.disableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.disableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: Set Selected
    public func M2PSetSelected() {
        if isEnable {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
//                    print("Dark mode")
                    self.radioButtonImageView.image = self.selectedImageIconDark
                }
                else {
//                    print("Light mode")
                    self.radioButtonImageView.image = self.selectedImageIconLight
                }
            } else {
                self.radioButtonImageView.image = self.selectedImageIconLight
            }
        }
    }
    
    // MARK: Set UnSelected
    public func M2PSetUnSelected() {
        if isEnable {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
//                    print("Dark mode")
                    self.radioButtonImageView.image = self.UnSelectedImageIconDark
                }
                else {
//                    print("Light mode")
                    self.radioButtonImageView.image = self.UnSelectedImageIconLight
                }
            } else {
                self.radioButtonImageView.image = self.UnSelectedImageIconLight
            }
        }
    }
    
    // MARK: SetUp Radio Button
    public func M2PSetUpRadioButton(forSelectedImage: M2PRadioButtonProperties, forUnSelectedImage: M2PRadioButtonProperties, initialState: M2PRadioButtonSelectionState) {
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
                self.radioButtonImageView.image = initialState == .selected ? self.selectedImageIconDark : self.UnSelectedImageIconDark
            }
            else {
//                print("Light mode")
                self.radioButtonImageView.image = initialState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
            }
        } else {
            self.radioButtonImageView.image = initialState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
        }
    }
    
    // MARK: Update Radio Button State
    public func M2PEnableDisableRadioButton(state: M2PRadioButtonState = .enable, withState: M2PRadioButtonState.M2PWithState = .selected) {
        self.isEnable = state == .enable ? true : false
        self.disableView.isHidden = state == .disable ? false : true
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
//                print("Dark mode")
                self.radioButtonImageView.image = withState == .selected ? self.selectedImageIconDark : self.UnSelectedImageIconDark
            }
            else {
//                print("Light mode")
                self.radioButtonImageView.image = withState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
            }
        } else {
            self.radioButtonImageView.image = withState == .selected ? self.selectedImageIconLight : self.UnSelectedImageIconLight
        }
    }
}
