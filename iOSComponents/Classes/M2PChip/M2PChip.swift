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
 chipView?.M2PSetUpChip(chipType: .info, contentType: .doubleSideIcon, borderType: .solid, textContent: M2PContentTextModel(text: "M2PChip", textColor: nil), primaryIcon: M2PContentImageModel(image: UIImage(named: "pencil"), tintColor: nil), secondaryIcon: M2PContentImageModel(image: UIImage(named: "pencil"), tintColor: nil), customBgColor: nil)
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
        M2PSetUpChip(chipType: .neutral, contentType: .text, borderType: .solid, textContent: M2PContentTextModel(text: "M2PChip", textColor: UIColor.black))
        
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
    public func M2PSetUpChip(chipType: M2PChipType, contentType: M2PChipContentType, borderType: M2PChipBorderType, textContent: M2PContentTextModel?, primaryIcon: M2PContentImageModel? = nil, secondaryIcon: M2PContentImageModel? = nil, customBgColor: UIColor? = nil) {
       
        let primaryImgIcon = primaryIcon?.image?.withRenderingMode(.alwaysTemplate)
        let secondaryImgIcon = secondaryIcon?.image?.withRenderingMode(.alwaysTemplate)
        primaryImageView.tintColor = (primaryIcon?.tintColor == nil) ? chipType.textColor : primaryIcon?.tintColor
        secondaryImageView.tintColor = (secondaryIcon?.tintColor == nil) ? chipType.textColor : secondaryIcon?.tintColor
        titleLabel.textColor = (textContent?.textColor == nil) ? chipType.textColor : textContent?.textColor
        titleLabel.font = textContent?.textFont
        
        switch borderType {
        case .solid:
            self.layer.backgroundColor = (customBgColor == nil) ? chipType.backGroundColor.cgColor : customBgColor?.cgColor
            
        case .outline:
            self.layer.borderWidth = 1
            if #available(iOS 12.0, *) {
                self.layer.borderColor =  (customBgColor == nil) ?  (UIScreen.main.traitCollection.userInterfaceStyle == .dark ? chipType.textColor.cgColor : chipType.backGroundColor.cgColor) : customBgColor?.cgColor
            } else {
                // Fallback on earlier versions
                self.layer.borderColor = (customBgColor == nil) ? chipType.textColor.cgColor : customBgColor?.cgColor
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
            guard let title = textContent?.text else {
                return
            }
            self.titleLabel.text = title
            self.contentStackView.addArrangedSubview(titleLabel)
        case .textWithLeftIcon:
            if let primaryIcon = primaryImgIcon {
                self.primaryImageView.image = primaryIcon
                self.contentStackView.addArrangedSubview(primaryImageView)
            }
            if let title = textContent?.text {
                self.titleLabel.text = title
                self.contentStackView.addArrangedSubview(titleLabel)
            }
        case .textWithRightIcon:
            if let title = textContent?.text {
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
            
            if let title = textContent?.text {
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
