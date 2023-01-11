//
//  M2PCustomButton.swift
//  iOSComponents
//
//  Created by Balaji  on 06/09/22.
//

import Foundation
import UIKit

private class M2PCustomButton: UIButton {

    class var shared: M2PCustomButton {
        struct Singleton {
            static let instance = M2PCustomButton()
        }
        return Singleton.instance
    }

    var config : M2PColorConfig = M2PColorConfig() {
        didSet {
            self.setupView()
        }
    }

    private var buttonStyle: ButtonStyle? = .NOICON {
        didSet{
            setupView()
        }
    }

    private var cornerRadius: CGFloat = 10{
        didSet{
            setupView()
        }
    }

    private var bgImage: UIImage? = nil{
        didSet{
            setupView()
        }
    }

    private var isPrimary: Bool = false {
        didSet{
            setupView()
        }
    }

    private var leftImage: UIImage? = nil {
        didSet{
            setupImage()
        }
    }

    private var leftImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    private var leftImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    private var rightImage: UIImage? = nil {
        didSet{
            setupImage()
        }
    }

    private var rightImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    private var rightImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }

    private var leftIconTint: UIColor? = UIColor.lightGray {
        didSet{
            setupView()
        }
    }

    private var rightIconTint: UIColor? = UIColor.lightGray {
        didSet{
            setupView()
        }
    }

    private var type: ButtonTypes? = .Primary {
        didSet{
            setupView()
        }
    }

    private var status: ButtonStatus? = .ENABLE {
        didSet{
            setupView()
        }
    }

    private var leftImageView = UIImageView()
    private var rightImageView = UIImageView()

    public var onClick: ((_ : UIButton) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }

    private func setupView() {
        layer.masksToBounds = false
        self.setupButtonType()
        self.addTarget(self, action: #selector(actn(_:)), for: [.touchUpInside])
    }

    @objc fileprivate func actn(_ sender: UIButton) {
        onClick?(_ :sender)
    }

    fileprivate func setupImage() {

        switch buttonStyle {
        case .ONLYICON:
            self.setBackgroundImage(bgImage, for: .normal)
        case .LEFT_SIDE_ICON:
            self.addLeftIcon()
        case .RIGHT_SIDE_ICON:
            self.addRightIcon()
        case .DOUBLE_SIDE_ICON:
            self.addDoubleIcon()
        default:
            break
        }
    }

    public func M2PColorSetConfig(_ config: M2PColorConfig) {
        self.config = config
    }

    public func M2PCustomButtonConfig(type: ButtonType ,
                                title: String,
                                cornerRadius: CGFloat? = 10,
                                buttonStyle:ButtonStyle? = .NOICON,
                                isPrimary:Bool? = true,
                                leftImg:UIImage? = nil,
                                rightImg:UIImage? = nil,
                                leftIconWidth:CGFloat? = 10,
                                leftIconHeight:CGFloat? = 10,
                                rightIconWidth:CGFloat? = 10,
                                rightIconHeight:CGFloat? = 10,
                                state: ButtonStatus? = .ENABLE,
                                leftIconTint: UIColor? = .lightGray,
                                rightIconTint: UIColor? = .lightGray
    ){
        self.cornerRadius = cornerRadius ?? 10
        self.isPrimary = isPrimary ?? true
        self.buttonStyle = buttonStyle
        self.setTitle(title, for: .normal)
        self.leftImageWidth = leftIconWidth ?? 20
        self.leftImageHeight = leftIconHeight ?? 20
        self.rightImageWidth = rightIconWidth ?? 20
        self.rightImageHeight = rightIconHeight ?? 20
        self.status = state
        self.leftIconTint = leftIconTint
        self.rightIconTint = rightIconTint
        self.leftImage = leftImg
        self.rightImage = rightImg
    }

    private func setupButtonType() {
        if isPrimary{
            self.isEnabled = status == .ENABLE ? true : false
            self.backgroundColor = (status == .ENABLE ? self.config.bgColorEnable : self.config.bgColorDisable)
            self.setTitleColor(status == .ENABLE ? self.config.titleColorEnable : self.config.titleColorDisable , for: .normal)
            self.layer.borderColor = UIColor.clear.cgColor
            self.tintColor = (status == .ENABLE) ? self.config.tintColorEnable : self.config.tintColorDisable
        }else{
            self.isEnabled = status == .ENABLE ? true : false
            self.backgroundColor = (status == .ENABLE ? self.config.bgColorEnable : self.config.bgColorDisable)
            self.setTitleColor(status == .ENABLE ? self.config.titleColorEnable : self.config.titleColorDisable , for: .normal)
            self.layer.borderWidth = 1
            self.layer.borderColor = (status == .ENABLE ? self.config.borderColorEnable.cgColor : self.config.borderColorDisable.cgColor)
            self.tintColor = (status == .ENABLE) ? self.config.tintColorEnable : self.config.tintColorDisable
        }
    }

    public override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }

    private func addDoubleIcon() {
        self.addLeftIcon()
        self.addRightIcon()
    }
    private func addLeftIcon() {
        if let leftImageView = leftImage {
            self.leftImageView.image = leftImageView
            self.leftImageView.tintColor = leftIconTint
            self.leftImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(self.leftImageView)

            NSLayoutConstraint.activate([
                self.leftImageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -20),
                self.leftImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                self.leftImageView.widthAnchor.constraint(equalToConstant: leftImageWidth ),
                self.leftImageView.heightAnchor.constraint(equalToConstant: leftImageWidth )
            ])
        }
    }

    private func addRightIcon() {
        if let rightImageView = rightImage {
            self.rightImageView.image = rightImageView
            self.rightImageView.tintColor = rightIconTint
            self.rightImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview( self.rightImageView)

            NSLayoutConstraint.activate([
                self.rightImageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 20),
                self.rightImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                self.rightImageView.widthAnchor.constraint(equalToConstant: rightImageWidth ),
                self.rightImageView.heightAnchor.constraint(equalToConstant: rightImageWidth )
            ])
        }
    }

    // MARK: - Color config
    public struct M2PColorConfig {

        /// Color of bg enable
        public var bgColorEnable = UIColor.primaryActive

        /// Color of bg disable
        public var bgColorDisable = UIColor.DavysGrey66

        /// Color of title enable
        public var titleColorEnable = UIColor.background

        /// Color of title disable
        public var titleColorDisable = UIColor.DavysGrey100

        /// Color of tint enable
        public var tintColorEnable = UIColor.background

        /// Color of tint disable
        public var tintColorDisable = UIColor.DavysGrey100

        /// Color of border enable
        public var borderColorEnable = UIColor.primaryActive

        /// Color of border disable
        public var borderColorDisable = UIColor.secondaryInactive

        public init() {}

    }
}


/*
 // Code implementation
 // MARK: - CUSTOM Button
private func setupButton(){

    self.M2PCustomButton.M2PCustomButtonConfig(type: .custom, title: "IndusLogo",
                                   cornerRadius: 5,
                                   buttonStyle: .DOUBLE_SIDE_ICON, //  NOICON, ONLYICON, LEFT_SIDE_ICON, RIGHT_SIDE_ICON, DOUBLE_SIDE_ICON
                                   isPrimary: true,
                                   leftImg: UIImage(named:"plus.png"),
                                   rightImg: UIImage(named:"plus.png"),
                                   leftIconWidth: 20,
                                   leftIconHeight: 20,
                                   rightIconWidth: 20,
                                   rightIconHeight: 20,
                                   state: .ENABLE,// ENABLE / DISABLE
                                   leftIconTint:.blue,
                                   rightIconTint: .orange)
    self.M2PCustomButton.onClick = { sender in
        // do
    }

    var config : M2PCustomButton.M2PColorConfig = M2PCustomButton.M2PColorConfig()
    config.bgColorEnable = UIColor.black
    config.titleColorEnable = UIColor.white
    self.M2PCustomButton.M2PColorSetConfig(config)
}
*/