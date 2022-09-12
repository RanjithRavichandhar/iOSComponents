//
//  M2PCheckBox.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 07/09/22.
//

// MARK: Implementation

/* checkBox1.setUpCheckBox(forSelectedImage: CheckBoxProperties(image: UIImage(named: "checkbox_fill"), tintColor: UIColor.primaryActive), forUnSelectedImage: CheckBoxProperties(image: UIImage(named: "checkbox_unfill"), tintColor: UIColor.primaryActive), initialState: .selected, checkBoxShapes: .box)

checkBox2.setUpCheckBox(forSelectedImage: CheckBoxProperties(image: UIImage(named: "checkbox_fill"), tintColor: UIColor.primaryActive), forUnSelectedImage: CheckBoxProperties(image: UIImage(named: "checkbox_unfill"), tintColor: UIColor.primaryActive), initialState: .unSelected, checkBoxShapes: .round)


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
    public var image: UIImage? = nil
    public var tintColor: UIColor
    
    public init(image: UIImage? = nil, tintColor: UIColor) {
        self.image = image
        self.tintColor = tintColor
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
    var selectedImageIcon = UIImage()
    var UnSelectedImageIcon = UIImage()
    
    // MARK: Store Selected/ UnSelected TintColor
    var selectedTintColor = UIColor()
    var UnSelectedTintColor = UIColor()
    
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
    
    // MARK: Initial Loads
    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.checkBoxImageView)
        self.addSubview(self.disableView)
        self.disableView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        self.addGestureRecognizer(tap)
        setConstraints()
    }
    
    // MARK: Tap Action
    @objc public func tapAction(_ sender: UITapGestureRecognizer) {
        if isEnable {
            if self.checkBoxImageView.image == self.selectedImageIcon{
                self.checkBoxImageView.image = self.UnSelectedImageIcon
                onClick?(false, sender)
            } else {
                self.checkBoxImageView.image = self.selectedImageIcon
                onClick?(true, sender)
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
        guard let selectedImageIcon = forSelectedImage.image?.withRenderingMode(.alwaysTemplate), let UnSelectedImageIcon = forUnSelectedImage.image?.withRenderingMode(.alwaysTemplate) else {
            return
        }
        self.selectedImageIcon = selectedImageIcon
        self.UnSelectedImageIcon = UnSelectedImageIcon
        self.selectedTintColor = forSelectedImage.tintColor
        self.UnSelectedTintColor = forUnSelectedImage.tintColor
        
        self.checkBoxImageView.image = initialState == .selected ? self.selectedImageIcon : self.UnSelectedImageIcon
        
        self.checkBoxImageView.tintColor = initialState == .selected ? self.selectedTintColor : self.UnSelectedTintColor
        
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
        self.checkBoxImageView.image = withState == .unSelected ? self.UnSelectedImageIcon : self.selectedImageIcon
    }
}
