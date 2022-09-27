//
//  File.swift
//  iOSComponents
//
//  Created by Shiny on 14/09/22.
//

import Foundation

//public enum FieldState : String {
//    case active = "Active"
//    case inactive = "Inactive"
//}


public class M2PInputField: UIView {
    
    // MARK: Constants
    
    let minimumHeight = 85
    
    let imageHeight = 24
    let imageWidth = 24
        
    let dateFormatForDatePicker = "dd/MM/yyyy"
    
    // MARK: Main Content View
    
    var textFieldColor_Active: UIColor {
        if #available(iOS 13, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return UIColor.secondaryWhiteColor
            } else {
                /// Return the color for Light Mode
                return UIColor.primaryColor
            }
        } else {
            /// Return a fallback color for iOS 12 and lower.
            return UIColor.secondaryWhiteColor
        }
    }
    
    var textFieldColor_Inactive: UIColor = {
        if #available(iOS 13, *) {
            if UITraitCollection().userInterfaceStyle == .dark {
                return UIColor.lightGray
            } else {
                return UIColor.lightGray
            }
        } else {
            return UIColor.lightGray
        }
    }()
    
    let contentView: UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let leftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let fieldTypeView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        view.translatesAutoresizingMaskIntoConstraints =  false
        return view
    }()
    
    let fieldTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rightView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Bottom View
    
    let bottomInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let bottomInfoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomBorder = CALayer()
    
    let floatingLabel: UILabel = UILabel(frame: CGRect.zero) // Label
    let floatingLabelHeight: CGFloat = 20 // Default height
    
    var fieldConfig = M2PInputFieldConfig()
    
    var isTextFieldActive = false
    var fieldType: M2PInputFieldType = .Default_TextField
    var fieldStyle: M2PInputFieldStyle = .Form_Floating
    var isFieldTypeIconOn = false
    
    var datePicker = UIDatePicker()
    
    public var M2PonClickLeftView: (() -> ())?
    public var M2PonClickRightView: (() -> ())?
    public var M2PonClickFieldTypeView: ((_ type: M2PInputFieldType, _ isActiveFlag: Bool) -> ())?
    public var M2PdidTextFieldValueUpdated: ((String) -> ())?
    
    // MARK: Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomBorder.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.size.height - 5, width: contentView.frame.size.width, height:1)
    }
    
    private func setUpView() {
        textField.delegate = self
        
        addSubview(contentView)
        setContentViewConstraints()
        contentView.addSubview(contentStackView)
        setContentStackViewConstraints()
        
        bottomInfoStackView.addArrangedSubview(bottomInfoLabel)
        addSubview(bottomInfoStackView)
        setBottomInfoViewConstraints()
        bottomInfoStackView.isHidden = true
        
        contentStackView.addArrangedSubview(textFieldStackView)
        
        textFieldStackView.addArrangedSubview(textField)
        setTextFieldConstraints()
        
        textField.addTarget(self, action: #selector(self.onTextFieldEditingBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(self.onTextFieldEditingEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(self.onTextFieldEditingChange) , for: .editingChanged)
        
        // Tap gestures
        fieldTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFieldTypeIcon)))
    }
    
    private func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        //datePicker.backgroundColor = .gray
        datePicker.setValue(1, forKeyPath: "alpha")
        
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar.init(identifier: .gregorian)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        } else {
            // Fallback on earlier versions
        }
        setupDoneToolbar()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    
    private func setupDoneToolbar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:  #selector(handleDoneButton(sender:)))
        toolBar.setItems([flexible, barButton], animated: false)
        textField.inputAccessoryView = toolBar
    }
    
    @objc func onTextFieldEditingBegin() {
        if fieldStyle == .Form_Floating || fieldStyle == .BottomLine_Floating {
            addFloatingLabel()
        }
        setActiveInactiveState(isActiveflag: true)
        M2PhideErrorMessage()
        
        if fieldType == .Default_TextField, let text = textField.text, !text.isEmpty {
            fieldTypeImageView.isHidden = false
        }
    }
    
    @objc func onTextFieldEditingChange() {
        if fieldType == .Default_TextField || fieldType == .Password {
            if let text = textField.text, !text.isEmpty {
                fieldTypeImageView.isHidden = false
            } else {
                fieldTypeImageView.isHidden = true
            }
        } else {
            fieldTypeImageView.isHidden = false
        }
    }
    
    
    @objc func onTextFieldEditingEnd() {
        if fieldStyle == .Form_Floating || fieldStyle == .BottomLine_Floating {
            removeFloatingLabel()
        }
        setActiveInactiveState(isActiveflag: false)
        if fieldType == .Default_TextField {
            fieldTypeImageView.isHidden = true
        }
    }
    
    @objc func onClickFieldTypeIcon() {
        isFieldTypeIconOn = !isFieldTypeIconOn
        if fieldType == .Dropdown || fieldType == .Calendar {
            if fieldType == .Calendar {
                if isFieldTypeIconOn, let topVC = getTopViewController() {
                    topVC.view.addSubview(datePicker)
                    setDatePickerConstraints(on: topVC.view)
                } else if !isFieldTypeIconOn {
                    datePicker.removeFromSuperview()
                }
            }
            setActiveInactiveState(isActiveflag: !isTextFieldActive)
        }
        setupFieldTypeImage()
        fieldTypeIconAction()
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = dateFormatForDatePicker
        // textField.text = dateFormatter.string(from: sender.date)
        setTextFieldValue(with: dateFormatter.string(from: sender.date) )
    }
    
    @objc private func handleDoneButton(sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatForDatePicker
        if let selectedDate = (textField.inputView as? UIDatePicker)?.date {
            // textField.text = formatter.string(from: selectedDate)
            setTextFieldValue(with: formatter.string(from: selectedDate))
        }
        textField.resignFirstResponder()
    }
           
    private func addFloatingLabel() {
        if textField.text == "" {
            let labelView = UIView()
            labelView.addSubview(floatingLabel)
            floatingLabel.textColor = fieldConfig.fieldColors.title
            floatingLabel.font = fieldConfig.fieldFonts.titleFont
            floatingLabel.text = fieldConfig.titleText ?? fieldConfig.placeholderText
            floatingLabel.sizeToFit()
            floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            floatingLabel.clipsToBounds = true
            
            textFieldStackView.insertArrangedSubview(labelView, at: 0)
            
            self.floatingLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 0).isActive = true
            self.floatingLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 5).isActive = true
            self.floatingLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor).isActive = true
            labelView.heightAnchor.constraint(equalToConstant: floatingLabelHeight).isActive = true
            
            // Remove the placeholder
            textField.placeholder = ""
        }
        
        textField.setNeedsDisplay()
    }
    
    private func removeFloatingLabel() {
        if textField.text == "" {
            UIView.animate(withDuration: 0.15) {
                self.textFieldStackView.arrangedSubviews.first?.removeFromSuperview()
            }
            textField.placeholder = fieldConfig.placeholderText
        }
    }
    
    private func setActiveInactiveState(isActiveflag: Bool) {
        self.isTextFieldActive = isActiveflag
        
        let currentStateColor = isActiveflag ? textFieldColor_Active : textFieldColor_Inactive
        contentView.layer.borderColor = currentStateColor.cgColor
        bottomBorder.backgroundColor = currentStateColor.cgColor
        fieldTypeImageView.tintColor = currentStateColor
    }
    
    private func setupIntialConfig(for fieldType: M2PInputFieldType) {
        switch fieldType {
        case .Default_TextField:
            fieldTypeImageView.image = getImage(with: "close.png")
            fieldTypeImageView.isHidden = true
        case .Password:
            fieldTypeImageView.isHidden = true
        case .Dropdown:
            textField.isUserInteractionEnabled = false
            textFieldStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFieldTypeIcon)))
        case .Calendar:
            textField.isUserInteractionEnabled = false
            setupDatePicker()
            textFieldStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFieldTypeIcon)))
        }
    }
    
    private func setupFieldTypeImage() {
        switch fieldType {
        case .Default_TextField:
            break
        case .Password:
            textField.isSecureTextEntry = !textField.isSecureTextEntry
            fieldTypeImageView.image = textField.isSecureTextEntry ? getImage(with: "eye.png") : getImage(with: "eye_off.png")
        case .Dropdown:
            fieldTypeImageView.image = isFieldTypeIconOn ? getImage(with: "dropdown_active.png") : getImage(with: "dropdown_inactive.png")
        case .Calendar:
            fieldTypeImageView.image = getImage(with: "calendar.png") // Calendar icon
        }
        
        fieldTypeImageView.tintColor = isTextFieldActive ? textFieldColor_Active : textFieldColor_Inactive
    }
    
    private func fieldTypeIconAction() {
        switch fieldType {
        case .Default_TextField:
            setTextFieldValue(with: "")
            fieldTypeImageView.isHidden = true
        case .Password:
            break
        case .Dropdown:
            M2PonClickFieldTypeView?(fieldType, isFieldTypeIconOn)
        case .Calendar:
            M2PonClickFieldTypeView?(fieldType, isFieldTypeIconOn)
        }
    }
    
    // MARK: Public methods
    
    public func M2Psetup(type: M2PInputFieldType, config: M2PInputFieldConfig, leftImage: UIImage? = nil, rightImage: UIImage? = nil) {
        
        self.fieldType = type
        //if let configuration =  config {
        self.fieldConfig = config
        //}
        self.fieldStyle = fieldConfig.fieldStyle
        
        //Input Field data - related
        textField.placeholder = fieldConfig.placeholderText
        textField.font = fieldConfig.fieldFonts.placeHolderFont
        
        //Error
        bottomInfoLabel.font = fieldConfig.fieldFonts.errorFont
        
        setupFeildView(for: fieldStyle)
        
        // Left View
        if let image = leftImage {
            leftImageView.image = image
            leftView.addSubview(leftImageView)
            leftView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            setLeftImageConstraints()
            contentStackView.insertArrangedSubview(leftView, at: 0)
        }
        
        // Field Type configurations
        // Initial setup
        setupIntialConfig(for: type)
        // Field type imageView
        setupFieldTypeImage()
        // Field Type View Addition
        fieldTypeView.addSubview(fieldTypeImageView)
        fieldTypeView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        setFieldTypeImageConstraints()
        contentStackView.addArrangedSubview(fieldTypeView)
        
        // Right View
        if let image = rightImage {
            rightImageView.image = image
            rightView.addSubview(rightImageView)
            rightView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            setRightImageConstraints()
            contentStackView.addArrangedSubview(rightView)
        }
        
        updateConstraintsBasedOnType()
        
    }
    
    public func M2PsetTextFieldValue(with value: String) {
        if fieldStyle == .Form_Floating || fieldStyle == .BottomLine_Floating {
            addFloatingLabel()
        }
//        self.textField.text = value
        setTextFieldValue(with: value)
    }
    
    public func M2PshowErrorWith(message: String, icon: UIImage? = nil, stateColor: UIColor? = nil) {
        if let errorIcon = icon {
            bottomInfoImageView.image = errorIcon
            bottomInfoStackView.insertArrangedSubview(bottomInfoImageView, at: 0)
            bottomInfoImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        } else if bottomInfoStackView.subviews.count > 1 {
            bottomInfoStackView.removeArrangedSubview(bottomInfoImageView)
        }
        
        bottomInfoLabel.text = message
        
        let currentStateColor = stateColor ?? fieldConfig.fieldColors.failureState
        bottomInfoLabel.textColor = currentStateColor
        if fieldStyle == .Form_Floating || fieldStyle == .Form_Default {
            contentView.layer.borderColor = currentStateColor.cgColor
        } else {
            bottomBorder.backgroundColor = currentStateColor.cgColor
        }
        
        bottomInfoStackView.isHidden = false
    }
    
    public func M2PhideErrorMessage() {
        bottomInfoStackView.isHidden = true
        setActiveInactiveState(isActiveflag: isTextFieldActive)
    }
    
    private func setupFeildView(for style: M2PInputFieldStyle) {
        let currentStateColor = isTextFieldActive ? textFieldColor_Active : textFieldColor_Inactive
        switch style {
        case .Form_Default, .Form_Floating:
            contentView.layer.cornerRadius = 10
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = currentStateColor.cgColor
        case .BottomLine_Default, .BottomLine_Floating:
            bottomBorder.frame = CGRect(x: contentView.frame.minX, y: contentView.bounds.size.height - 5, width: contentView.frame.size.width, height:1)
            bottomBorder.backgroundColor = currentStateColor.cgColor
            contentView.layer.addSublayer(bottomBorder)
        }
        
    }
    
    private func setTextFieldValue(with text: String) {
        textField.text = text
        M2PdidTextFieldValueUpdated?(text)
    }
                   
    // MARK: Constraints
    
    func setContentViewConstraints() {

        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        // contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: self.frame.height * 0.75).isActive = true
    }
    
    func setBottomInfoViewConstraints() {
        bottomInfoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        bottomInfoStackView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2).isActive = true
        bottomInfoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomInfoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setContentStackViewConstraints() {
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func updateConstraintsBasedOnType() {
        if fieldStyle == .BottomLine_Default || fieldStyle == .BottomLine_Floating {
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        }
    }
    
    func setTextFieldConstraints() {
        textField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor).isActive = true
        //textField.widthAnchor.constraint(greaterThanOrEqualToConstant: contentStackView.frame.width - 80).isActive = true
//        textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        //textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setLeftImageConstraints() {
        leftImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        leftImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        leftImageView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        leftImageView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
    }
    
    func setFieldTypeImageConstraints() {
        fieldTypeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        fieldTypeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
       fieldTypeImageView.centerXAnchor.constraint(equalTo: fieldTypeView.centerXAnchor).isActive = true
        fieldTypeImageView.centerYAnchor.constraint(equalTo: fieldTypeView.centerYAnchor).isActive = true
    }
    
    func setRightImageConstraints() {
        rightImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        rightImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        rightImageView.centerXAnchor.constraint(equalTo: rightView.centerXAnchor).isActive = true
        rightImageView.centerYAnchor.constraint(equalTo: rightView.centerYAnchor).isActive = true
    }
    
    private func setDatePickerConstraints(on superView: UIView) {
        // datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.width /).isActive = true
        datePicker.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        // datePicker.widthAnchor.constraint(equalToConstant: 150).isActive = true
        // datePicker.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
                   
}

extension M2PInputField: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}

// MARK: <UITraitEnvironment> delegate methods

extension M2PInputField {
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               // ColorUtils.loadCGColorFromAsset returns cgcolor for color name
               setActiveInactiveState(isActiveflag: self.isTextFieldActive)
           }
       }
    }
    
}

extension M2PInputField {
    
    private func getImage(with imageName: String) -> UIImage? {
        let bundle = M2PComponentsBundle.shared.currentBundle
        let image = UIImage(named: imageName, in: bundle , compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        return image
    }
    
    private func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
