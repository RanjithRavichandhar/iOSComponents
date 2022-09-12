//
//  M2PSegmentedControl.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 06/09/22.
//

import Foundation
import UIKit

public class M2PSegmentedControl: UIControl {
    
    fileprivate var labels = [UILabel]()
    private var thumbView = UIView()
    private var thumbImageView = UIImageView()
    
    public var items: [String] = [""] {
        didSet {
            if items.count > 0 { setupLabels() }
        }
    }
    
    public var cornerRadius: CGFloat = 6.0 {
        didSet { setupView() }
    }
    
    public var borderWidth: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    public var selectedIndex: Int = 0 {
        didSet { displayNewSelectedIndex() }
    }
    
    public var backGroundColor: UIColor = UIColor.black {
        didSet { backgroundColor = backGroundColor }
    }
    
    public var selectedLabelColor: UIColor? {
        didSet { setSelectedColors() }
    }
    
    public var unselectedLabelColor: UIColor? {
        didSet { setSelectedColors() }
    }
    
    public var thumbColor: UIColor = UIColor.white {
        didSet { setSelectedColors() }
    }
    
    public var borderColor: UIColor = UIColor.white {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    public var font: UIFont? = UIFont.customFont(name: "Arial", size: .x10) {
        didSet { setFont() }
    }
    
    public var padding: CGFloat = 2.0 {
        didSet { setupLabels() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.borderWidth = borderWidth
        
//        backgroundColor = backGroundColor
        setupLabels()
        insertSubview(thumbView, at: 0)
        insertSubview(thumbImageView, at: 0)
    }
    
    private func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        for index in 1...items.count {
            let label = UILabel()
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = font
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            labels.append(label)
        }
        addIndividualItemConstraints(labels, mainView: self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if labels.count > 0 {
            let label = labels[selectedIndex]
            label.textColor = selectedLabelColor
            thumbView.frame = CGRect(x: label.frame.minX + 3.0, y: label.frame.minY + 3.0, width: label.frame.width - 6.0, height: label.frame.height - 6.0)
            thumbView.backgroundColor = thumbColor
            thumbView.layer.cornerRadius = cornerRadius
            //thumbImageView.image = UIImage(named: "payment-mode-glass-btn-bg")
            displayNewSelectedIndex()
        }
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    private func displayNewSelectedIndex() {
        for (_, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
        }
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, animations: {
            self.thumbView.frame = CGRect(x: label.frame.minX + 0.0, y: label.frame.minY + 0.0, width: label.frame.width - 0.0, height: label.frame.height - 0.0)
//            self.thumbView.frame = label.frame
            self.thumbImageView.frame = self.thumbView.frame
        }, completion: nil)
    }
    
    private func addIndividualItemConstraints(_ items: [UIView], mainView: UIView) {
        for (index, button) in items.enumerated() {
            button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: padding).isActive = true
            button.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -padding).isActive = true

            ///set leading constraint
            if index == 0 {
                /// set first item leading anchor to mainView
                button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: padding).isActive = true
            } else {
                let prevButton: UIView = items[index - 1]
                let firstItem: UIView = items[0]
                
                /// set remaining items to previous view and set width the same as first view
                button.leadingAnchor.constraint(equalTo: prevButton.trailingAnchor, constant: padding).isActive = true
                button.widthAnchor.constraint(equalTo: firstItem.widthAnchor).isActive = true
            }

            ///set trailing constraint
            if index == items.count - 1 {
                /// set last item trailing anchor to mainView
                button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -padding).isActive = true
            } else {
                /// set remaining item trailing anchor to next view
                let nextButton: UIView = items[index + 1]
                button.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -padding).isActive = true
            }
        }
    }
    
    private func setSelectedColors() {
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    private func setFont() {
        for item in labels {
            item.font = font
        }
    }
    
}

/// Code Implementation
/*
func configureSegment() {
    self.segmentControl.items = ["Select Currency", "Select Country", "Transactions", "Statement"]
    self.segmentControl.font = UIFont.customFont(name: "Arial-Regular", size: .x13)
    self.segmentControl.thumbColor = UIColor.background
    self.segmentControl.backGroundColor = UIColor.backgroundLightVarient
    self.segmentControl.selectedLabelColor = UIColor.primaryActive
    self.segmentControl.unselectedLabelColor = UIColor.secondaryInactive
    self.segmentControl.cornerRadius = 6.0
    self.segmentControl.selectedIndex = 0
    self.segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
}
*/
