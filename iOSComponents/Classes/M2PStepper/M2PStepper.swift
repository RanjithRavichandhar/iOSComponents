//
//  M2PStepper.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 12/09/22.
//

// MARK: Implementation

/* checkStepper.M2PSetUpStepper(stepperType: .withoutCount)
 
 checkStepperWithCount.M2PSetUpStepper(stepperType: .withCount, colorSet: M2PStepperColorSetup(stepperBGColor: .backgroundLightVarient, buttonBGColor: .clear, buttonTextColor: .secondaryInactive, selectButtonBGColor: .white, selectButtonTextColor: .secondaryRedColor, countLableBGColor: .background, countLableTextColor: .primaryActive))
 
 checkStepper.M2POnClick = { (isPluseTap, Count) in
     self.titleLbl.text = "\(Count)"
 } */
import Foundation
import UIKit

public enum M2PStepperType {
    case withCount, withoutCount
}

public class M2PStepperColorSetup {
    var stepperBGColor: UIColor = .backgroundLightVarient
    var buttonBGColor: UIColor = .clear
    var buttonTextColor: UIColor = .secondaryInactive
    var selectButtonBGColor: UIColor = .white
    var selectButtonTextColor: UIColor = .secondaryRedColor
    var countLableBGColor: UIColor = .borderDefault
    var countLableTextColor: UIColor = .primaryActive
    
    public init(stepperBGColor: UIColor, buttonBGColor: UIColor, buttonTextColor: UIColor, selectButtonBGColor: UIColor, selectButtonTextColor: UIColor, countLableBGColor: UIColor, countLableTextColor: UIColor) {
        self.stepperBGColor = stepperBGColor
        self.buttonBGColor = buttonBGColor
        self.buttonTextColor = buttonTextColor
        self.selectButtonBGColor = selectButtonBGColor
        self.selectButtonTextColor = selectButtonTextColor
        self.countLableBGColor = countLableBGColor
        self.countLableTextColor = countLableTextColor
        
    }
}

public class M2PStepper: UIView {
    
    var count = 0
    var withCount = false
    var stepperColorSetup: M2PStepperColorSetup?
    
    public var M2POnClick:((Bool, Int) -> Void)? // pluse(+) = true, Mynus(-) = false
    
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
        self.layer.cornerRadius = 10
        self.backgroundColor = .backgroundLightVarient
    }
    
    private lazy var mynusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("—", for: .normal)
        button.layer.cornerRadius = 10
        button.widthAnchor.constraint(equalToConstant: ((self.frame.width/2) - 0.5)).isActive = true
        button.setTitleColor(.secondaryInactive, for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("＋", for: .normal)
        button.layer.cornerRadius = 10
        button.widthAnchor.constraint(equalToConstant: ((self.frame.width/2) - 0.5)).isActive = true
        button.setTitleColor(.secondaryInactive, for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var DividerLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var DividerLineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .primaryActive
        label.backgroundColor = .borderDefault
        label.clipsToBounds = true
        label.heightAnchor.constraint(equalToConstant: (self.frame.height - 10)).isActive = true
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initial Loads
    private func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.contentStackView)
        DividerLineView.addSubview(self.DividerLineLabel)
        self.DividerLineLabel.centerXAnchor.constraint(equalTo: self.DividerLineView.centerXAnchor).isActive = true
        self.DividerLineLabel.centerYAnchor.constraint(equalTo: self.DividerLineView.centerYAnchor).isActive = true
        
        self.contentStackView.addArrangedSubview(mynusButton)
        self.contentStackView.addArrangedSubview(DividerLineView)
        self.contentStackView.addArrangedSubview(plusButton)
        setConstraints()
        
        self.mynusButton.tag = 0
        self.plusButton.tag = 1
        self.mynusButton.addTarget(self, action: #selector(self.plusMynusButtonAction(_:)), for: .touchUpInside)
        self.plusButton.addTarget(self, action: #selector(self.plusMynusButtonAction(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1),
            self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        ])
    }
    
    @objc func plusMynusButtonAction(_ sender: UIButton) {
  
        self.DividerLineView.isHidden = withCount == true ? false : true
        if sender.tag == 1 {
            if count != 99 {
                count += 1
            }
            self.DividerLineLabel.text = "\(count)"
            self.mynusButton.backgroundColor = self.stepperColorSetup?.buttonBGColor
            self.mynusButton.setTitleColor(self.stepperColorSetup?.buttonTextColor, for: .normal)
            self.plusButton.backgroundColor = withCount == false ? self.stepperColorSetup?.selectButtonBGColor : self.stepperColorSetup?.buttonBGColor
            self.plusButton.setTitleColor(self.stepperColorSetup?.selectButtonTextColor, for: .normal)
            M2POnClick?(true, count)
        } else {
            if count != 0 {
                count -= 1
            }
            self.DividerLineLabel.text = "\(count)"
            self.mynusButton.backgroundColor = withCount == false ? self.stepperColorSetup?.selectButtonBGColor : self.stepperColorSetup?.buttonBGColor
            self.mynusButton.setTitleColor(self.stepperColorSetup?.selectButtonTextColor, for: .normal)
            self.plusButton.backgroundColor = self.stepperColorSetup?.buttonBGColor
            self.plusButton.setTitleColor(self.stepperColorSetup?.buttonTextColor, for: .normal)
            M2POnClick?(false, count)
        }
        
    }
    
    public func M2PSetUpStepper(stepperType: M2PStepperType, colorSet: M2PStepperColorSetup = M2PStepperColorSetup(stepperBGColor: .backgroundLightVarient, buttonBGColor: .clear, buttonTextColor: .secondaryInactive, selectButtonBGColor: .white, selectButtonTextColor: .secondaryRedColor, countLableBGColor: .borderDefault, countLableTextColor: .primaryActive)) {
        
        withCount = stepperType == .withCount ? true : false
        self.stepperColorSetup = colorSet
        if withCount {
            self.DividerLineLabel.layer.cornerRadius = 5
            self.DividerLineLabel.text = "0"
            NSLayoutConstraint.activate([mynusButton.widthAnchor.constraint(equalToConstant: ((self.frame.width/2) - 12)),
                                         plusButton.widthAnchor.constraint(equalToConstant: ((self.frame.width/2) - 12)),
                                         self.DividerLineView.widthAnchor.constraint(equalToConstant: 25),
                                         self.DividerLineLabel.widthAnchor.constraint(equalToConstant: 25)
                                        ])
            
            self.backgroundColor = colorSet.stepperBGColor
            self.mynusButton.backgroundColor = colorSet.buttonBGColor
            self.plusButton.backgroundColor = colorSet.buttonBGColor
            self.mynusButton.setTitleColor(colorSet.buttonTextColor, for: .normal)
            self.plusButton.setTitleColor(colorSet.buttonTextColor, for: .normal)
            DividerLineLabel.textColor = colorSet.countLableTextColor
            DividerLineLabel.backgroundColor = colorSet.countLableBGColor
        } else {
            DividerLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            DividerLineLabel.widthAnchor.constraint(equalToConstant: 1).isActive = true

            self.backgroundColor = colorSet.stepperBGColor
            self.mynusButton.setTitleColor(colorSet.buttonTextColor, for: .normal)
            self.plusButton.setTitleColor(colorSet.buttonTextColor, for: .normal)
            DividerLineLabel.textColor = colorSet.countLableTextColor
            DividerLineLabel.backgroundColor = colorSet.countLableBGColor
        }
        
    }
}
