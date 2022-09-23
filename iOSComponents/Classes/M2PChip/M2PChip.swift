//
//  M2PChip.swift
//  iOSComponents
//
//  Created by CHANDRU on 01/09/22.
//

import Foundation
import UIKit

/* MARK: Implementation
 
 var chipView: M2PChip?
 chipView?.setUpChip(chipType: .info, contentType: .doubleSideIcon, borderType: .solid, title: "Chip", titleFont: UIFont.customFont(name: "Arial-BoldMT", size: .x17), primaryIcon: UIImage(named: "pencil"), secondaryIcon: UIImage(named: "pencil"))
 */

// MARK: - M2PChip
public class M2PChip: UIView {
    
    // MARK: Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var primaryImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.bounds.size = CGSize(width: 18, height: 18)
        return image
    }()
    
    private lazy var secondaryImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.bounds.size = CGSize(width: 18, height: 18)
        return image
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - LifeCycles
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView() {
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.contentStackView)
        setConstraints()
        
        // Initial Value Setup
        setUpChip(chipType: .neutral, contentType: .text, borderType: .solid, title: "M2PChip")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3)
        ])
    }

    // MARK: - Set Chips
    public func setUpChip(chipType: ChipType, contentType: ChipContentType, borderType: ChipBorderType, title: String? = nil, titleFont: UIFont = .systemFont(ofSize: 12), primaryIcon: UIImage? = nil, secondaryIcon: UIImage? = nil) {
       
        let primaryImgIcon = primaryIcon?.withRenderingMode(.alwaysTemplate)
        let secondaryImgIcon = secondaryIcon?.withRenderingMode(.alwaysTemplate)
        primaryImageView.tintColor =  chipType.textColor
        secondaryImageView.tintColor = chipType.textColor
        titleLabel.textColor = chipType.textColor
        titleLabel.font = titleFont
        
        switch borderType {
        case .solid:
            self.layer.backgroundColor = chipType.backGroundColor.cgColor
        case .outline:
            self.layer.borderWidth = 1
            if #available(iOS 12.0, *) {
                self.layer.borderColor = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? chipType.textColor.cgColor : chipType.backGroundColor.cgColor
            } else {
                // Fallback on earlier versions
                self.layer.borderColor = chipType.textColor.cgColor
            }
        }
        
        switch contentType {
        case .icons:
            guard let primaryIcon = primaryImgIcon else {
                return
            }
            self.primaryImageView.image = primaryIcon
            self.contentStackView.addArrangedSubview(primaryImageView)
        case .text:
            guard let title = title else {
                return
            }
            self.titleLabel.text = title
            self.contentStackView.addArrangedSubview(titleLabel)
        case .textWithLeftIcon:
            if let primaryIcon = primaryImgIcon {
                self.primaryImageView.image = primaryIcon
                self.contentStackView.addArrangedSubview(primaryImageView)
            }
            if let title = title {
                self.titleLabel.text = title
                self.contentStackView.addArrangedSubview(titleLabel)
            }
        case .textWithRightIcon:
            if let title = title {
                self.titleLabel.text = title
                self.contentStackView.addArrangedSubview(titleLabel)
            }
            
            if let primaryIcon = primaryImgIcon {
                self.primaryImageView.image = primaryIcon
                self.contentStackView.addArrangedSubview(primaryImageView)
            }
        case .doubleSideIcon:
            if let primaryIcon = primaryImgIcon {
                self.primaryImageView.image = primaryIcon
                self.contentStackView.addArrangedSubview(primaryImageView)
            }
            
            if let title = title {
                self.titleLabel.text = title
                self.contentStackView.addArrangedSubview(titleLabel)
            }
            
            if let secondaryIcon = secondaryImgIcon {
                self.secondaryImageView.image = secondaryIcon
                self.contentStackView.addArrangedSubview(secondaryImageView)
            }
        }
    }
}
