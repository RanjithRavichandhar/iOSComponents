//
//  M2PTopNavigation.swift
//  iOSComponents-Resources
//
//  Created by SENTHIL KUMAR on 22/09/22.
//

// MARK: Implementation
/* topNavigation.M2PSetTopNavigation(contentType: .withSearchAndAdd, contentProperty: M2PContentProperty(backImage: UIImage(named: "backk"), searchImage: UIImage(named: "searchh"), addImage: UIImage(named: "pluss"), userProfileImage: UIImage(named: "profilee"), userProfileName: "vinoth", title: "Cart", backTitle: "Shop"))
 topNavigation.M2PSearchButton.isHidden = true
 topNavigation.M2PBackButton.isHidden = true
 topNavigation.M2PBackTitleLabel.isHidden = true
 topNavigation.M2POnClickProfile = {
     print("profile Tapped --->>>")
 }*/

import Foundation
import UIKit

public enum M2PTopNavigationType {
    case withProfile, withSearchAndAdd
}

public class M2PContentProperty {
    var backImage: UIImage? = nil
    var searchImage: UIImage? = nil
    var addImage: UIImage? = nil
    var title: String?
    var backTitle: String?
    var userProfileImage: UIImage? = nil
    var userProfileName: String?
    
    public init(backImage: UIImage? = nil, searchImage: UIImage? = nil, addImage: UIImage? = nil, userProfileImage: UIImage? = nil, userProfileName: String?, title: String?, backTitle: String?) {
        self.backImage = backImage
        self.searchImage = searchImage
        self.addImage = addImage
        self.userProfileImage = userProfileImage
        self.userProfileName = userProfileName
        self.title = title
        self.backTitle = backTitle
    }
}

public class M2PTopNavigation: UIView {
    
    var backImage = UIImage()
    var searchImage = UIImage()
    var addImage = UIImage()
    var ProfileImage = UIImage()
    
    // MARK: For Click Action
    public var M2POnClickBack:(() -> Void)?
    public var M2POnClickSearch:(() -> Void)?
    public var M2POnClickAdd:(() -> Void)?
    public var M2POnClickProfile:(() -> Void)?
    
    private var topNavigationType: M2PTopNavigationType = .withSearchAndAdd {
        didSet {
            self.M2PUserProfileView.isHidden = topNavigationType == .withSearchAndAdd ? true : false
            self.M2PContentStackView.isHidden = topNavigationType == .withSearchAndAdd ? false : true
        }
    }
    
