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
                    print("\(sender.currentTitle ?? "")")
                }
            }
        }
    
    
    @IBOutlet weak var listView: M2PList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.background
        self.titleLbl.font = UIFont.customFont(name: "Arial-BoldMT", size: .x34)
        self.titleLbl.backgroundColor = UIColor.PacificBlue66
        
        self.gradientBgView.configure(colors: [UIColor.PacificBlue66, UIColor.primaryActive, UIColor.secondaryRedColor])
        self.gradientBgView.layer.borderColor = UIColor.red.cgColor
        self.gradientBgView.layer.borderWidth = 0.6
        self.gradientBgView.layer.cornerRadius = 10.0
        self.gradientBgView.layer.masksToBounds = true
        
        chipView?.setUpChip(chipType: .primary, contentType: .doubleSideIcon, borderType: .solid, title: "Chip", titleFont: UIFont.customFont(name: "Arial-BoldMT", size: .x18), primaryIcon: UIImage(named: "pencil"), secondaryIcon: UIImage(named: "pencil"))
        
        
        
        let primaryContent = LeadingContentList(headerTextLabel: ContentTextModel(text: "Header", textColor: .red, textFont: .systemFont(ofSize: 17)), subTextLabel: ContentTextModel(text: "sub", textColor: .lightGray, textFont: .systemFont(ofSize: 13)), icon: UIImage(named: ""))
        primaryContent?.isAvatorIcon = true
        
        let secondaryContent = TrailingContentList(contentType: .texts, headerTextLabel: ContentTextModel(text: "Header", textColor: .primaryColor, textFont: .systemFont(ofSize: 17)), subTextLabel: ContentTextModel(text: "sub", textColor: .DavysGrey66, textFont: .systemFont(ofSize: 13)), actionTitleLabel: ContentTextModel(text: "Change", textColor: .blue, textFont: .systemFont(ofSize: 15)), icon:  UIImage(named: "pencil"))
        secondaryContent?.isToggleEnable = .enable
        secondaryContent?.isToggleOn = .on
        
        listView?.tag = 5
        listView?.setupList(leadingContent: primaryContent, trailingContent: secondaryContent, isbottomLineView: true)
        listView?.onActionClick = { sender in
            print("\(sender.tag)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

