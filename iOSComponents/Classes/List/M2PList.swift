//
//  M2PList.swift
//  iOSComponents
//
//  Created by CHANDRU on 07/09/22.
//

import Foundation
import UIKit

/* MARK: Implementation
 
 var listView: M2PList?
 
 let primaryContent = LeadingContentList(headerTextLabel: ContentTextModel(text: "Header", textColor: .red, textFont: .systemFont(ofSize: 17)), subTextLabel: ContentTextModel(text: "sub", textColor: .lightGray, textFont: .systemFont(ofSize: 13)), icon: ContentImageModel(image: UIImage(named: "side_icon")?.withRenderingMode(.alwaysTemplate), tintColor: .primaryActive))
 let secondaryContent = TrailingContentList(contentType: .texts, headerTextLabel: ContentTextModel(text: "Header", textColor: .primaryActive, textFont: .systemFont(ofSize: 17)), subTextLabel: ContentTextModel(text: "sub", textColor: .DavysGrey66, textFont: .systemFont(ofSize: 13)), actionTitleLabel: ContentTextModel(text: "Change", textColor: .blue, textFont: .systemFont(ofSize: 15)), icon:  ContentImageModel(image: UIImage(named: "pencil")))
 
 listView?.setupList(leadingContent: primaryContent, trailingContent: secondaryContent, isbottomLineView: true)
 listView?.onActionClick = { sender in
     print("\(sender.tag)")
 }
 
 */

// MARK: - M2PList
public class M2PList: UIView {
    
