//
//  File.swift
//  iOSComponents
//
//  Created by Shiny on 14/09/22.
//

import Foundation
import UIKit

public class M2PInputField: UIView {
    
    // MARK: Constants
    
    let minimumHeight = 85
    
    // MARK: Constants - Main Content View
    
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
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
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
    
    // MARK: Constants - Bottom View
    
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
        imageView.contentMode = .scaleAspectFit
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
    
    // MARK: Variables
    
    var rightImageSize =  CGSize(width: 24, height: 24)
    var leftImageSize =  CGSize(width: 24, height: 24)
    
    var fieldConfig = M2PInputFieldConfig()
    
    var isTextFieldActive = false
    var fieldType: M2PInputFieldType = .Default_TextField
    var fieldStyle: M2PInputFieldStyle = .Form_Floating
    var isFieldTypeIconOn = false
    var isFloatingLabelPresent = false

    // TODO: Need To Check
    /*
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
    */

    var textFieldColor_Active: UIColor?
    var textFieldColor_Inactive: UIColor?
    
    
    var datePicker = UIDatePicker()
    
    // MARK: Public variables
    
    public var M2PkeyBoardType: UIKeyboardType {
        get {
            return textField.keyboardType
        }
        set {
            textField.keyboardType = newValue
        }
    }
    
    public var M2PtextFieldAlignment: NSTextAlignment {
        get {
            return textField.textAlignment
        }
        set {
            textField.textAlignment = newValue
        }
    }
    
    public var M2PtextFieldAutoCorrection: UITextAutocorrectionType {
        get {
            return textField.autocorrectionType
        }
        set {
            textField.autocorrectionType = newValue
        }
    }
    
    public var M2PdateFormatForDatePicker = "dd/MM/yyyy"
    
    public var M2PonClickLeftView: (() -> ())?
    public var M2PonClickRightView: (() -> ())?
    public var M2PonClickFieldTypeView: ((_ type: M2PInputFieldType, _ isActiveFlag: Bool) -> ())?
    public var M2PdidTextFieldEditingChange: ((String?) -> ())?
    public var M2PdidTextFieldValueUpdated: ((String) -> ())?
    
    // MARK: Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpView()
        self.textField.keyboardType = .alphabet
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomBorder.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.size.height - 5, width: contentView.frame.size.width, height:1)
    }
    
    // MARK: Setups
    
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
        // textField.addTarget(nil, action: #selector(self.onTextFieldValueChange), for: .valueChanged)
        
        // Tap gestures
        fieldTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFieldTypeIcon)))
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
        case .CalendarDefault, .CalendarCustom:
            textField.isUserInteractionEnabled = false
            textFieldStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickFieldTypeIcon)))
        }
    }
    
    private func setupFeildView(for style: M2PInputFieldStyle) {
        let currentStateColor = isTextFieldActive ? textFieldColor_Active : textFieldColor_Inactive
        switch style {
        case .Form_Default, .Form_Floating:
            contentView.layer.cornerRadius = 10
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = currentStateColor?.cgColor
        case .BottomLine_Default, .BottomLine_Floating:
            bottomBorder.frame = CGRect(x: contentView.frame.minX, y: contentView.bounds.size.height - 5, width: contentView.frame.size.width, height:1)
            bottomBorder.backgroundColor = currentStateColor?.cgColor
            contentView.layer.addSublayer(bottomBorder)
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
        case .CalendarDefault, .CalendarCustom:
            fieldTypeImageView.image = getImage(with: "calendar.png") // Calendar icon
        }
        
        fieldTypeImageView.tintColor = isTextFieldActive ? textFieldColor_Active : textFieldColor_Inactive
    }
    
    // MARK: Date picker - related
    /*  private func setupDatePicker() {
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        //datePicker.backgroundColor = .gray
//        datePicker.setValue(1, forKeyPath: "alpha")
//
//        datePicker.datePickerMode = .date
//        datePicker.calendar = Calendar.init(identifier: .gregorian)
//        if #available(iOS 13.4, *) {
//            datePicker.preferredDatePickerStyle = .compact
//        } else {
//            // Fallback on earlier versions
//        }
//        setupDoneToolbar()
//        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
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
     
     @objc private func datePickerValueChanged(sender: UIDatePicker) {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat  = M2PdateFormatForDatePicker
         // textField.text = dateFormatter.string(from: sender.date)
         setTextFieldValue(with: dateFormatter.string(from: sender.date) )
     }
     
     @objc private func handleDoneButton(sender: UIButton) {
         let formatter = DateFormatter()
         formatter.dateFormat = M2PdateFormatForDatePicker
         if let selectedDate = (textField.inputView as? UIDatePicker)?.date {
             // textField.text = formatter.string(from: selectedDate)
             setTextFieldValue(with: formatter.string(from: selectedDate))
         }
         textField.resignFirstResponder()
     } */
    
    // MARK: Target actions
    
    @objc func onTextFieldEditingBegin() {
        // Adding floating title label
        if fieldStyle == .Form_Floating || fieldStyle == .BottomLine_Floating {
            addFloatingLabel()
        }
        
        // TextField active state changes
        setActiveInactiveState(isActiveflag: true)
        M2PhideErrorMessage()
        
        //To show the close button
        if fieldType == .Default_TextField, let text = textField.text, !text.isEmpty {
            fieldTypeImageView.isHidden = false
        }
    }
    
    @objc func onTextFieldEditingChange() {
        // Text field font & color
        setTextFieldCurrentStateStyles()
        
        // TextField type image (hide/unhide) handling
        updateFieldTypeImageHiddenState()
        
        // Call back on editing change
        M2PdidTextFieldEditingChange?(textField.text)
    }
    
