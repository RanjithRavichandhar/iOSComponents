//
//  M2PList.swift
//  iOSComponents
//
//  Created by CHANDRU on 07/09/22.
//

import Foundation
import UIKit

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
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leadingSubLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trailingHeaderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trailingSubLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .right
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
        image.contentMode = .scaleAspectFill
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
    
    // MARK: Local Variables
    var leadingIconSize: CGFloat = 0
    public var onActionClick: ((_ sender: UIView) -> Void)?
    public var onSwitchChange: ((_ sender: UISwitch) -> Void)?
    
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
        leadingView.isHidden = true
        leadingView.addSubview(leadingImageView)
        contentStackView.addArrangedSubview(leadingView)
        contentStackView.addArrangedSubview(leadingStackView)
        contentStackView.addArrangedSubview(trailingStackView)
        addSubview(contentStackView)
        addSubview(bottomLineView)
        setDefaultConstraints()
    }

    private func setDefaultConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            leadingImageView.centerYAnchor.constraint(equalTo: self.leadingView.centerYAnchor),
            leadingImageView.leadingAnchor.constraint(equalTo: self.leadingView.leadingAnchor),
            leadingImageView.trailingAnchor.constraint(equalTo: self.leadingView.trailingAnchor, constant: -4),
            leadingImageView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.08),
            leadingImageView.heightAnchor.constraint(equalTo: self.leadingImageView.widthAnchor, multiplier: 1),
            bottomLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bottomLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            bottomLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            bottomLineView.heightAnchor.constraint(equalToConstant: 0.8)
        ])
        leadingIconSize = (self.frame.width - 32) * 0.08
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
            self.leadingStackView.addArrangedSubview(leadingHeaderLabel)
        }

        if let text = leadingContent?.subTextLabel?.text, !text.isEmpty {
            self.leadingSubLabel.text = text
            self.leadingSubLabel.textColor = leadingContent?.subTextLabel?.textColor
            self.leadingSubLabel.font = leadingContent?.subTextLabel?.textFont
            self.leadingStackView.addArrangedSubview(leadingSubLabel)
        }

        if let icon = leadingContent?.icon {
            self.leadingImageView.image = icon
            self.leadingView.isHidden = false
        }

        if leadingContent?.isAvatorIcon ?? false {
            self.leadingImageView.layer.cornerRadius = self.leadingIconSize/2
        }
        
        /* Trailing Content Setup */
        switch trailingContent?.contentType {
        case .texts:
            if let text = trailingContent?.headerTextLabel?.text, !text.isEmpty {
                self.trailingHeaderLabel.text = text
                self.trailingHeaderLabel.textColor = trailingContent?.headerTextLabel?.textColor
                self.trailingHeaderLabel.font = trailingContent?.headerTextLabel?.textFont
                self.trailingStackView.addArrangedSubview(trailingHeaderLabel)
            }

            if let text = trailingContent?.subTextLabel?.text, !text.isEmpty {
                self.trailingSubLabel.text = text
                self.trailingSubLabel.textColor = trailingContent?.subTextLabel?.textColor
                self.trailingSubLabel.font = trailingContent?.subTextLabel?.textFont
                self.trailingStackView.addArrangedSubview(trailingSubLabel)
            }
            
        case .icon:
            if let image = trailingContent?.icon {
                self.trailingImageView.image = image
                self.trailingView.addSubview(trailingImageView)
                self.trailingStackView.addArrangedSubview(trailingView)

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
                self.leadingStackView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.54).isActive = true
            }
            
        case .toggle:
            self.trailingView.addSubview(toggleSwitch)
            self.trailingStackView.addArrangedSubview(trailingView)
            setToggleSwitch(switchState: trailingContent?.isToggleEnable ?? .disable, withState: trailingContent?.isToggleOn ?? .off)
            
            NSLayoutConstraint.activate([
                toggleSwitch.centerYAnchor.constraint(equalTo: trailingView.centerYAnchor),
                toggleSwitch.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor, constant: -4),
                leadingStackView.widthAnchor.constraint(equalTo: self.contentStackView.widthAnchor, multiplier: 0.65)
            ])
        case .none:
            print("None type")
        }
    
    }
    
    // MARK: - Methods
    private func setToggleSwitch(switchState: SwitchState, withState: SwitchState.WithState) {
        self.toggleSwitch.setSwitchState(state: switchState, withState: withState)
        self.toggleSwitch.onClick { [weak self] sender in
            self?.onSwitchChange?(sender)
        }
    }
}