    // MARK: StackViews
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var leadingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var trailingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: UILabels
    private lazy var leadingHeaderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leadingSubLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trailingHeaderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trailingSubLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK:  UIButton
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(onActionButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: UISwitch
    public lazy var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    // MARK: Images
    private lazy var leadingImageView : UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var trailingImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onActionButton(_:))))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: UIVIEW
    private lazy var leadingView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var trailingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightVarient
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var radioButtonView: M2PRadioButton = {
        let radioButton = M2PRadioButton()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()
    
    public lazy var checkBoxView: M2PCheckBox = {
        let radioButton = M2PCheckBox()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()
    
    // MARK: Local Variables
    var leadingIconSize: CGFloat = 0
    var leadingImgMultiplier: CGFloat = 0.072
    public var onActionClick: ((_ sender: UIView) -> Void)?

    // MARK: - View LifeCycles
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    private func setUpView() {
        leadingStackView.isHidden = true
        trailingStackView.isHidden = true
        leadingView.isHidden = true
        leadingView.addSubview(leadingImageView)
        contentStackView.addArrangedSubview(leadingView)
        contentStackView.addArrangedSubview(leadingStackView)
        contentStackView.addArrangedSubview(trailingStackView)
        addSubview(contentStackView)
        addSubview(bottomLineView)
        setDefaultConstraints()
        
        // Inital Value Setup
        setupList(leadingContent: LeadingContentList(headerTextLabel: ContentTextModel(text: "M2PList", textColor: .primaryActive, textAlignment: .center), subTextLabel: nil, icon: nil), trailingContent: nil)
    }

    private func setDefaultConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            leadingImageView.centerYAnchor.constraint(equalTo: self.leadingView.centerYAnchor),
            leadingImageView.leadingAnchor.constraint(equalTo: self.leadingView.leadingAnchor),
            leadingImageView.trailingAnchor.constraint(equalTo: self.leadingView.trailingAnchor, constant: -4),
            leadingImageView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: leadingImgMultiplier),
            leadingImageView.heightAnchor.constraint(equalTo: self.leadingImageView.widthAnchor, multiplier: 1),
            bottomLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bottomLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            bottomLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            bottomLineView.heightAnchor.constraint(equalToConstant: 0.8)
        ])
        leadingIconSize = (self.frame.width - 32) * leadingImgMultiplier
    }
    
    // MARK: - Actions
    @objc private func onActionButton(_ sender: Any) {
        self.onActionClick?(self)
    }
    
    // MARK: - Setup ListView
    public func setupList(leadingContent: LeadingContentList?, trailingContent: TrailingContentList?, isbottomLineView: Bool = false) {
        
        self.bottomLineView.isHidden = !isbottomLineView
        
        /* Leading Content Setup */
        if let text = leadingContent?.headerTextLabel?.text, !text.isEmpty {
            self.leadingHeaderLabel.text = text
            self.leadingHeaderLabel.textColor = leadingContent?.headerTextLabel?.textColor
            self.leadingHeaderLabel.font = leadingContent?.headerTextLabel?.textFont
            self.leadingHeaderLabel.textAlignment = leadingContent?.headerTextLabel?.textAlignment ?? .left
            self.leadingStackView.addArrangedSubview(leadingHeaderLabel)
            self.leadingStackView.isHidden = false
        }

        if let text = leadingContent?.subTextLabel?.text, !text.isEmpty {
            self.leadingSubLabel.text = text
            self.leadingSubLabel.textColor = leadingContent?.subTextLabel?.textColor
            self.leadingSubLabel.font = leadingContent?.subTextLabel?.textFont
            self.leadingSubLabel.textAlignment = leadingContent?.subTextLabel?.textAlignment ?? .left
            self.leadingStackView.addArrangedSubview(leadingSubLabel)
            self.leadingStackView.isHidden = false
        }

        if let icon = leadingContent?.icon?.image {
            self.leadingImageView.image = icon
            self.leadingImageView.contentMode = .scaleAspectFit
            self.leadingImageView.tintColor = leadingContent?.icon?.tintColor
            self.leadingView.isHidden = false
        }

        if leadingContent?.isAvatorIcon ?? false {
            self.leadingImageView.contentMode = .scaleAspectFill
            self.leadingImageView.layer.cornerRadius = self.leadingIconSize/2
        }
        
        /* Trailing Content Setup */
        switch trailingContent?.contentType {
        case .texts:
            if let text = trailingContent?.headerTextLabel?.text, !text.isEmpty {
                self.trailingHeaderLabel.text = text
                self.trailingHeaderLabel.textColor = trailingContent?.headerTextLabel?.textColor
                self.trailingHeaderLabel.font = trailingContent?.headerTextLabel?.textFont
                self.trailingHeaderLabel.textAlignment = trailingContent?.headerTextLabel?.textAlignment ?? .right
                self.trailingStackView.addArrangedSubview(trailingHeaderLabel)
                self.trailingStackView.isHidden = false
            }

            if let text = trailingContent?.subTextLabel?.text, !text.isEmpty {
                self.trailingSubLabel.text = text
                self.trailingSubLabel.textColor = trailingContent?.subTextLabel?.textColor
                self.trailingSubLabel.font = trailingContent?.subTextLabel?.textFont
                self.trailingSubLabel.textAlignment = trailingContent?.subTextLabel?.textAlignment ?? .right
                self.trailingStackView.addArrangedSubview(trailingSubLabel)
                self.trailingStackView.isHidden = false
            }
            
        case .icon:
            if let image = trailingContent?.icon?.image {
                self.trailingImageView.image = image
                self.trailingImageView.tintColor = trailingContent?.icon?.tintColor
                self.trailingView.addSubview(trailingImageView)
                self.trailingStackView.addArrangedSubview(trailingView)
                self.trailingStackView.isHidden = false

                NSLayoutConstraint.activate([
                    leadingStackView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.65),
                    trailingImageView.centerYAnchor.constraint(equalTo: trailingView.centerYAnchor),
                    trailingImageView.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor, constant: 0),
                    trailingImageView.widthAnchor.constraint(equalToConstant: 20),
                    trailingImageView.heightAnchor.constraint(equalToConstant: 20)
                ])
            }
            
        case .button:
            if let title = trailingContent?.actionTitleLabel?.text {
                self.actionButton.setTitle(title, for: .normal)
                self.actionButton.setTitleColor(trailingContent?.actionTitleLabel?.textColor, for: .normal)
                self.actionButton.titleLabel?.font = trailingContent?.actionTitleLabel?.textFont
                self.trailingStackView.addArrangedSubview(actionButton)
                self.trailingStackView.isHidden = false
                self.leadingStackView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.54).isActive = true
            }
            
        case .toggle:
            self.trailingView.addSubview(toggleSwitch)
            self.trailingStackView.addArrangedSubview(trailingView)
            self.trailingStackView.isHidden = false
            
            NSLayoutConstraint.activate([
                toggleSwitch.centerYAnchor.constraint(equalTo: trailingView.centerYAnchor),
                toggleSwitch.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor, constant: -4),
                leadingStackView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.65)
            ])
            
        case .radio:
            self.trailingView.addSubview(radioButtonView)
            self.trailingStackView.addArrangedSubview(trailingView)
            self.trailingStackView.isHidden = false
            
            NSLayoutConstraint.activate([
                radioButtonView.centerYAnchor.constraint(equalTo: trailingView.centerYAnchor),
                radioButtonView.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor, constant: 0),
                leadingStackView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.7),
                radioButtonView.widthAnchor.constraint(equalToConstant: 24),
                radioButtonView.heightAnchor.constraint(equalToConstant: 24)
            ])
            
        case .checkBox:
            self.trailingView.addSubview(checkBoxView)
            self.trailingStackView.addArrangedSubview(trailingView)
            self.trailingStackView.isHidden = false
            
            NSLayoutConstraint.activate([
                checkBoxView.centerYAnchor.constraint(equalTo: trailingView.centerYAnchor),
                checkBoxView.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor, constant: 0),
                leadingStackView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.7),
                checkBoxView.widthAnchor.constraint(equalToConstant: 24),
                checkBoxView.heightAnchor.constraint(equalToConstant: 24)
            ])
        case .none:
            print("None type")
        }
    }
}