//    @objc func onTextFieldValueChange() {
//        print("Changed! ")
//    }
    
    @objc func onTextFieldEditingEnd() {
        // Removing floating title label
        if fieldStyle == .Form_Floating || fieldStyle == .BottomLine_Floating {
            removeFloatingLabel()
        }
        
        // TextField inactive state changes
        setActiveInactiveState(isActiveflag: false)

        // To hide close button
        if fieldType == .Default_TextField {
            fieldTypeImageView.isHidden = true
        }
    }
    
    @objc func onClickFieldTypeIcon() {
        isFieldTypeIconOn = !isFieldTypeIconOn
        setupFieldTypeImage()
        fieldTypeIconAction()
    }
    
    @objc func onClickLeftView() {
        M2PonClickLeftView?()
    }
    
    @objc func onClickRightView() {
        M2PonClickRightView?()
    }
    
    // MARK: Floating label handling
           
    private func addFloatingLabel() {
        if textField.text == "", !isFloatingLabelPresent {
            isFloatingLabelPresent = true
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
        if textField.text == "", isFloatingLabelPresent {
            isFloatingLabelPresent = false
            UIView.animate(withDuration: 0.15) {
                self.textFieldStackView.arrangedSubviews.first?.removeFromSuperview()
            }
            textField.placeholder = fieldConfig.placeholderText
        }
    }
    
    // MARK: Actions
    
    // On click field type icon
    private func fieldTypeIconAction() {
        switch fieldType {
        case .Default_TextField:
            setTextFieldValue(with: "")
            fieldTypeImageView.isHidden = true
        case .Password:
            break
        case .Dropdown:
            setActiveInactiveState(isActiveflag: !isTextFieldActive)
            M2PonClickFieldTypeView?(fieldType, isFieldTypeIconOn)
        case .CalendarDefault:
            setActiveInactiveState(isActiveflag: true)
            M2PDatePicker.shared.m2pAddDatePicker(backGroundColor: .backgroundLightVarient, textColor: .primaryActive)
            M2PDatePicker.shared.getSelectedDate = { selectedDate in
                if let date = selectedDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat  = self.M2PdateFormatForDatePicker
                    self.setTextFieldValue(with: dateFormatter.string(from: date))
                    self.setActiveInactiveState(isActiveflag: false)
                }
            }
            M2PonClickFieldTypeView?(fieldType, isFieldTypeIconOn)
        case .CalendarCustom:
            M2PonClickFieldTypeView?(fieldType, isFieldTypeIconOn)
        }
    }
    
    // FieldType Image Hidden State updation
    private func updateFieldTypeImageHiddenState() {
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
    
    // MARK: Helper methods
    
    private func setActiveInactiveState(isActiveflag: Bool) {
        self.isTextFieldActive = isActiveflag
        
        let currentStateColor = isActiveflag ? textFieldColor_Active : textFieldColor_Inactive
        contentView.layer.borderColor = currentStateColor?.cgColor
        bottomBorder.backgroundColor = currentStateColor?.cgColor
        fieldTypeImageView.tintColor = currentStateColor
    }
    
    // Field value
    private func setTextFieldValue(with text: String) {
        textField.text = text
        setTextFieldCurrentStateStyles()
        M2PdidTextFieldValueUpdated?(text)
    }
    
    // Styles
    private func setTextFieldCurrentStateStyles() {
        if let text = textField.text, !text.isEmpty {
            textField.font = fieldConfig.fieldFonts.valueTextFont
            textField.textColor = fieldConfig.fieldColors.valueText
        } else {
            textField.font = fieldConfig.fieldFonts.placeHolderFont
            textField.textColor = fieldConfig.fieldColors.placeholder
        }
    }
                   
}

// MARK: Public methods

extension M2PInputField {
    
