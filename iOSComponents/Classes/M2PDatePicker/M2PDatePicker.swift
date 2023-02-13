//
//  M2PDatePicker.swift
//  iOSComponents
//
//  Created by Manjunathan Karuppasamy on 07/09/22.
//

/*  M2PDatePicker.shared.m2pConfigureDatePicker(contentView: self, backGroundColor: .backgroundLightVarient, textColor: .secondaryRedColor, minDate: nil, maxDate: nil, dismissOuter: true)
 M2PDatePicker.shared.getSelectedDate = { date in
     let formatter = DateFormatter()
     formatter.dateFormat = "dd/MM/yyyy"
     self.datePickerTF.text = formatter.string(from: date ?? Date())
    print("DateValue\(date ?? Date())")
}*/
import Foundation
import UIKit

public class M2PDatePicker:UIView {
    public static var shared = M2PDatePicker()
    var selectedDate = Date()
    public var getSelectedDate:((Date?) -> ())?
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.tag = 100
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))))
        view.backgroundColor = .black.withAlphaComponent(0.8)
        return view
        
    }()
    
    private lazy var viewContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
        
    }()
    
    private lazy var date_Picker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        // Apply Primary Color
//        datepicker.setValue(0.8, forKeyPath: "alpha")
        datepicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datepicker.preferredDatePickerStyle = .wheels
            datepicker.setValue(false, forKey: "highlightsToday")
        } else {
            //Fallback on earlier versions
        }
        datepicker.calendar = Calendar.init(identifier: .gregorian)
        datepicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datepicker.contentMode = .scaleToFill
        return datepicker
    }()
    
    private lazy var tool_Bar :UIToolbar = {
        let pickerToolbar = UIToolbar()
        pickerToolbar.translatesAutoresizingMaskIntoConstraints = false
        pickerToolbar.barStyle = .default
        pickerToolbar.isTranslucent = true
        let width = UIScreen.main.bounds.width * 0.9
        
        // Add items
        let headerLbl = UIBarButtonItem(title: "Select Date", style: .done, target: nil, action: nil)
        headerLbl.tintColor = .primaryActive
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnClicked))
        doneBtn.tintColor = .primaryActive
        
        let flexView = UIView()
        let calculatedwidth =  width > 330 ? width * 0.43 : width * 0.35
        flexView.frame = CGRect(x: 0.0, y: 0.0, width:  calculatedwidth, height: 45.0)
        flexView.isUserInteractionEnabled = false
        flexView.tag = 2100
        flexView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))))
        let flexSpace = UIBarButtonItem(customView: flexView)
        
        //add the items to the toolbar
        pickerToolbar.items = [headerLbl, flexSpace, doneBtn]
        return pickerToolbar
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        self.selectedDate = sender.date
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 100 {
            self.dimmedView.removeFromSuperview()
        }
    }
    
    @objc private func doneBtnClicked(_ button: UIBarButtonItem?) {
        formatDate(date:self.selectedDate)
    }
    
    private func formatDate(date:Date?){
        getSelectedDate?(date ?? Date())
        self.dimmedView.removeFromSuperview()
    }
    
}

//MARK: Initialize UI and its Actions
extension M2PDatePicker {
    
    public func m2pAddDatePicker(backGroundColor: UIColor, textColor: UIColor, minDate: Date? = nil, maxDate: Date? = nil, selectedDate: Date? = nil, height: Double? = nil){
        
        if let topVC = getTopViewController() {
            date_Picker.backgroundColor = backGroundColor
            tool_Bar.backgroundColor = backGroundColor
            date_Picker.setValue(textColor, forKey: "textColor")
            date_Picker.maximumDate = maxDate
            date_Picker.minimumDate = minDate
            date_Picker.date = selectedDate ?? Date()
            self.selectedDate = selectedDate ?? Date()
            self.datePickerView(view:topVC.view, height: height)
        }
    }
    
    private func datePickerView(view: UIView, height: Double? = nil) {
        view.addSubview(dimmedView)
        self.dimmedView.addSubview(viewContent)
        self.viewContent.addSubview(self.tool_Bar)
        self.viewContent.addSubview(self.date_Picker)
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewContent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewContent.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewContent.widthAnchor.constraint(equalTo: dimmedView.widthAnchor, multiplier: 0.9),
            tool_Bar.heightAnchor.constraint(equalToConstant: 50),
            tool_Bar.topAnchor.constraint(equalTo: viewContent.topAnchor),
            tool_Bar.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            tool_Bar.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            date_Picker.topAnchor.constraint(equalTo: self.tool_Bar.bottomAnchor, constant:0),
            date_Picker.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            date_Picker.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            date_Picker.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor,constant: 0)
        ])
        
        if height != nil {
            NSLayoutConstraint.activate([viewContent.heightAnchor.constraint(equalToConstant: height ?? 0.00)])
        } else {
                NSLayoutConstraint.activate([viewContent.heightAnchor.constraint(equalTo: dimmedView.heightAnchor, multiplier: 0.45)])
        }
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