    // MARK: Variables
    public lazy var M2PCenterTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .primaryActive
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public lazy var M2PBackTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryActive
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public lazy var M2PBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.isUserInteractionEnabled = true
        return button
    }()
    public lazy var M2PSearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.isUserInteractionEnabled = true
        return button
    }()
    public lazy var M2PAddButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    public lazy var M2PContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public lazy var M2PUserProfileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.layer.masksToBounds = false
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return image
    }()
    
    public lazy var M2PUserProfileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryActive
        label.text = "Label"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    public lazy var M2PUserProfileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
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
    
    // MARK: Initial Loads
    private func setUpView() {
        self.backgroundColor = .background
        self.M2PContentStackView.addArrangedSubview(self.M2PSearchButton)
        self.M2PContentStackView.addArrangedSubview(self.M2PAddButton)
        
        self.M2PUserProfileView.addSubview(M2PUserProfileLabel)
        self.M2PUserProfileView.addSubview(M2PUserProfileImage)
        
        self.addSubview(self.M2PBackButton)
        self.addSubview(self.M2PBackTitleLabel)
        self.addSubview(self.M2PCenterTitleLabel)
        self.addSubview(self.M2PContentStackView)
        self.addSubview(self.M2PUserProfileView)
        
        M2PBackTitleLabel.text = "Label"
        M2PCenterTitleLabel.text = "Title"
        let resourcesBundle = M2PComponentsBundle.shared.currentBundle
        let searchImage = UIImage(named: "search_Image.png", in: resourcesBundle, compatibleWith: nil)
        let backImage = UIImage(named: "back_Image.png", in: resourcesBundle, compatibleWith: nil)
        let addImage = UIImage(named: "Add_Image.png", in: resourcesBundle, compatibleWith: nil)
        
        let userProfileImage = UIImage(named: "sampleProfileImage.png", in: resourcesBundle, compatibleWith: nil)
        
        self.backImage = backImage ?? UIImage()
        self.searchImage = searchImage ?? UIImage()
        self.addImage = addImage ?? UIImage()
        self.ProfileImage = userProfileImage ?? UIImage()
        
        self.M2PSearchButton.setImage(searchImage, for: .normal)
        self.M2PBackButton.setImage(backImage, for: .normal)
        self.M2PAddButton.setImage(addImage, for: .normal)
        self.M2PUserProfileImage.image = userProfileImage
        
        self.M2PUserProfileImage.layer.cornerRadius = self.M2PUserProfileImage.frame.height/2
        setConstraints()
        self.topNavigationType = .withSearchAndAdd
        
        self.M2PBackButton.tag = 1
        self.M2PSearchButton.tag = 2
        self.M2PAddButton.tag = 3
        
        self.M2PSearchButton.addTarget(self, action: #selector(self.commonButtonAction(_:)), for: .touchUpInside)
        self.M2PBackButton.addTarget(self, action: #selector(self.commonButtonAction(_:)), for: .touchUpInside)
        self.M2PAddButton.addTarget(self, action: #selector(self.commonButtonAction(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapImageAction(_:)))
        self.M2PUserProfileView.addGestureRecognizer(tap)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.M2PBackButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.M2PBackButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            self.M2PBackTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.M2PBackTitleLabel.leadingAnchor.constraint(equalTo: self.M2PBackButton.trailingAnchor, constant: 3),
            self.M2PBackTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.M2PCenterTitleLabel.leadingAnchor, constant: -5),
            
            self.M2PCenterTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.M2PCenterTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.M2PCenterTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.M2PContentStackView.leadingAnchor, constant: -5),
            self.M2PCenterTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.M2PUserProfileView.leadingAnchor, constant: -5),
            
            self.M2PContentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.M2PContentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            self.M2PUserProfileView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.M2PUserProfileView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            self.M2PUserProfileView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            
            self.M2PUserProfileLabel.centerYAnchor.constraint(equalTo: self.M2PUserProfileView.centerYAnchor),
            self.M2PUserProfileLabel.leadingAnchor.constraint(equalTo: self.M2PUserProfileView.leadingAnchor, constant: 1),
            
            self.M2PUserProfileImage.centerYAnchor.constraint(equalTo: self.M2PUserProfileView.centerYAnchor),
            self.M2PUserProfileImage.leadingAnchor.constraint(equalTo: self.M2PUserProfileLabel.trailingAnchor, constant: 5),
            self.M2PUserProfileImage.trailingAnchor.constraint(equalTo: self.M2PUserProfileView.trailingAnchor, constant: -1),
            
        ])
    }
    
    @objc func commonButtonAction(_ sender: UIButton) {
        if sender.tag == 2 {
            M2POnClickSearch?()
        } else if sender.tag == 3 {
            M2POnClickAdd?()
        } else {
            M2POnClickBack?()
        }
    }
    @objc public func tapImageAction(_ sender: UITapGestureRecognizer) {
        M2POnClickProfile?()
    }
    
    public func M2PSetTopNavigation(contentType: M2PTopNavigationType, contentProperty: M2PContentProperty?) {
        
        self.topNavigationType = contentType
        
        M2PBackTitleLabel.text = contentProperty?.backTitle ?? ""
        M2PCenterTitleLabel.text = contentProperty?.title ?? ""
        M2PUserProfileLabel.text = contentProperty?.userProfileName ?? ""
        
        self.backImage = contentProperty?.backImage != nil ? contentProperty?.backImage ?? UIImage() : self.backImage
        self.searchImage = contentProperty?.searchImage != nil ? contentProperty?.searchImage ?? UIImage() : self.searchImage
        self.addImage = contentProperty?.addImage != nil ? contentProperty?.addImage ?? UIImage() : self.addImage
        self.ProfileImage = contentProperty?.userProfileImage != nil ? contentProperty?.userProfileImage ?? UIImage() : self.ProfileImage
        
        self.M2PSearchButton.setImage(self.searchImage, for: .normal)
        self.M2PBackButton.setImage(self.backImage, for: .normal)
        self.M2PAddButton.setImage(self.addImage, for: .normal)
        self.M2PUserProfileImage.image = self.ProfileImage
        
        
    }
}
