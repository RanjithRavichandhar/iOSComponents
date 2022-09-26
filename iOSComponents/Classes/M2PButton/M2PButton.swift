//
//  M2PButton.swift
//  iOSComponents
//
//  Created by Balaji  on 06/09/22.
//

import Foundation
import UIKit


public enum ButtonTypes {
    case Primary
    case Secondary
    
    var bool: Bool {
        switch self {
        case .Primary:
            return true
        default:
            return false
        }
    }
}

public enum ButtonStyle : String {
    case NOICON
    case ONLYICON
    case LEFT_SIDE_ICON
    case RIGHT_SIDE_ICON
    case DOUBLE_SIDE_ICON
}

public enum ButtonStatus {
    case ENABLE
    case DISABLE
    
    var bool: Bool {
        switch self {
        case .ENABLE:
            return true
        default:
            return false
        }
    }
}

public class M2PButton: UIButton {
    
    public var buttonStyle: ButtonStyle? = .NOICON {
        didSet{
            setupView()
        }
    }
    
    public var cornerRadius: CGFloat = 10{
        didSet{
            setupView()
        }
    }
    
    public var bgImage: UIImage? = nil{
        didSet{
            setupView()
        }
    }
    
    public var isPrimary: Bool = false {
        didSet{
            setupView()
        }
    }
    
    public var leftImage: UIImage? = nil {
        didSet{
            setupView()
        }
    }
    
    public var leftImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    public var leftImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    public var rightImage: UIImage? = nil {
        didSet{
            setupView()
        }
    }
    
    public var rightImageWidth: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    public var rightImageHeight: CGFloat = 20 {
        didSet{
            setupView()
        }
    }
    
    public var primaryBgColor: UIColor? = UIColor.black {
        didSet{
            setupView()
        }
    }
    
    public var lightBgColor: UIColor? = UIColor.white {
        didSet{
            setupView()
        }
    }
    
    public var primaryTitleColor: UIColor? = UIColor.white {
        didSet{
            setupView()
        }
    }
    
    public var lightTitleColor: UIColor? = UIColor.black {
        didSet{
            setupView()
        }
    }
    
    public var type: ButtonTypes? = .Primary {
        didSet{
            setupView()
        }
    }
    
    public var status: ButtonStatus? = .ENABLE {
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
        self.setupImage()
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
    
    public func config(type: ButtonType ,
                       title: String,
                       cornerRadius: CGFloat? = 10,
                       buttonStyle:ButtonStyle? = .NOICON,
                       isPrimary:Bool? = true,
                       bgColor:UIColor,
                       leftImg:UIImage? = nil,
                       rightImg:UIImage? = nil,
                       leftIconWidth:CGFloat? = 10,
                       leftIconHeight:CGFloat? = 10,
                       rightIconWidth:CGFloat? = 10,
                       rightIconHeight:CGFloat? = 10,
                       state: ButtonStatus? = .ENABLE
    ){
        self.cornerRadius = cornerRadius ?? 10
        self.isPrimary = isPrimary ?? true
        self.buttonStyle = buttonStyle
        self.backgroundColor = bgColor
        self.leftImage = leftImg
        self.rightImage = rightImg
        self.setTitle(title, for: .normal)
        self.leftImageWidth = leftIconWidth ?? 20
        self.leftImageHeight = leftIconHeight ?? 20
        self.rightImageWidth = rightIconWidth ?? 20
        self.rightImageHeight = rightIconHeight ?? 20
        self.status = state
    }
    
    fileprivate func setupButtonType() {
        print("Style=>\(self.isPrimary) ")
        if isPrimary{
            self.isEnabled = status == .ENABLE ? true : false
            self.backgroundColor = (status == .ENABLE ? UIColor.primaryActive : .DavysGrey66)
            self.setTitleColor(status == .ENABLE ? .background : .DavysGrey100 , for: .normal)
            self.layer.borderColor = UIColor.clear.cgColor
            self.tintColor = (status == .ENABLE) ? .background : .DavysGrey100
        }else{
            self.isEnabled = status == .ENABLE ? true : false
            self.backgroundColor = (status == .ENABLE ? UIColor.background : .background)
            self.setTitleColor(status == .ENABLE ? .primaryActive : .secondaryInactive, for: .normal)
            self.layer.borderWidth = 1
            self.layer.borderColor = (status == .ENABLE ? UIColor.primaryActive.cgColor : UIColor.secondaryInactive.cgColor)
            self.tintColor = (status == .ENABLE) ? .primaryActive : .secondaryInactive
        }
    }
    
    public override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    private func addDoubleIcon() {
        //Set left image
        
        if leftImageView.image == leftImage || rightImageView.image == rightImage {
            return
        }
        
        leftImageView = UIImageView(image: leftImage)
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftImageView)
        
        NSLayoutConstraint.activate([
            leftImageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -20),
            leftImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            leftImageView.widthAnchor.constraint(equalToConstant: leftImageWidth ),
            leftImageView.heightAnchor.constraint(equalToConstant: leftImageWidth )
        ])
        
        rightImageView = UIImageView(image: rightImage)
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightImageView)
        
        NSLayoutConstraint.activate([
            rightImageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 20),
            rightImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            rightImageView.widthAnchor.constraint(equalToConstant: rightImageWidth ),
            rightImageView.heightAnchor.constraint(equalToConstant: rightImageWidth )
        ])
        
    }
    
    private func addLeftIcon() {
        //Set left image
        if leftImageView.image == leftImage {
            return
        }
        
        leftImageView = UIImageView(image: leftImage)
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftImageView)
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: (leftImageWidth*2), bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            leftImageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: -20),
            leftImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            leftImageView.widthAnchor.constraint(equalToConstant: leftImageWidth),
            leftImageView.heightAnchor.constraint(equalToConstant: leftImageWidth)
        ])
    }
    
    private func addRightIcon() {
        
        if rightImageView.image == rightImage {
            return
        }
    
        rightImageView = UIImageView(image: rightImage)
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightImageView)
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:  (rightImageWidth*2))
        
        NSLayoutConstraint.activate([
            rightImageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 20),
            rightImageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            rightImageView.widthAnchor.constraint(equalToConstant: rightImageWidth),
            rightImageView.heightAnchor.constraint(equalToConstant: rightImageWidth)
        ])
    }
}
