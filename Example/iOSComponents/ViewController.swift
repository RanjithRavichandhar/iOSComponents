//
//  ViewController.swift
//  iOSComponents
//
//  Created by RanjithRavichandhar on 08/29/2022.
//  Copyright (c) 2022 RanjithRavichandhar. All rights reserved.
//

import UIKit
import iOSComponents

class ViewController: UIViewController {
    
    @IBOutlet weak var gradientBgView: M2PGradientView!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet weak var chipView: M2PChip?
    @IBOutlet weak var topTabBar: M2PTopTabBar!
    @IBOutlet weak var slider: M2PSlider?
    @IBOutlet weak var otpView: OTPFieldView?
    @IBOutlet weak var otpView_Two: OTPFieldView?
    @IBOutlet weak var pageControl: M2PCustomPageControl!
    @IBOutlet private weak var datepickerTF: UITextField!
    
    @IBOutlet weak var popAlertButton: M2PButton!
    
    private var indicatorValue: Float = 0.0
    var progressBarTimer: Timer!
    
    @IBOutlet weak var toolTipBtn: UIButton!
    
    @IBOutlet weak var listView: M2PList?
    
    @IBOutlet weak var m2pButton: M2PButton!
    
    //Page control
    var customPageControl = M2PCustomPageControl()
    //Input field
    var inputFieldView: M2PInputField?
    
    // Menu bar
    var index = 4
    var tabItems : [M2PTopTabBarItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colorConfig = M2PButtonColorConfigModel()
        colorConfig.backgroundActive = .background
        colorConfig.backgroundInActive = .background.withAlphaComponent(0.5)
       
        colorConfig.titleActive = .primaryActive
        colorConfig.titleInActive = .primaryActive.withAlphaComponent(0.5)
       
        colorConfig.primaryIconActive = .primaryActive
        colorConfig.primaryIconInActive = .primaryActive.withAlphaComponent(0.5)
       
        colorConfig.secondaryIconActive = .primaryActive
        colorConfig.secondaryIconInActive = .primaryActive.withAlphaComponent(0.5)
        
        colorConfig.borderActive = .primaryActive
        colorConfig.borderInActive = .primaryActive.withAlphaComponent(0.5)
        
        let config = M2PButtonConfigModel(title: "Chandru", primaryIcon: UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), secondaryIcon: UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate), colorConfig: colorConfig)
        config.titleFont = UIFont.customFont(name: "Arial-BoldMT", size: .x20)
        
        popAlertButton.M2PSetupButton(type: .secondary, style: .primaryIcon_text, config: config)
        
//        popAlertButton.isEnabled = false
//        popAlertButton.layer.cornerRadius = 25
        
        self.m2pSetupOtpView()
        self.otpView?.initializeUI()
        
        self.m2pSetupotpView_Two()
        self.otpView_Two?.initializeUI()
        
        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateProgressView), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.background
        self.titleLbl.font = UIFont.customFont(name: "Arial-BoldMT", size: .x34)
        self.titleLbl.backgroundColor = UIColor.PacificBlue66
        
        self.gradientBgView.configure(colors: [UIColor.PacificBlue66, UIColor.primaryActive, UIColor.secondaryRedColor])
        self.gradientBgView.layer.borderColor = UIColor.red.cgColor
        self.gradientBgView.layer.borderWidth = 0.6
        self.gradientBgView.layer.cornerRadius = 10.0
        self.gradientBgView.layer.masksToBounds = true
        
        chipView?.M2PSetUpChip(chipType: .info, contentType: .doubleSideIcon, borderType: .solid, textContent: M2PContentTextModel(text: "Chip", textColor: nil), primaryIcon: M2PContentImageModel(image: UIImage(named: "pencil"), tintColor: nil), secondaryIcon: M2PContentImageModel(image: UIImage(named: "pencil"), tintColor: nil), customBgColor: nil)
        
        setupMenuBar()
        
        // setupSearchBar()
        
        setupInputField()
        
