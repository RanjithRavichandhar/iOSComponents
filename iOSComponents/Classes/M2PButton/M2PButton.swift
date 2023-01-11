//
//  M2PButton.swift
//  iOSComponents
//
//  Created by CHANDRU on 05/01/23.
//

// MARK: - M2PButton
public class M2PButton: UIButton {
    private var configData: M2PButtonConfigModel?
    private var customButtonType: ButtonTypes = .none
    private var customButtonStyle: ButtonStyle = .text
    
    private var iconSize: CGFloat = 20
    private var primaryImageView = UIImageView()
    private var secondaryImageView = UIImageView()
    
    // MARK: Accessible Properites
    /* Button Enabled */
    public override var isEnabled: Bool {
        didSet {
            print("isEnabled set", isEnabled)
            if isEnabled {
                self.primaryImageView.tintColor = configData?.colorConfig.primaryIconActive
                self.secondaryImageView.tintColor = configData?.colorConfig.secondaryIconActive
                self.backgroundColor = configData?.colorConfig.backgroundActive
                self.setTitleColor(configData?.colorConfig.titleActive, for: .normal)
                if customButtonType == .secondary {
                    self.layer.borderColor = configData?.colorConfig.borderActive?.cgColor
                }
            } else {
                self.primaryImageView.tintColor = configData?.colorConfig.primaryIconInActive
                self.secondaryImageView.tintColor = configData?.colorConfig.secondaryIconInActive
                self.backgroundColor = configData?.colorConfig.backgroundInActive
                self.setTitleColor(configData?.colorConfig.titleInActive, for: .disabled)
                if customButtonType == .secondary {
                    self.layer.borderColor = configData?.colorConfig.borderInActive?.cgColor
                }
            }
        }
    }

    /* Button TitleFont Update */
    public var M2PSetContentTitleFont: UIFont? {
        didSet {
            self.configData?.titleFont = M2PSetContentTitleFont ?? .systemFont(ofSize: 14)
            self.titleLabel?.font = M2PSetContentTitleFont
        }
    }

    public var M2PButtonOnAction: ((_ sender: UIButton) -> Void)?
    
    // MARK: Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Methods
extension M2PButton {
    /* Setup View */
    private func setupView() {
        let colorConfig = M2PButtonColorConfigModel()
        colorConfig.titleActive = .systemBlue
        colorConfig.titleInActive = .systemBlue.withAlphaComponent(0.5)
        colorConfig.backgroundActive = .white
        colorConfig.backgroundInActive = .white.withAlphaComponent(0.5)
        
        let config = M2PButtonConfigModel(title: "M2PButton", primaryIcon: nil, secondaryIcon: nil, colorConfig: colorConfig)
        self.M2PSetupButton(config: config)
        self.addTarget(self, action: #selector(m2pButtonTapped(_:)), for: .touchUpInside)
    }
    
    /* M2PButton OnAction */
    @objc private func m2pButtonTapped(_ sender: UIButton) {
        M2PButtonOnAction?(sender)
    }
    
    // MARK: Setup M2PButton
    public func M2PSetupButton(type: ButtonTypes = .none, style: ButtonStyle = ButtonStyle.text, config: M2PButtonConfigModel) {
        configData = config
        customButtonType = type
        customButtonStyle = style
        iconSize = config.iconSize
        
        switch type {
        case .primary:
            self.layer.cornerRadius = 8
            setupButtonStyle(with: style)
        case .secondary:
            self.layer.cornerRadius = 8
            setupButtonStyle(with: style)
            setupSecondaryTypeBorder()
        case .none:
            self.layer.cornerRadius = 0
            setupButtonStyle(with: style)
        }
    }
    
    /* Setup Button with Style */
    private func setupButtonStyle(with style: ButtonStyle) {
        self.backgroundColor = configData?.colorConfig.backgroundActive
        if style == .icon {
            self.setImage(configData?.primaryIcon, for: .normal)
            self.tintColor = configData?.colorConfig.primaryIconActive
            self.setTitle("", for: .normal)
        } else {
            setupContentTitle()
            switch style {
            case .primaryIcon_text:
                addPrimaryImageIcon()
            case .secondaryIcon_text:
                addSecondaryImageIcon()
            case .icons_text:
                addDoubleIcon()
            default:
                print("")
            }
        }
    }

    /* Setup ButtonTitle */
    private func setupContentTitle() {
        self.setTitle(configData?.title, for: .normal)
        self.setTitleColor(configData?.colorConfig.titleActive, for: .normal)
        self.titleLabel?.font = configData?.titleFont
    }
    
    private func addDoubleIcon() {
        self.addPrimaryImageIcon()
        self.addSecondaryImageIcon()
    }
    
    /* Setup PrimaryIcon */
    private func addPrimaryImageIcon() {
        if let primaryImageView = self.configData?.primaryIcon {
            self.primaryImageView.image = primaryImageView
            self.primaryImageView.tintColor = self.configData?.colorConfig.primaryIconActive
            self.primaryImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(self.primaryImageView)
            
            NSLayoutConstraint.activate([
                self.primaryImageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -10),
                self.primaryImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                self.primaryImageView.widthAnchor.constraint(equalToConstant: iconSize),
                self.primaryImageView.heightAnchor.constraint(equalToConstant: iconSize)
            ])
        }
    }
    
