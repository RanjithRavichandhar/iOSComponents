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
    
    @IBOutlet weak var listView: M2PList?
    @IBOutlet weak var chipView: M2PChip?
    @IBOutlet weak var topTabBar: M2PTopTabBar?
    @IBOutlet weak var toggle: UISwitch?
    @IBOutlet weak var stepper: M2PStepper?
    @IBOutlet weak var otpView: OTPFieldView?
    @IBOutlet weak var segmentControl: M2PSegmentedControl?
    @IBOutlet weak var slider: M2PSlider!
    @IBOutlet weak var pageControll: M2PCustomPageControl?
    @IBOutlet weak var pageControll_2: M2PCustomPageControl?
    
    private var indicatorValue: Float = 0.0
    var progressBarTimer: Timer!
    
    // MARK: - M2PButton
    @IBOutlet weak var m2pButton: M2PButton! {
        didSet{
            self.m2pButton.config(type: .custom, title: "Tab",
                                  buttonStyle: .DOUBLE_SIDE_ICON, //  NOICON, ONLYICON, LEFT_SIDE_ICON, RIGHT_SIDE_ICON, DOUBLE_SIDE_ICON
                                  isPrimary: true,
                                  bgColor: .clear,
                                  leftImg: UIImage(named:"plus.png"),
                                  rightImg: UIImage(named:"plus.png"),
                                  leftIconWidth: 20,
                                  leftIconHeight: 20,
                                  rightIconWidth: 20,
                                  rightIconHeight: 20,
                                  state: .ENABLE) // ENABLE / DISABLE
            self.m2pButton.onClick = { sender in
                //                    self.index -= 1
                //                    self.topTabBar.updateSelectedIndexInCollection(at:self.index)
                self.setupBottomBar()
            }
        }
    }
    
    var index = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateProgressView), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.background
        
        toggle?.tintColor = .DavysGrey100
        toggle?.thumbTintColor = .PacificBlue100
        toggle?.onTintColor = .ImperialRed66
        
        setupPageControl()
        setupSlider()
        configureSegment()
        setupChip()
        setupList()
        setupMenuBar()
        setupStepper()
        setupOtpView()
        self.otpView?.initializeUI()
    }
    
    // MARK: - Segment Control
    func configureSegment() {
        var segmentColor = M2PSegmentColorConfiguration()
        segmentColor.thumbColor = UIColor.ImperialRed100
        segmentColor.unselectedLabelColor = UIColor.Yellow100
        segmentColor.selectedLabelColor = UIColor.OceanBlue100
        segmentColor.backGroundColor = UIColor.backgroundLightVarient
        segmentColor.borderColor = UIColor.GreenPigment100
        
        self.segmentControl?.items = ["Select Currency", "Select Country", "Transactions", "Statement"]
        self.segmentControl?.configuration()
        self.segmentControl?.selectedIndex = 0
        self.segmentControl?.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged() {
        print(self.segmentControl?.selectedIndex)
    }
    
    // MARK: - CHIP
    private func setupChip() {
        chipView?.M2PSetUpChip(chipType: .info, contentType: .doubleSideIcon, borderType: .solid, title: "Chip", titleFont: UIFont.customFont(name: "Arial-BoldMT", size: .x17), primaryIcon: UIImage(named: "pencil"), secondaryIcon: UIImage(named: "pencil"))
    }
    
    //MARK: - LIST
    private func setupList() {
        let primaryContent = M2PLeadingContentList(headerTextLabel: M2PContentTextModel(text: "Header", textColor: .red, textFont: .systemFont(ofSize: 17)), subTextLabel: M2PContentTextModel(text: "sub", textColor: .lightGray, textFont: .systemFont(ofSize: 13)), icon: M2PContentImageModel(image: UIImage(named: "side_icon")?.withRenderingMode(.alwaysTemplate), tintColor: .primaryActive))
        primaryContent?.isAvatorIcon = false
        
        let secondaryContent = M2PTrailingContentList(contentType: .texts, headerTextLabel: M2PContentTextModel(text: "Header", textColor: .primaryActive, textFont: .systemFont(ofSize: 17)), subTextLabel: M2PContentTextModel(text: "sub", textColor: .DavysGrey66, textFont: .systemFont(ofSize: 13)), actionTitleLabel: M2PContentTextModel(text: "Change", textColor: .blue, textFont: .systemFont(ofSize: 15)), icon:  M2PContentImageModel(image: UIImage(named: "pencil")))
        
        listView?.tag = 5
        listView?.M2PSetupList(leadingContent: primaryContent, trailingContent: secondaryContent, isbottomLineView: true)
        listView?.onActionClick = { sender in
            print("\(sender.tag)")
        }
        listView?.checkBoxView.checkBoxShapes = .box
    }
    
    // MARK: - TOP TABBAR
    private func setupMenuBar() {
        let image = UIImage(named: "plus.png")
        // MenuBar data
        var tabItems : [M2PTopTabBarItem] = []
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Home", rightImage: image))
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Trending", rightImage: image))
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Account"))
        tabItems.append(M2PTopTabBarItem(leftImage: image, title: "Profile", rightImage: image))
        
        var config = M2PTabBarItemConfig()
        config.titleFont = UIFont.customFont(name: "Arial-BoldMT", size: .x16)
        // var colorConfig = M2PTabBarColorConfig()
        // colorConfig.indicatorLine_selected = .GreenPigment66
        
        // Menu bar setup
        topTabBar?.setup(with: tabItems, itemConfig: config)
        
        //Handling change
        topTabBar?.onSelectedIndexChange = { selectedIndex in
            //            self.titleLbl.text = "Selected Tab : \(selectedIndex + 1)"
            self.pageControll?.currentPage = (selectedIndex)
            self.pageControll_2?.currentPage = (selectedIndex)
        }
    }
    
    // MARK: - PageControl
    
    func setupPageControl() {
        pageControll?.setup(for: 4, with: M2PPageControlConfig(indicatorsAlignment: .leftMost, image_inactive: UIImage(named: "pageControlIndicator")))
        pageControll_2?.setup(for: 4, with: M2PPageControlConfig(indicatorsAlignment: .any, image_inactive: UIImage(named: "pageControlIndicator")))
    }
    
    // MARK: - SLIDER
    func setupSlider() {
        self.slider.maximumTrackTintColor = UIColor.backgroundLightVarient
        self.slider.minimumTrackTintColor = UIColor.secondaryRedColor
        self.slider.thumbTouchSize = CGSize(width: 24.0, height: 24.0)
        //        self.slider.setThumbImage(UIImage(named: "thumbHightlight"), for: .highlighted)
        //        self.slider.setThumbImage(UIImage(named: "thumbNormal"), for: .normal)
    }
    
    // MARK: - STEPPER
    private func setupStepper() {
        stepper?.setUpStepper(stepperType: .withCount, colorSet: StepperColorSetup(stepperBGColor: .backgroundLightVarient, buttonBGColor: .clear, buttonTextColor: .secondaryInactive, selectButtonBGColor: .white, selectButtonTextColor: .secondaryRedColor, countLableBGColor: .background, countLableTextColor: .primaryActive))
        
        stepper?.onClick = { (isPluseTap, Count) in
            //            self.titleLbl.text = "\(Count)"
        }
    }
    
    // MARK: - BOTTOM TABBAR
    private func setupBottomBar() {
        let tabbarController = M2PBottomNavigation()
        let tabBarItems = [TabBarItems(storyboardName: "Main",
                                       controllerName: "blue",
                                       image: "Home_tab",
                                       selectedIimage: "Home_tab_selected",
                                       order: 0,
                                       title: "home"),
                           TabBarItems(storyboardName: "Main",
                                       controllerName: "blue",
                                       image: "cam",
                                       selectedIimage: "cam_selected",
                                       order: 0,
                                       title: "Test")
        ]
        
        tabbarController.tintColor = .ImperialRed100
        tabbarController.setUpTabbar(tabBarItems: tabBarItems)
        
        present(tabbarController, animated: true, completion: nil)
        //         self.navigationController?.pushViewController(tabbarController, animated: true)
    }
    
    // MARK: - BOTTOM SHEET
    private func setupBottomSheet() {
        let popupNavController = self.storyboard?.instantiateViewController(withIdentifier: "CheckBottomSheetNavigation") as! CheckBottomSheetNavigation
        popupNavController.height = 500
        popupNavController.topCornerRadius = 35
        popupNavController.presentDuration = 0.5
        popupNavController.dismissDuration = 0.5
        popupNavController.shouldDismissInteractivelty = true
        self.present(popupNavController, animated: true, completion: nil)
    }
    
    // MARK: - OTP
    func setupOtpView(){
        
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
        self.otpView?.delegate = self
    }
    
    @IBAction func bottomSheetTapped(_ sender: Any) {
        setupBottomSheet()
    }
    
    // MARK: - ACTION SHEET
    @IBAction func actionTapped(_ sender: Any) {
        let action = M2PActionSheet(title: nil, message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let lead = M2PLeadingContentList(headerTextLabel: M2PContentTextModel(text: "Header", textColor: .primaryActive, textFont: .systemFont(ofSize: 17)), subTextLabel: M2PContentTextModel(text: "Sub", textColor: .primaryActive, textFont: .systemFont(ofSize: 12)), icon: M2PContentImageModel(image: UIImage(named: "")?.withRenderingMode(.alwaysTemplate), tintColor: .primaryActive), isAvatorIcon: false)
        
        action.M2PSetUpActionView(headerContent: lead, items: [M2PActionItems(text: "Open Settings", image: UIImage(named: "setting"), textColor: .primaryActive , tintColor: .primaryActive, font: .systemFont(ofSize: 15)),
                                                            M2PActionItems(text: "Refresh", image: UIImage(named: ""), textColor: .primaryActive, tintColor: .primaryActive, font: .systemFont(ofSize: 15)),
                                                            M2PActionItems(text: "Delete", image: UIImage(named: "delete"), textColor: .red, tintColor: .primaryActive, font: .systemFont(ofSize: 15)),
                                                           ]) { index in
            action.dismiss(animated: true, completion: nil)

        }
        self.present(action, animated: false, completion: nil)
    }
    
    // MARK: - POP ALERT
    @IBAction func alertPopActn(_ sender: UIButton){
        let customAlert = M2PPopAlert(nibName: "M2PPopAlert", bundle: M2PComponentsBundle.shared.currentBundle)
        customAlert.enableButtonList = [.Leading,.Center,.Trailing]
        customAlert.posistion = .Top // .Top , .Center , .Bottom
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
        customAlert.show()
        
        // MARK:  M2PButton should configure after present Pop (i.e) after func show() called
        customAlert.leadingButton.config(type: .custom,title: "Learn", isPrimary: false, bgColor: .primaryActive)
        customAlert.centerButton.config(type: .custom, title: "Cancel", bgColor: .backgroundLightVarient)
        customAlert.trailingButton.config(type: .custom, title: "Ok", bgColor: .primaryActive)
    }
    
    // MARK: - CUSTOM ALERT
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
    
    
    @IBAction func toolTipTapped(_ sender: Any) {
        var preferences = M2PToolTipView.globalPreferences
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.font = UIFont(name: "HelveticaNeue-Light", size: 14)!
        preferences.drawing.textAlignment = NSTextAlignment.justified
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1
        preferences.animating.dismissDuration = 1
        preferences.drawing.arrowPosition = .top
        
        let text = "Tip view inside the navigation controller's view. Tap to dismiss!"
        M2PToolTipView.show(forView: (sender as? UIButton)!,
            withinSuperview: self.navigationController?.view,
            text: text,
            preferences: preferences)
    }
    
    @IBAction func dotLoaderTapped(_ sender: Any) {
        DotLoader()
    }
    
    
    @IBAction func spinnerLoaderTapped(_ sender: Any) {
        SpinnerLoader()
    }
    
    @IBAction func progressLoaderTapped(_ sender: Any) {
        progressLoader()
    }
    
    @objc func updateProgressView() {
        self.indicatorValue += 0.01
        
        M2PProgressLoader.updateProgress(title: "Processing...", percent: self.indicatorValue)
    }
    
    // MARK: - DOT LOADER
    func DotLoader() {
        var config : M2PDotLoader.ConfigDot = M2PDotLoader.ConfigDot()
        config.backgroundColor = UIColor.background
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        M2PDotLoader.setConfig(config)
        M2PDotLoader.show(animated: true)
        delay(seconds: 5.0) { () -> () in
                        M2PDotLoader.hide()
        }
    }
    
    // MARK: - SPINNER LOADER
    func SpinnerLoader() {
        var config : M2PLoader.Config = M2PLoader.Config()
        config.backgroundColor = UIColor.background
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        M2PLoader.setConfig(config)
        
        //        M2PLoader.show(animated: true)
        M2PLoader.show(title: "Processing...", animated: true)
        
        //        delay(seconds: 3.0) { () -> () in
        //            M2PLoader.show(title: "Loading...", animated: true)
        //        }
        //
        delay(seconds: 5.0) { () -> () in
                        M2PLoader.hide()
        }
    }
    
    // MARK: - PROGRESS LOADER
    func progressLoader() {
        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateProgressView), userInfo: nil, repeats: true)
        
        var config : M2PProgressLoader.ConfigProgress = M2PProgressLoader.ConfigProgress()
        config.backgroundColor = UIColor.clear
        config.logoColor = UIColor.background
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        M2PProgressLoader.setConfig(config)
        M2PProgressLoader.show(animated: true)
        delay(seconds: 10.0) { () -> () in
            M2PProgressLoader.hide()
            self.indicatorValue = 0
            self.progressBarTimer.invalidate()
            self.progressBarTimer = nil
        }
    }
    
    
    func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
}

// MARK: - M2PPopAlertDelegate
extension ViewController: M2PPopAlertDelegate {
    func learnButtonPressed(_ alert: M2PPopAlert, alertTag: Int) {
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
        print(alert.alertTitle ?? "")
        print(alert.text)
    }
    func secondaryButtonPressed(_ alert: M2PCustomAlert, alertTag: Int) {
        print("Cancel button pressed")
    }
}

// MARK: - OTPFieldViewDelegate
extension ViewController: OTPFieldViewDelegate {
    func enteredOTP(otp: String) {
        print("OTP:\(otp)")
    }
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
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
    func enteredOTP(otp otpString: String, otpView: OTPFieldView) {
        print("OTPString: \(otpString)")
    }
}
