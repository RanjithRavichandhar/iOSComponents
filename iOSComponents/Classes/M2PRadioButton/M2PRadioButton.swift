//
//  M2PRadioButton.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 08/09/22.
//

// MARK: Implementation

/*
radio5.setUpRadioButton(forSelectedImage: RadioButtonProperties(image: UIImage(named: "radio_select"), tintColor: UIColor.primaryActive), forUnSelectedImage: RadioButtonProperties(image: UIImage(named: "radio_unselect"), tintColor: UIColor.primaryActive), initialState: .unSelected)

radio1.onClick = { (sender) in
    self.radio1.setSelected()
    self.radio2.setUnSelected()
    self.radio3.setUnSelected()
    self.radio4.setUnSelected()
    self.radio5.setUnSelected()
 
 radio5.enableDisableRadioButton(state: .disable, withState: .selected)
}
*/
 
import Foundation

// MARK: For Radio Button Selection State
public enum RadioButtonSelectionState{
    case selected, unSelected
}

// MARK: For Radio Button Properties
public class RadioButtonProperties {
    public var image: UIImage? = nil
    public var tintColor: UIColor
    
    public init(image: UIImage? = nil, tintColor: UIColor) {
        self.image = image
        self.tintColor = tintColor
    }
}

// MARK: For Radio Button State
public enum RadioButtonState {
    case enable, disable
    public enum WithState {
        case selected, unSelected
    }
}

public class M2PRadioButton: UIView {
    
    // MARK: Store Selected/ UnSelected Image
    var selectedImageIcon = UIImage()
    var UnSelectedImageIcon = UIImage()
    
    // MARK: Store Selected/ UnSelected TintColor
    var selectedTintColor = UIColor()
    var UnSelectedTintColor = UIColor()
    
    // MARK: For Handling Enable/Disable
    var isEnable = true
    
    // MARK: For Click Action
    public var onClick:((UITapGestureRecognizer) -> Void)?
    
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
    
    // MARK: Initial Loads
    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.radioButtonImageView)
        self.addSubview(self.disableView)
        self.disableView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        self.addGestureRecognizer(tap)
        setConstraints()
    }
    
    // MARK: Tap Action
    @objc public func tapAction(_ sender: UITapGestureRecognizer) {
        if isEnable {
            self.radioButtonImageView.image = self.selectedImageIcon
            onClick?(sender)
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
    public func setSelected() {
        if isEnable {
            self.radioButtonImageView.image = self.selectedImageIcon
        }
    }
    
    // MARK: Set UnSelected
    public func setUnSelected() {
        if isEnable {
            self.radioButtonImageView.image = self.UnSelectedImageIcon
        }
    }
    
    // MARK: SetUp Radio Button
    public func setUpRadioButton(forSelectedImage: RadioButtonProperties, forUnSelectedImage: RadioButtonProperties, initialState: RadioButtonSelectionState) {
        guard let selectedImageIcon = forSelectedImage.image?.withRenderingMode(.alwaysTemplate), let UnSelectedImageIcon = forUnSelectedImage.image?.withRenderingMode(.alwaysTemplate) else {
            return
        }
        self.selectedImageIcon = selectedImageIcon
        self.UnSelectedImageIcon = UnSelectedImageIcon
        self.selectedTintColor = forSelectedImage.tintColor
        self.UnSelectedTintColor = forUnSelectedImage.tintColor
        
        self.radioButtonImageView.image = initialState == .selected ? self.selectedImageIcon : self.UnSelectedImageIcon
        
        self.radioButtonImageView.tintColor = initialState == .selected ? self.selectedTintColor : self.UnSelectedTintColor
    }
    
    // MARK: Update Radio Button State
    public func enableDisableRadioButton(state: RadioButtonState = .enable, withState: RadioButtonState.WithState = .selected) {
        self.isEnable = state == .enable ? true : false
        self.disableView.isHidden = state == .disable ? false : true
        self.radioButtonImageView.image = withState == .unSelected ? self.UnSelectedImageIcon : self.selectedImageIcon
    }
}