    public func M2Psetup(type: M2PInputFieldType, config: M2PInputFieldConfig, leftImage: UIImage? = nil, rightImage: UIImage? = nil) {
        
        self.fieldType = type
        self.fieldConfig = config
        self.fieldStyle = fieldConfig.fieldStyle
        
        self.textFieldColor_Active = config.fieldColors.activeBorder
        self.textFieldColor_Inactive = config.fieldColors.defaultBorder
        
        //Input Field data - related
        textField.isUserInteractionEnabled = true
        textField.placeholder = fieldConfig.placeholderText
        setTextFieldCurrentStateStyles()
        
        //Error
        bottomInfoLabel.font = fieldConfig.fieldFonts.errorFont
        
        setupFeildView(for: fieldStyle)
        
        // Left View
        if let image = leftImage {
            M2PsetLeftImage(image: image)
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
            M2PsetRightImage(image: image)
        }
        
        updateConstraintsBasedOnType()
        
    }
    
    public func M2PsetTextFieldDelegate(with fieldDelegate: UITextFieldDelegate) {
        self.textField.delegate = fieldDelegate
    }
    
    public func M2PsetTextFieldValue(with value: String) {
        if fieldStyle == .Form_Floating || fieldStyle == .BottomLine_Floating {
            addFloatingLabel()
        }
        if fieldType != .Default_TextField {
            updateFieldTypeImageHiddenState()
        }
        setTextFieldValue(with: value)
        if fieldType == .Dropdown || fieldType == .CalendarDefault || fieldType == .CalendarCustom {
            isFieldTypeIconOn = false
            setActiveInactiveState(isActiveflag: false)
            setupFieldTypeImage()
        }
    }
    
    public func M2PgetTextFieldValue() -> String? {
        let text = textField.text
        return text
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
    
    public func M2PsetLeftImage(image: UIImage?, size: CGSize? = nil) {
        if let leftImage = image {
            leftImageSize = size ?? leftImageSize
            leftImageView.image = leftImage
            leftView.addSubview(leftImageView)
            leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickLeftView)))
            leftView.widthAnchor.constraint(equalToConstant: leftImageSize.width).isActive = true
            setLeftImageConstraints()
            contentStackView.insertArrangedSubview(leftView, at: 0)
        } else {
            // contentStackView.removeArrangedSubview(leftView)
            if let leftView = contentStackView.arrangedSubviews.first(where: {$0 == leftView}) {
                leftView.removeFromSuperview()
            }
        }
    }

    public func M2PsetRightImage(image: UIImage?, size: CGSize? = nil) {
        if let rightImage = image {
            rightImageSize = size ?? rightImageSize
            rightImageView.image = rightImage
            rightView.addSubview(rightImageView)
            rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickRightView)))
            rightView.widthAnchor.constraint(equalToConstant: rightImageSize.width).isActive = true
            setRightImageConstraints()
            contentStackView.addArrangedSubview(rightView)
        } else {
            // contentStackView.removeArrangedSubview(rightView)
            if let rightView = contentStackView.arrangedSubviews.first(where: {$0 == rightView}) {
                rightView.removeFromSuperview()
            }
        }
    }
    
    public func M2PSetInputFieldState(isActive: Bool) {
        setActiveInactiveState(isActiveflag: isActive)
    }
    
}

// MARK: Constraints
extension M2PInputField {
    
    func setContentViewConstraints() {

        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        // contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75).isActive = true
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
        leftImageView.heightAnchor.constraint(equalToConstant: leftImageSize.height).isActive = true
        leftImageView.widthAnchor.constraint(equalToConstant: leftImageSize.width).isActive = true
        leftImageView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        leftImageView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
    }
    
    func setFieldTypeImageConstraints() {
        let value : CGFloat = fieldType == .Default_TextField ? 20 : 24
        fieldTypeImageView.heightAnchor.constraint(equalToConstant: value).isActive = true
        fieldTypeImageView.widthAnchor.constraint(equalToConstant: value).isActive = true
       fieldTypeImageView.centerXAnchor.constraint(equalTo: fieldTypeView.centerXAnchor).isActive = true
        fieldTypeImageView.centerYAnchor.constraint(equalTo: fieldTypeView.centerYAnchor).isActive = true
    }
    
    func setRightImageConstraints() {
        rightImageView.heightAnchor.constraint(equalToConstant: rightImageSize.height).isActive = true
        rightImageView.widthAnchor.constraint(equalToConstant: rightImageSize.width).isActive = true
        rightImageView.centerXAnchor.constraint(equalTo: rightView.centerXAnchor).isActive = true
        rightImageView.centerYAnchor.constraint(equalTo: rightView.centerYAnchor).isActive = true
    }
    
    private func setDatePickerConstraints(on superView: UIView) {
        datePicker.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
}

// MARK: <UITextFieldDelegate> methods
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

// MARK: Helper methods

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
