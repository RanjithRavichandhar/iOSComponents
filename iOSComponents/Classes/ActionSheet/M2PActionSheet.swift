//
//  M2PActionSheet.swift
//  iOSComponents
//
//  Created by CHANDRU on 15/09/22.
//

import UIKit

/* MARK: - Implementation
 
 let actionItems = [
 M2PActionItems(text: "Open Settings", image: UIImage(named: "setting"), textColor: .primaryActive , tintColor: .primaryActive, font: .systemFont(ofSize: 15)),
 M2PActionItems(text: "Refresh", image: UIImage(named: ""), textColor: .primaryActive, tintColor: .primaryActive, font: .systemFont(ofSize: 15)),
 M2PActionItems(text: "Delete", image: UIImage(named: "delete"), textColor: .red, tintColor: .primaryActive, font: .systemFont(ofSize: 15)),
 ]
 
 let headerContent = M2PLeadingContentList(headerTextLabel: M2PContentTextModel(text: "Header", textColor: .primaryActive, textFont: .systemFont(ofSize: 17)), subTextLabel: M2PContentTextModel(text: "Sub", textColor: .primaryActive, textFont: .systemFont(ofSize: 12)), icon: M2PContentImageModel(image: UIImage(named: "")?.withRenderingMode(.alwaysTemplate), tintColor: .primaryActive), isAvatorIcon: false)
 
 MARK: Setup
 let actionSheet = M2PActionSheet(title: nil, message: nil, preferredStyle: .actionSheet)
 actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
 
 actionSheet.M2PSetUpActionView(headerContent: headerContent, items: actionItems) { index in
 actionSheet.dismiss(animated: true, completion: nil)
 }
 
 self.present(actionSheet, animated: false, completion: nil)
 
 */

// MARK: - M2PActionSheet
public class M2PActionSheet: UIAlertController {
    
    // MARK: Local Variables
    private var controller: UITableViewController
    
    private var headerContent: M2PLeadingContentList?
    private var actionItems: [M2PActionItems] = []
    
    private var isHeaderContent = 0
    private let cellId = "M2PActionCellID"
    private var onItemHandler: ((Int) -> Void)?
    
    // MARK: - Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        controller = UITableViewController(style: .plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        controller.tableView.register(M2PActionSheetCell.self, forCellReuseIdentifier: cellId)
        controller.tableView.dataSource = self
        controller.tableView.delegate = self
        controller.tableView.addObserver(self, forKeyPath: "contentSize", options: [.initial,.new], context: nil)
        self.setValue(controller, forKey: "contentViewController")
        initalValueSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        controller.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // MARK: - Observer
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize" else {
            return
        }
        self.controller.preferredContentSize = controller.tableView.contentSize
        print("Size",controller.preferredContentSize, controller.tableView.intrinsicContentSize)
    }
    
    // MARK: - ActionSheet Setup
    public func M2PSetUpActionView(headerContent: M2PLeadingContentList? = nil, items: [M2PActionItems] = [], itemHandler: @escaping (_ index: Int) -> Void) {
        onItemHandler = itemHandler
        isHeaderContent = (headerContent != nil && !(headerContent?.subTextLabel?.text?.isEmpty ?? true && headerContent?.headerTextLabel?.text?.isEmpty ?? true)) ? 1 : 0
        self.headerContent = headerContent
        DispatchQueue.main.async {
            self.actionItems = items
            self.controller.tableView.reloadData()
        }
    }
    
    private func initalValueSetup() {
        M2PSetUpActionView(headerContent: M2PLeadingContentList(headerTextLabel: M2PContentTextModel(text: "M2PActionSheet", textColor: .primaryActive), subTextLabel: nil, icon: nil), items: []) { _ in
            self.dismiss(animated: true)
        }
    }
}

// MARK: - UITableView Delegate & DataSource

extension M2PActionSheet: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actionItems.count + isHeaderContent
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? M2PActionSheetCell else {
            return UITableViewCell.init()
        }
        cell.selectionStyle = .none
        
        // Show Action Header in First Cell
        guard !(isHeaderContent != 0 && indexPath.row == 0) else {
            let leading = M2PLeadingContentList(headerTextLabel: self.headerContent?.headerTextLabel, subTextLabel: self.headerContent?.subTextLabel, icon: self.headerContent?.icon)
            
            leading?.headerTextLabel?.textAlignment = (self.headerContent?.icon?.image != nil) ? NSTextAlignment.left :  NSTextAlignment.center
            leading?.subTextLabel?.textAlignment = (self.headerContent?.icon?.image != nil) ? NSTextAlignment.left :  NSTextAlignment.center
            
            cell.listView.M2PSetupList(leadingContent: leading, trailingContent: nil)
            return cell
        }
        
        let singleItem = self.actionItems[indexPath.row - isHeaderContent]
        let textAlign = (singleItem.image == nil) ? NSTextAlignment.center : NSTextAlignment.left
        let contentText = M2PContentTextModel(text: singleItem.text, textColor: singleItem.textColor, textFont: singleItem.font, textAlignment: textAlign)
        
        let leading = M2PLeadingContentList(headerTextLabel: contentText, subTextLabel: nil, icon: nil)
        let trailing = M2PTrailingContentList(contentType: .icon, headerTextLabel: nil, subTextLabel: nil, actionTitleLabel: nil, icon: M2PContentImageModel(image: singleItem.image?.withRenderingMode(.alwaysTemplate), tintColor: singleItem.tintColor))
        
        cell.listView.M2PSetupList(leadingContent: leading, trailingContent: trailing)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !(isHeaderContent != 0 && indexPath.row == 0) else {
            return
        }
        print("Selected Action Index \(indexPath.row), \(actionItems[indexPath.row - isHeaderContent])")
        self.onItemHandler?(indexPath.row - isHeaderContent)
    }
}

// MARK: - ActionSheetCell
class M2PActionSheetCell: UITableViewCell {
    
    fileprivate lazy var listView: M2PList = {
        let view = M2PList()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(listView)
        
        listView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4).isActive = true
        listView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4).isActive = true
        listView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4).isActive = true
        listView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4).isActive = true
        listView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ActionItems
public struct M2PActionItems {
    /// Item Text
    public var text: String?
    
    /// Item Icon
    public var image: UIImage?
    
    /// Text color
    public var textColor: UIColor
    
    /// Icon color
    public var tintColor: UIColor
    
    /// text font size
    public var font: UIFont
    
    public init(text: String?, image: UIImage?, textColor: UIColor = .black, tintColor: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 15)) {
        self.text = text
        self.image = image
        self.tintColor = tintColor
        self.font = font
        self.textColor = textColor
    }
}
