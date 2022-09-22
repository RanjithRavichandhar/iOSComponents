//
//  M2PCustomPageControl.swift
//  iOSComponents
//
//  Created by Shiny on 02/09/22.
//

import UIKit

public class M2PCustomPageControl: UIPageControl {
    
    // MARK: Constants
    
    let indicatorSize = CGSize(width: 10, height: 10)
    
    // MARK: Variables
    
    var config: M2PPageControlConfig?
    var requiredPageControlSize : CGSize = CGSize(width: 50, height: 20) // Initial
    
    public override var numberOfPages: Int {
        didSet {
            self.requiredPageControlSize = self.size(forNumberOfPages: numberOfPages)
            self.frame = CGRect(x: frame.minX, y: frame.minY, width: requiredPageControlSize.width + 10, height: frame.height)
            // self.widthAnchor.constraint(equalToConstant: requiredPageControlSize.width + 10).isActive = true
            updateIndicators()
        }
    }
    
    public override var currentPage: Int {
        didSet {
            if self.currentPage < numberOfPages {
                updateIndicators()
            }
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup(for: self.numberOfPages)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if config?.alignment == .leftMost {
            alignIndicatorsLeftMost()
        }
    }
    
    // MARK: Public methods - Custom setup configurations
    
     public func setup(for pageCount : Int, with config: M2PPageControlConfig? = nil) {
        
        self.config = config ?? M2PPageControlConfig()
        self.numberOfPages = pageCount
        
        self.isUserInteractionEnabled = false
        
        if #available(iOS 14.0, *) {
            self.preferredIndicatorImage = self.config?.indicatorImage_inactive
            self.pageIndicatorTintColor = self.config?.indicatorColor_inactive
            self.currentPageIndicatorTintColor = self.config?.indicatorColor_active
        }
    }
    
    
    // MARK: Private methods
    
    private func alignIndicatorsLeftMost() {
        var indicators: [UIView] = []
        if #available(iOS 14.0, *) {
          let contentView = self.subviews.first
          let indicatorContentView = contentView?.subviews.first
          indicators = indicatorContentView?.subviews ?? []
          contentView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
          indicatorContentView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        } else {
          indicators = self.subviews
        }

        for (index, indicator) in indicators.enumerated()  {
            let xPositon = CGFloat(index) * (indicatorSize.width + 8)
            let yPosition : CGFloat = 0
            indicator.frame = CGRect(x: xPositon, y: yPosition, width: indicatorSize.width, height: indicatorSize.height)
        }
    }
    
    private func updateIndicators() {
        if #available(iOS 14.0, *) {
            if let active_image = config?.indicatorImage_active {
                (0..<numberOfPages).forEach { (index) in
                    let indicatorImage = index == currentPage ? active_image : config?.indicatorImage_inactive
                     self.setIndicatorImage(indicatorImage , forPage: index)
                }
            }
            
        } else {
            (0..<self.numberOfPages).forEach { (index) in
                let isSelectedIndex = index == self.currentPage
                self.backgroundColor = isSelectedIndex ? .secondaryRedColor : .secondaryInactive
                self.pageIndicatorTintColor = isSelectedIndex ? .secondaryRedColor : .secondaryInactive
            }
        }
    }
    
    private func getImage(for name : String) -> UIImage? {
        let image = UIImage(named: name, in: M2PComponentsBundle.shared.currentBundle, compatibleWith: nil)
        return image
    }
    
}
