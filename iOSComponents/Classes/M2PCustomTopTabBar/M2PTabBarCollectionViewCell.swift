//
//  M2PTabBarCollectionViewCell.swift
//  iOSComponents
//
//  Created by Shiny on 09/09/22.
//

import UIKit

class M2PTabBarCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    // MARK: Constants
    
    let bottomLine: UIView = {
        let line = UIView()
        return line
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.baselineAdjustment = .none
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let leftView = UIView()
    let rightView = UIView()
    
    // MARK: Variables
    
    var leftImageView = UIImageView()
    var rightImageView = UIImageView()
    
    var colorConfig: M2PTabBarColorConfig = M2PTabBarColorConfig()
    var spacingConfig: M2PTabBarItemConfig = M2PTabBarItemConfig()
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? colorConfig.selectedBackground : colorConfig.unselectedBackground
            bottomLine.backgroundColor = isHighlighted ? colorConfig.indicatorLine_selected : colorConfig.indicatorLine_Unselected
        }
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? colorConfig.selectedBackground : colorConfig.unselectedBackground
            bottomLine.backgroundColor = isSelected ? colorConfig.indicatorLine_selected : colorConfig.indicatorLine_Unselected
        }
    }
    
    // MARK: Initial Setups
    
    private func setupView() {
        // Default config setup
        self.backgroundColor = colorConfig.unselectedBackground
        self.titleLabel.textColor = colorConfig.titleColor
        self.bottomLine.backgroundColor = colorConfig.indicatorLine_Unselected
        self.titleLabel.font = spacingConfig.titleFont
    
        //StackView content & setup
        setupStackView()
        
        // Bottom line (Selected / unselect state indicator)
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 2, width: self.frame.width, height: 2.0)
        self.addSubview(bottomLine)
    }
    
    // Left Image
    private func setupLeftView() {
        leftImageView = getImageView()
        leftView.addSubview(leftImageView)
        setLeftImageConstraints()
    }
    
    // Right Image
    private func setupRightView() {
        rightImageView = getImageView()
        rightView.addSubview(rightImageView)
        setRightImageConstraints()
    }
    
    private func getImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.tintColor = colorConfig.imageTintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func setupStackView() {
        self.addSubview(contentStackView)
        setStackViewContraints()
        setupLeftView()
        setupRightView()
        contentStackView.addArrangedSubview(leftView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(rightView)
    }
    
    // MARK: Constraints
    
    private func setStackViewContraints() {
        contentStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  -20).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setLeftImageConstraints() {
        leftImageView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        leftImageView.leadingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        leftImageView.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
    }
    
    private func setRightImageConstraints() {
        rightImageView.centerYAnchor.constraint(equalTo: rightView.centerYAnchor).isActive = true
        rightImageView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        rightImageView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
    }
    
    private func setCustomizableSpacingConstraints(spacingConfig : M2PTabBarItemConfig) {
        //StackView
        contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacingConfig.itemLeftPadding).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  -spacingConfig.itemRightPadding).isActive = true
        
        //Right Image & Left Image
        rightImageView.widthAnchor.constraint(equalToConstant: spacingConfig.imageWidth).isActive = true
        rightImageView.heightAnchor.constraint(equalToConstant: spacingConfig.imageHeight).isActive = true
        leftImageView.widthAnchor.constraint(equalToConstant: spacingConfig.imageWidth).isActive = true
        leftImageView.heightAnchor.constraint(equalToConstant: spacingConfig.imageHeight).isActive = true
    }
    
    // MARK: Custom Colors
    
    private func setCustomColorsForTabItem(with colorConfig: M2PTabBarColorConfig) {
        self.colorConfig = colorConfig
        
        self.backgroundColor = isHighlighted || isSelected ? colorConfig.selectedBackground : colorConfig.unselectedBackground
        bottomLine.backgroundColor = isHighlighted || isSelected ? colorConfig.indicatorLine_selected : colorConfig.indicatorLine_Unselected
        titleLabel.textColor = colorConfig.titleColor
        rightImageView.tintColor = colorConfig.imageTintColor
        leftImageView.tintColor = colorConfig.imageTintColor
    }
    
    
    
    // MARK: Update Cell data & setup
    
    func updateData(with tabItemdata: M2PTopTabBarItem) {
        // Set custom spacing & constraints
        contentStackView.spacing = spacingConfig.interElementSpacing
        titleLabel.font = spacingConfig.titleFont
        setCustomizableSpacingConstraints(spacingConfig: spacingConfig)
        
        // Set Custom colors
        setCustomColorsForTabItem(with: colorConfig)
        
        // Data Updation
        titleLabel.text = tabItemdata.title
        leftImageView.image = tabItemdata.leftImage
        rightImageView.image = tabItemdata.rightImage
        leftView.isHidden = tabItemdata.leftImage == nil
        rightView.isHidden = tabItemdata.rightImage == nil
    }
    
}
