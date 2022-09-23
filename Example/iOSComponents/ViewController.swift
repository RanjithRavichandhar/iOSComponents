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
    @IBOutlet weak var slider: M2PSlider!
    @IBOutlet weak var pageControl: M2PCustomPageControl!
    
    private var indicatorValue: Float = 0.0
    var progressBarTimer: Timer!

    @IBOutlet weak var m2pButton: M2PButton! {
            didSet{
                self.m2pButton.config(type: .custom, title: "IndusLogo",
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
                    self.index -= 1
                    self.topTabBar.updateSelectedIndexInCollection(at:self.index)
                }
            }
        }
    
    //Page control
    var customPageControl = M2PCustomPageControl()
    
    // Menu bar
    var index = 4
    var tabItems : [M2PTopTabBarItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        chipView?.setUpChip(chipType: .info, contentType: .doubleSideIcon, borderType: .solid, title: "Chip", titleFont: UIFont.customFont(name: "Arial-BoldMT", size: .x18), primaryIcon: UIImage(named: "pencil"), secondaryIcon: UIImage(named: "pencil"))
        
        setupMenuBar()
        
        //Page Control
        pageControl.setup(for: 4, with: M2PPageControlConfig(image_inactive: UIImage(named: "pageControlIndicator")))
        self.view.addSubview(pageControl)
        
        setupPageControl_LEFT()
        
        self.slider.maximumTrackTintColor = UIColor.backgroundLightVarient
        self.slider.minimumTrackTintColor = UIColor.secondaryRedColor
        self.slider.thumbTouchSize = CGSize(width: 24.0, height: 24.0)
//        self.slider.setThumbImage(UIImage(named: "thumbHightlight"), for: .highlighted)
//        self.slider.setThumbImage(UIImage(named: "thumbNormal"), for: .normal)
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
        }
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
}

