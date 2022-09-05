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

    @IBOutlet private weak var titleLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.background
        self.titleLbl.font = UIFont.customFont(name: "Arial-BoldMT", size: .x34)
        self.titleLbl.backgroundColor = UIColor.PacificBlue66
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

