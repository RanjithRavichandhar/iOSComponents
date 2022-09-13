//
//  M2PTopTabBar.swift
//  iOSComponents
//
//  Created by Shiny on 07/09/22.
//

import UIKit

public class M2PTopTabBar: UIView {
    
    // MARK: Constants
    let cellId = "cellId"
    
    // MARK: Variables
    
    private var requiredWidthForList : CGFloat = 0
    
    private var tabItems : [M2PTopTabBarItem] = [M2PTopTabBarItem(title: "M2PTabItem")]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.backgroundLightVarient
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private var selectedItemIndex = 0
    private var tabItemConfig: M2PTabBarItemConfig?
    private var colorConfig: M2PTabBarColorConfig?
    
    public var currentSelectedIndex: Int {
        return self.selectedItemIndex
    }
    public var onSelectedIndexChange: ((Int) -> ())?

    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private func setUpView() {
        
        addSubview(collectionView)
        setCollectionViewConstraints()
        
        collectionView.register(M2PTabBarCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        updateSelectedIndexInCollection(at: selectedItemIndex)
        
    }
    
    public func setup(with items: [M2PTopTabBarItem], defaultSelectedIndex: Int? = nil, itemConfig: M2PTabBarItemConfig? = nil, colorConfig: M2PTabBarColorConfig? = nil) {
        selectedItemIndex =  defaultSelectedIndex ?? selectedItemIndex
        tabItems = items
        self.colorConfig = colorConfig ?? M2PTabBarColorConfig()
        self.tabItemConfig = itemConfig ?? M2PTabBarItemConfig()
        
        requiredWidthForList = getRequiredListWidth()
        updateCollectionView()
    }
    
    public func updateSelectedIndexInCollection(at index: Int) {
        guard index >= 0 && index < self.collectionView.numberOfItems(inSection: 0) else {
            return
        }
        
        selectedItemIndex = index
        let selectedIndexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        onSelectedIndexChange?(index)
    }
    
    private func updateCollectionView() {
        collectionView.reloadData()
        
        updateSelectedIndexInCollection(at: selectedItemIndex)
    }
    
    private func getRequiredListWidth() -> CGFloat {
        let listWidth = tabItems.enumerated().reduce(0, { width, tabItem in
            width + getWidthForTabItem(item: tabItem.element, in: tabItem.offset)
        })
        
        return listWidth
    }
    
    private func getWidthForTabItem(item: M2PTopTabBarItem, in index: Int) -> CGFloat {
        let config = self.tabItemConfig ?? M2PTabBarItemConfig()
        
        let label = UILabel(frame: CGRect.zero)
        label.text = item.title
        label.font = config.titleFont
        label.sizeToFit()
        
        let labelWidth = label.frame.width
        let imagesWidthPlusSpacing = (item.leftImage != nil ? config.imageWidth  + config.interElementSpacing : 0) + (item.rightImage != nil ? config.imageWidth + config.interElementSpacing : 0)
        let totalPadding = config.itemLeftPadding + config.itemRightPadding
        let itemWidth = labelWidth + CGFloat(imagesWidthPlusSpacing) + CGFloat(totalPadding)
        
        tabItems[index].itemWidth = itemWidth
        
        return itemWidth
    }
    
    // MARK: Constraints
    
    func setCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

// MARK: <UICollectionView Delegate> methods

extension M2PTopTabBar : UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! M2PTabBarCollectionViewCell
        
        cell.colorConfig = self.colorConfig ?? cell.colorConfig
        cell.spacingConfig = self.tabItemConfig ?? cell.spacingConfig
        cell.updateData(with: tabItems[indexPath.item])
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItemIndex = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        onSelectedIndexChange?(indexPath.item)
    }
    
}

// MARK: <UICollectionViewFlowLayout> delegate methods

extension M2PTopTabBar : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tabItem = tabItems[indexPath.item]
        var requiredItemWidth =  tabItem.itemWidth ?? getWidthForTabItem(item: tabItem, in: indexPath.item)
        
        if requiredWidthForList == 0 {
            requiredWidthForList = tabItems.count == 1 ? requiredItemWidth : getRequiredListWidth()
        }
        if requiredWidthForList < collectionView.frame.width {
            let difference = collectionView.frame.width - self.requiredWidthForList
            let sharedDifferenceValue = difference / CGFloat(tabItems.count)

            requiredItemWidth = requiredItemWidth + sharedDifferenceValue
        }
       
        return CGSize(width: requiredItemWidth, height: collectionView.frame.height)
    }
    
}


