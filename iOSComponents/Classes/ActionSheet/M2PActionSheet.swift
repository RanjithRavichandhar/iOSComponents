//
//  M2PActionSheet.swift
//  iOSComponents
//
//  Created by CHANDRU on 15/09/22.
//

import UIKit

// MARK: - M2PActionSheet
public class M2PActionSheet: UIAlertController {
    
    // MARK: Local Variables
    private var controller: UITableViewController
    
    private var headerContent: LeadingContentList?
    private var  actionItems: [ActionItems] = []
    
    private var isHeaderContent = 0
    private let cellId = "ActionCellID"
    private var onItemHandler: ((Int) -> Void)?
    
    // MARK: - Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        controller = UITableViewController(style: .plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        controller.tableView.register(ActionSheetCell.self, forCellReuseIdentifier: cellId)
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
    public func setUpActionView(headerContent: LeadingContentList? = nil, items: [ActionItems] = [], itemHandler: @escaping (_ index: Int) -> Void) {
        onItemHandler = itemHandler
        isHeaderContent = (headerContent != nil && !(headerContent?.subTextLabel?.text?.isEmpty ?? true && headerContent?.headerTextLabel?.text?.isEmpty ?? true)) ? 1 : 0
        self.headerContent = headerContent
        DispatchQueue.main.async {
            self.actionItems = items
            self.controller.tableView.reloadData()
        }
    }
    
    private func initalValueSetup() {
        setUpActionView(headerContent: LeadingContentList(headerTextLabel: ContentTextModel(text: "M2PActionSheet", textColor: .primaryActive), subTextLabel: nil, icon: nil), items: []) { _ in
            
        }
    }
}

// MARK: - UITableView Delegate & DataSource

extension M2PActionSheet: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actionItems.count + isHeaderContent
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ActionSheetCell else {
            return UITableViewCell.init()
        }
        cell.selectionStyle = .none
        
        // Show Action Header in First Cell
        guard !(isHeaderContent != 0 && indexPath.row == 0) else {
            let leading = LeadingContentList(headerTextLabel: self.headerContent?.headerTextLabel, subTextLabel: self.headerContent?.subTextLabel, icon: self.headerContent?.icon)
            
            leading?.headerTextLabel?.textAlignment = (self.headerContent?.icon?.image != nil) ? NSTextAlignment.left :  NSTextAlignment.center
            leading?.subTextLabel?.textAlignment = (self.headerContent?.icon?.image != nil) ? NSTextAlignment.left :  NSTextAlignment.center
            
            cell.listView.setupList(leadingContent: leading, trailingContent: nil)
            return cell
        }
        
        let singleItem = self.actionItems[indexPath.row - isHeaderContent]
        let textAlign = (singleItem.image == nil) ? NSTextAlignment.center : NSTextAlignment.left
        let contentText = ContentTextModel(text: singleItem.text, textColor: singleItem.textColor, textFont: singleItem.fontSize, textAlignment: textAlign)
        
        let leading = LeadingContentList(headerTextLabel: contentText, subTextLabel: nil, icon: nil)
        let trailing = TrailingContentList(contentType: .icon, headerTextLabel: nil, subTextLabel: nil, actionTitleLabel: nil, icon: ContentImageModel(image: singleItem.image?.withRenderingMode(.alwaysTemplate), tintColor: singleItem.tintColor))
        
        cell.listView.setupList(leadingContent: leading, trailingContent: trailing)
        
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
class ActionSheetCell: UITableViewCell {
    
    lazy var listView: M2PList = {
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
public struct ActionItems {
    public var text: String?
    public var image: UIImage?
    public var textColor: UIColor
    public var tintColor: UIColor
    public var fontSize: UIFont
    
    public init(text: String?, image: UIImage?, textColor: UIColor = .black, tintColor: UIColor = UIColor.black, fontSize: UIFont = UIFont.systemFont(ofSize: 15)) {
        self.text = text
        self.image = image
        self.tintColor = tintColor
        self.fontSize = fontSize
        self.textColor = textColor
    }
}