//        setupButton()
        
        //Page Control
        pageControl.setup(for: 4, with: M2PPageControlConfig(image_inactive: UIImage(named: "pageControlIndicator")))
        self.view.addSubview(pageControl)
        
        // setupPageControl_LEFT()
        
        self.slider?.maximumTrackTintColor = UIColor.backgroundLightVarient
        self.slider?.minimumTrackTintColor = UIColor.secondaryRedColor
        self.slider?.M2PThumbTouchSize = CGSize(width: 24.0, height: 24.0)
        //        self.slider.setThumbImage(UIImage(named: "thumbHightlight"), for: .highlighted)
        //        self.slider.setThumbImage(UIImage(named: "thumbNormal"), for: .normal)
        
        setList()
        datepickerTF.isUserInteractionEnabled = true
        datepickerTF.addTarget(self, action: #selector(loadDatePicker), for: .touchDown)
    }
    
    private func setupMenuBar() {
        let image = UIImage(named: "plus.png")
        // MenuBar data
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Home", rightImage: image))
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Trending", rightImage: image))
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Account"))
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Profile", rightImage: image))
        
        var config = M2PTabBarItemConfig()
        config.titleFont = UIFont.customFont(name: "Arial-BoldMT", size: .x16)
        // var colorConfig = M2PTabBarColorConfig()
        // colorConfig.indicatorLine_selected = .GreenPigment66
        
        // Menu bar setup
        topTabBar.setup(with: tabItems, itemConfig: config)
        
        //Handling change
        topTabBar.onSelectedIndexChange = { selectedIndex in
            self.titleLbl.text = "Selected Tab : \(selectedIndex + 1)"
            
            self.pageControl?.currentPage = selectedIndex
            self.customPageControl.currentPage = selectedIndex
            
            self.inputFieldView?.M2PshowErrorWith(message: "Error \(selectedIndex)")
        }
    }
    
    private func setupSearchBar() {
        let searchbox = M2PSearchBar()
        searchbox.translatesAutoresizingMaskIntoConstraints = false
        
        searchbox.M2PonClickMic = {
            print("##Clicked Mic")
        }
        
        searchbox.M2PonClickCancel = {
            print("##Clicked Cancel button")
        }
        
        searchbox.M2PonSearchTextChange = { text in
            print("##Search Text: \(text)")
        }
        
        view.addSubview(searchbox)
        //Constraints
        searchbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchbox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchbox.topAnchor.constraint(equalTo: self.gradientBgView.bottomAnchor, constant: 10).isActive = true
        searchbox.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    // MARK: - CUSTOM Button
//    private func setupButton(){
//
//        self.m2pButton.M2PButtonConfig(type: .custom, title: "IndusLogo",
//                                       cornerRadius: 5,
//                                       buttonStyle: .DOUBLE_SIDE_ICON, //  NOICON, ONLYICON, LEFT_SIDE_ICON, RIGHT_SIDE_ICON, DOUBLE_SIDE_ICON
//                                       isPrimary: true,
//                                       leftImg: UIImage(named:"plus.png"),
//                                       rightImg: UIImage(named:"plus.png"),
//                                       leftIconWidth: 20,
//                                       leftIconHeight: 20,
//                                       rightIconWidth: 20,
//                                       rightIconHeight: 20,
//                                       state: .ENABLE,// ENABLE / DISABLE
//                                       leftIconTint:.blue,
//                                       rightIconTint: .orange)
//        self.m2pButton.onClick = { sender in
//            self.index -= 1
//            self.topTabBar.updateSelectedIndexInCollection(at:self.index)
//            self.inputFieldView?.M2PhideErrorMessage()
//        }
//
//        var config : M2PButton.M2PColorConfig = M2PButton.M2PColorConfig()
//        config.bgColorEnable = UIColor.black
//        config.titleColorEnable = UIColor.white
//        config.borderColorEnable = UIColor.orange
//        self.m2pButton.M2PColorSetConfig(config)
//    }
    
    private func setupInputField() {
        inputFieldView = M2PInputField(frame: CGRect(x: 20, y: view.frame.midY - 120, width: view.frame.width - 40 , height: 80))
        
        guard let inputField = inputFieldView else {
            return
        }
        
//        var colors = M2PInputFieldColorConfig()
//        colors.title = .linksText
//        var fonts = M2PInputFieldFontConfig()
//        fonts.placeHolderFont = UIFont.customFont(name: "Arial-BoldMT", size: .x14)
//        let config = M2PInputFieldConfig(placeholder: "Enter name", fieldStyle: .Form_Floating, fieldFonts: fonts, fieldColors: colors)
       
        var colorConfig = M2PInputFieldColorConfig()
        colorConfig.defaultBorder = .lightGray
        colorConfig.activeBorder = .primaryActive
        
        let config = M2PInputFieldConfig(placeholder: "Enter Name", fieldStyle: .Form_Default, fieldColors: colorConfig)
        var imageConfig = M2PFieldTypeImageConfig()
        imageConfig.calendar_default = UIImage(named: "thumbHightlight")
        
        inputField.M2Psetup(type: .Default_TextField, config: config) // , leftImage: UIImage(named: "pencil"))
        
        inputField.M2PonClickFieldTypeView = { (type, isActive) in
            if type == .Dropdown {
                self.titleLbl.text = "Dropdown \(isActive ? "Active" : "Inactive")"
            }
            if type == .CalendarCustom {
                inputField.M2PSetInputFieldState(isActive: isActive)
            }
            
        }
        
        view.addSubview(inputField)
        
    }
    
    func setupPageControl_LEFT() {
        let indicatorImage = UIImage(named: "pageControlIndicator")
        
        customPageControl.setup(for: tabItems.count, with: M2PPageControlConfig(indicatorsAlignment: .leftMost, image_inactive: indicatorImage))
        customPageControl.translatesAutoresizingMaskIntoConstraints =  false
        self.view.addSubview(customPageControl)
        setPageControlConstraints()
    }
    
    private func setPageControlConstraints() {
        customPageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        customPageControl.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        customPageControl.widthAnchor.constraint(equalToConstant: customPageControl.size(forNumberOfPages: tabItems.count).width + 10).isActive = true
        customPageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateProgressView() {
        self.indicatorValue += 0.01
        
        M2PProgressLoader.updateProgress(title: "Processing...", percent: self.indicatorValue)
    }
    
    func DotLoader() {
        var config : M2PDotLoader.M2PConfigDot = M2PDotLoader.M2PConfigDot()
        config.backgroundColor = UIColor.background
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        M2PDotLoader.M2PDotLoaderSetConfig(config)
        M2PDotLoader.M2PDotLoaderShow(animated: true)
        delay(seconds: 6.0) { () -> () in
            M2PDotLoader.M2PDotLoaderHide()
        }
    }
    
    func SpinnerLoader() {
        var config : M2PLoader.M2PConfig = M2PLoader.M2PConfig()
        config.backgroundColor = UIColor.background
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        M2PLoader.M2PLoaderSetConfig(config)
        
        //        M2PLoader.M2PLoaderShow(animated: true)
        M2PLoader.M2PLoaderShow(title: "Processing...", animated: true)
        
        //        delay(seconds: 3.0) { () -> () in
        //            M2PLoader.M2PLoaderShow(title: "Loading...", animated: true)
        //        }
        //
        delay(seconds: 6.0) { () -> () in
            M2PLoader.M2PLoaderHide()
        }
    }
    
    func progressLoader() {
        var config : M2PProgressLoader.M2PConfigProgress = M2PProgressLoader.M2PConfigProgress()
        config.backgroundColor = UIColor.clear
        config.logoColor = UIColor.background
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        M2PProgressLoader.M2PProgressSetConfig(config)
        M2PProgressLoader.M2PProgressShow(animated: true)
        delay(seconds: 10.0) { () -> () in
            M2PProgressLoader.M2PProgressHide()
        }
    }
    
    
    func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    
    private func setList() {
        let primaryContent = M2PLeadingContentList(headerTextLabel: M2PContentTextModel(text: "Header", textColor: .red, textFont: .systemFont(ofSize: 17)), subTextLabel: M2PContentTextModel(text: "sub", textColor: .lightGray, textFont: .systemFont(ofSize: 13)), icon: M2PContentImageModel(image: UIImage(named: "side_icon")?.withRenderingMode(.alwaysTemplate), tintColor: .primaryActive))
        let secondaryContent = M2PTrailingContentList(contentType: .texts, headerTextLabel: M2PContentTextModel(text: "Header", textColor: .primaryActive, textFont: .systemFont(ofSize: 17)), subTextLabel: M2PContentTextModel(text: "sub", textColor: .DavysGrey66, textFont: .systemFont(ofSize: 13)), actionTitleLabel: M2PContentTextModel(text: "Change", textColor: .blue, textFont: .systemFont(ofSize: 15)), icon:  M2PContentImageModel(image: UIImage(named: "pencil"), tintColor: nil))

        listView?.M2PSetupList(leadingContent: primaryContent, trailingContent: secondaryContent, isbottomLineView: true)
        listView?.onActionClick = { sender in
            print("\(sender.tag)")
        }
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        var preferences = M2PToolTipView.Preferences()
        preferences.drawing.backgroundColor = UIColor(hue:0.58, saturation:0.1, brightness:1, alpha:1)
        preferences.drawing.foregroundColor = UIColor.darkGray
        preferences.drawing.textAlignment = NSTextAlignment.center
        preferences.drawing.font = UIFont(name: "HelveticaNeue-Light", size: 14)!
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1
        preferences.animating.dismissDuration = 1
        preferences.drawing.arrowPosition = .any
        preferences.animating.dismissOnTap = true
        
        let view = M2PToolTipView(text: "Tip view within the green superview. Tap to dismiss.", preferences: preferences)
        view.show(forView: self.toolTipBtn, withinSuperview: self.view)
    }
}

extension ViewController {
    // MARK: - POP ALERT
    
    @IBAction func alertPopActn(_ sender: UIButton){
        print(sender.isHighlighted)
        sender.isEnabled = false
//        self.popAlertButton.M2PPrimaryIconUpdateWithState(value: UIImage(named: "pencil")?.withRenderingMode(.alwaysTemplate), isEnabled: false)
//        self.popAlertButton.M2PButtonTitleUpdateWithState(value: "Ola", isEnabled: false)
//        self.popAlertButton.M2PBorderColorUpdate(active: .primaryActive, inActive: .systemPink)
        
        
        
//        self.popAlertButton.M2PBackgroundColorUpdate(active: .primaryActive, inActive: .systemBlue.withAlphaComponent(0.5))
//        self.popAlertButton.M2PSecondaryStateBorderColor = .secondaryInactive
//        sender.isEnabled = false
        
//        let customAlert = M2PPopAlert(nibName: "M2PPopAlert", bundle: M2PComponentsBundle.shared.currentBundle)
//        customAlert.enableButtonList = [.Leading,.Center,.Trailing]
//        customAlert.posistion = .Top // .Top , .Center , .Bottom
//        customAlert.alertBgColor = UIColor.background
//        customAlert.alertTitleColor = UIColor.primaryActive
//        customAlert.alertMessageColor = UIColor.focusedLine
//        customAlert.titleFont = UIFont.customFont(name: "Arial-BoldMT", size: .x20)
//        customAlert.messageFont = UIFont.customFont(name: "Arial", size: .x18)
//        customAlert.alertTitle = "Verification"
//        customAlert.alertMessage = "Your Information in the audit"
//        customAlert.statusImage = UIImage.init(named: "alert")
//        customAlert.delegate = self
//        customAlert.alertTag = 1
//        customAlert.show()
//        // MARK:  M2PButton should configure after present Pop (i.e) after func show() called
//        customAlert.leadingButton.M2PButtonConfig(type: .custom,title: "Learn", isPrimary: false)
//        customAlert.centerButton.M2PButtonConfig(type: .custom, title: "Cancel")
//        customAlert.trailingButton.M2PButtonConfig(type: .custom, title: "Ok")
    }
    
    // MARK: - CUSTOM ALERT func enteredOTP(_ OTPView: OTPFieldView,otp: String)
    
    @IBAction func alertCustomActn(_ sender: UIButton){
        let customAlert = M2PCustomAlert(nibName: "M2PCustomAlert", bundle: M2PComponentsBundle.shared.currentBundle)
        customAlert.enableButtonList = [.primary,.secondary]
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
//        customAlert.submitButton.M2PButtonConfig(type: .custom,title: "Submit", isPrimary: false)
//        customAlert.secondaryButton.M2PButtonConfig(type: .custom, title: "Cancel")
        // Textfield
        customAlert.didChange = { text in
            print(text)
        }
    }
}

// MARK: - M2PPopAlertDelegate
extension ViewController: M2PPopAlertDelegate {
    func secondaryButtonPressed(_ alert: M2PPopAlert, alertTag: Int) {
        print("Learn button pressed")
    }
    func okButtonPressed(_ alert: M2PPopAlert, alertTag: Int) {
        print(alert.alertTitle ?? "")
    }
    func cancelButtonPressed(_ alert: M2PPopAlert, alertTag: Int) {
        print("Cancel button pressed")
    }
}
// MARK: - M2PCustomAlertDelegate
extension ViewController: M2PCustomAlertDelegate {
    func closeButtonPressed(_ alert: M2PCustomAlert, alertTag: Int) {
        print(alert.text)
    }
    func submitButtonPressed(_ alert: M2PCustomAlert, alertTag: Int) {
        print(alert.text)
    }
    func secondaryButtonPressed(_ alert: M2PCustomAlert, alertTag: Int) {
        print("Cancel button pressed")
    }
}

// MARK: - OTPFieldViewDelegate
extension ViewController: OTPFieldViewDelegate {
  
    
    // MARK: - OTP
    func m2pSetupOtpView(){
        self.otpView?.displayType = .square
        self.otpView?.fieldsCount = 6
        self.otpView?.fieldBorderWidth = 1
        self.otpView?.defaultBorderColor = UIColor.borderDefault
        self.otpView?.filledBorderColor = UIColor.linksText
        self.otpView?.cursorColor = UIColor.primaryActive
        self.otpView?.filledBackgroundColor = UIColor.background
        self.otpView?.fieldSize = 42
        self.otpView?.separatorSpace = 15
        self.otpView?.shouldAllowIntermediateEditing = false
        self.otpView?.secureEntry = true
        self.otpView?.OTPTag = 1
        self.otpView?.delegate = self
    }
    
    // MARK: - OTP
    func m2pSetupotpView_Two(){
        self.otpView_Two?.displayType = .underlinedBottom
        self.otpView_Two?.fieldsCount = 6
        self.otpView_Two?.fieldBorderWidth = 1
        self.otpView_Two?.defaultBorderColor = UIColor.borderDefault
        self.otpView_Two?.filledBorderColor = UIColor.linksText
        self.otpView_Two?.cursorColor = UIColor.primaryActive
        self.otpView_Two?.filledBackgroundColor = UIColor.background
        self.otpView_Two?.fieldSize = 42
        self.otpView_Two?.separatorSpace = 15
        self.otpView_Two?.shouldAllowIntermediateEditing = false
        self.otpView_Two?.secureEntry = true
        self.otpView_Two?.secureType = .STAR
        self.otpView_Two?.OTPTag = 2
        self.otpView_Two?.delegate = self
    }
    
    func enteredOTP(otp: String) {
        print("OTP:\(otp))")
    }
    func hasEnteredAllOTP(_ otpView: OTPFieldView,hasEnteredAll hasEntered: Bool) -> Bool {
        if hasEntered {
            return true
        }else{
            return false
        }
    }
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        print("otp index:\(index)")
        return true
    }
    func enteredOTP(_ otpView: OTPFieldView,otp otpString: String) {
        print("OTPString: \(otpView.OTPTag) :\(otpString)")
    }
    
    @objc private func loadDatePicker(){
        M2PDatePicker.shared.m2pAddDatePicker(backGroundColor: .background, textColor: .secondaryRedColor)
        M2PDatePicker.shared.getSelectedDate = { date in
            if let fetchdate = date {
                self.datepickerTF.text = fetchdate.description
            }
        }
    }
    
}