    /* Setup SecondaryIcon */
    private func addSecondaryImageIcon() {
        if let secondaryImageView = self.configData?.secondaryIcon  {
            self.secondaryImageView.image = secondaryImageView
            self.secondaryImageView.tintColor = self.configData?.colorConfig.secondaryIconActive
            self.secondaryImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview( self.secondaryImageView)
            
            NSLayoutConstraint.activate([
                self.secondaryImageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 10),
                self.secondaryImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                self.secondaryImageView.widthAnchor.constraint(equalToConstant: iconSize),
                self.secondaryImageView.heightAnchor.constraint(equalToConstant: iconSize)
            ])
        }
    }
    
    /* Setup SecondaryType Border */
    private func setupSecondaryTypeBorder() {
        self.layer.borderColor = (configData?.colorConfig.borderActive ?? .clear).cgColor
        self.layer.borderWidth = 1.5
    }
    
    /* Icons Update */
    private func imageIconsUpdate(with view: UIImageView, value: UIImage?, isEnabled: Bool) {
        guard customButtonStyle != .text else {
            return
        }
        self.isEnabled = isEnabled
        if customButtonStyle == .icon {
            let state: UIControl.State = isEnabled ? .normal : .disabled
            self.setImage(value, for: state)
        } else {
            guard let value = value else {
                view.removeFromSuperview()
                return
            }
            view.image = value
        }
    }
}

// MARK: -  Accessible Public Methods
extension M2PButton {
    /* M2PButton TitleColor Update */
    public func M2PContentTitleColorUpdate(active: UIColor, inActive: UIColor) {
        self.configData?.colorConfig.titleActive = active
        self.configData?.colorConfig.titleInActive = inActive
        self.isEnabled = isEnabled
    }
    
    /* M2PButton BorderColor Update */
    public func M2PBorderColorUpdate(active: UIColor, inActive: UIColor) {
        self.configData?.colorConfig.borderActive = active
        self.configData?.colorConfig.borderInActive = inActive
        self.isEnabled = isEnabled
    }
    
    /* M2PButton BackgroundColor Update */
    public func M2PBackgroundColorUpdate(active: UIColor, inActive: UIColor) {
        self.configData?.colorConfig.backgroundActive = active
        self.configData?.colorConfig.backgroundInActive = inActive
        self.isEnabled = isEnabled
    }
    
    /* PrimaryIcon TintColor Update */
    public func M2PPrimaryIconTintColorUpdate(active: UIColor, inActive: UIColor) {
        self.configData?.colorConfig.primaryIconActive = active
        self.configData?.colorConfig.primaryIconInActive = inActive
        self.isEnabled = isEnabled
    }
    
    /* SecondaryIcon TintColor Update */
    public func M2PSecondaryIconTintColorUpdate(active: UIColor, inActive: UIColor) {
        self.configData?.colorConfig.secondaryIconActive = active
        self.configData?.colorConfig.secondaryIconInActive = inActive
        self.isEnabled = isEnabled
    }
    
    /* M2PButton Title Update */
    public func M2PButtonTitleUpdateWithState(value: String?, isEnabled: Bool = true) {
        guard customButtonStyle != .icon else {
            return
        }
        self.configData?.title = value
        self.isEnabled = isEnabled
        let state: UIControl.State = isEnabled ? .normal : .disabled
        self.setTitle(value, for: state)
    }
    
    /* PrimaryIcon Update */
    public func M2PPrimaryIconUpdateWithState(value: UIImage?, isEnabled: Bool = true) {
        self.configData?.primaryIcon = value
        self.imageIconsUpdate(with: self.primaryImageView, value: value, isEnabled: isEnabled)
    }
    
    /* SecondaryIcon Update */
    public func M2PSecondaryIconUpdateWithState(value: UIImage?, isEnabled: Bool = true) {
        self.configData?.secondaryIcon = value
        self.imageIconsUpdate(with: self.secondaryImageView, value: value, isEnabled: isEnabled)
    }
}

// MARK: - <UITraitEnvironment> delegate methods
extension M2PButton {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                self.isEnabled = isEnabled
            }
        }
    }
}
