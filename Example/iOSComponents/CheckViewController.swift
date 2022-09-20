//
//  CheckViewController.swift
//  iOSComponents_Example
//
//  Created by SENTHIL KUMAR on 08/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import iOSComponents

struct SelectedCheckBox {
    var isSelected: Bool
}
class CheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var enableButtnSwitch: UISwitch!
    @IBOutlet weak var checkSwitch: UISwitch!
    @IBOutlet weak var checkTableView: UITableView!
    
    var isCheckBox = true
    var isInitialSelect = true
    var radioSelectedIndex: Int?
    var selectedCheckBox = [SelectedCheckBox]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let dashView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 5))
        dashView.translatesAutoresizingMaskIntoConstraints = false
        dashView.backgroundColor = .black
        let contentView = UIView()
                self.navigationItem.titleView = contentView
                self.navigationItem.titleView?.addSubview(dashView)
        dashView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dashView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTableView.delegate = self
        checkTableView.dataSource = self
        
        for _ in 1...50 {
            selectedCheckBox.append(SelectedCheckBox(isSelected: false))
        }
        checkSwitch.onClick { sender in

            if sender.isOn {
                print("ON---->>>>")
                self.isCheckBox = true
            } else {
                print("OFF---->>>>")
                self.isCheckBox = false
            }
            
            self.checkTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedCheckBox.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckTableViewCell", for: indexPath) as! CheckTableViewCell
        cell.selectionStyle = .none
        checkSwitch.tag = indexPath.row
        cell.checkBoxView.tag = indexPath.row
        cell.radioButtonView.tag = indexPath.row
        
        if isCheckBox {
            cell.radioButtonView.isHidden = true
            cell.checkBoxView.isHidden = false
        } else {
            cell.checkBoxView.isHidden = true
            cell.radioButtonView.isHidden = false
        }
        
        
        
//        cell.checkBoxView.setUpCheckBox(forSelectedImage: CheckBoxProperties(image: UIImage(named: "checkbox_fill1"), tintColor: UIColor.primaryActive), forUnSelectedImage: CheckBoxProperties(image: UIImage(named: "checkbox_unfill"), tintColor: UIColor.primaryActive), initialState: .unSelected, checkBoxShapes: .box)
        
//        cell.radioButtonView.setUpRadioButton(forSelectedImage: RadioButtonProperties(image: UIImage(named: "radio_select"), tintColor: UIColor.primaryActive), forUnSelectedImage: RadioButtonProperties(image: UIImage(named: "radio_unselect"), tintColor: UIColor.primaryActive), initialState: .unSelected)
        
        if selectedCheckBox[indexPath.row].isSelected == true {
            cell.checkBoxView.enableDisableCheckBox( withState: .selected)
        } else {
            cell.checkBoxView.enableDisableCheckBox( withState: .unSelected)
        }
        
        if indexPath.row == radioSelectedIndex {
            cell.radioButtonView.setSelected()
        } else {
            cell.radioButtonView.setUnSelected()
        }
        
        cell.checkBoxView.onClick = { (isTap,sender) in
            self.isInitialSelect = false
            self.selectedCheckBox[sender.view?.tag ?? -1].isSelected = isTap
        }
        
        cell.radioButtonView.onClick = { sender in
            
            self.radioSelectedIndex = sender.view?.tag//indexPath.row
            self.checkTableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isCheckBox {
        self.isInitialSelect = false
        self.radioSelectedIndex = indexPath.row
        self.checkTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GreenViewController") as! GreenViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
  

}

class CheckTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxView: M2PCheckBox!
    @IBOutlet weak var radioButtonView: M2PRadioButton!
   
}


class GreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pushButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PurpleViewController") as! PurpleViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class PurpleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
