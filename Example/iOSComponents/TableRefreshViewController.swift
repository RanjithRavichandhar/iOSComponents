//
//  SampleRefreshViewController.swift
//  iOSComponents_Example
//
//  Created by Balaji  on 16/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import iOSComponents

class TableRefreshViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var sampleArr = Array(1...30)
    private var refresh: Refresh = .textHeader

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        self.callRefreshView(scrollView: self.tableView)
    
        // Footer 
        tableView.spr_setTextFooter { [weak self] in
            self?.action()
        }
    }
    
    func callRefreshView(scrollView:UITableView){
      
        switch refresh {
        case .indicatorHeader:
            scrollView.spr_setIndicatorHeader { [weak self] in
                self?.action()
            }
        case .textHeader:
            scrollView.spr_setTextHeader(refreshText: RefreshText.init(loadingText: "Refreshing...", pullingText: "", releaseText: ""), height: 60) { [weak self] in
                self?.action()
            }
        case .smallGIFHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            scrollView.spr_setGIFHeader(data: data) { [weak self] in
                self?.action()
            }
        case .bigGIFHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-big", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            scrollView.spr_setGIFHeader(data: data, isBig: true, height: 120) { [weak self] in
                self?.action()
            }
        case .gifTextHeader:
            guard
                let url = Bundle.main.url(forResource: "demo-small", withExtension: "gif"),
                let data = try? Data(contentsOf: url) else { return }
            scrollView.spr_setGIFTextHeader(data: data) { [weak self] in
                self?.action()
            }
        case .indicatorFooter:
            scrollView.spr_setIndicatorFooter { [weak self] in
                self?.action()
            }
        case .textFooter:
            scrollView.spr_setTextFooter { [weak self] in
                self?.action()
            }
        case .indicatorAutoFooter:
            scrollView.spr_setIndicatorAutoFooter { [weak self] in
                self?.action()
            }
        case .textAutoFooter:
            scrollView.spr_setTextAutoFooter { [weak self] in
                self?.action()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            // tableView.spr_beginRefreshing()
    }

    private func  action() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.spr_endRefreshing()
        }
    }
}


extension TableRefreshViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleArr.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let data = sampleArr[indexPath.row]
        cell.textLabel?.text = "\(data)"
        return cell
    }
}

extension UIViewController {
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}

enum Refresh: String {
    case indicatorHeader = "Indicator Header"
    case textHeader = "Indicator + Text Header"
    case smallGIFHeader = "Small GIF Header"
    case bigGIFHeader = "Big GIF Header"
    case gifTextHeader = "GIF + Text Header"
    case indicatorFooter = "Indicator Footer"
    case textFooter = "Indicator + Text Footer"
    case indicatorAutoFooter = "Indicator Auto Footer"
    case textAutoFooter = "Indicator + Text Auto Footer"

    static let all: [Refresh] = [.indicatorHeader, .textHeader, .smallGIFHeader, .bigGIFHeader, .gifTextHeader, //.superCatHeader,
                                 .indicatorFooter, .textFooter, .indicatorAutoFooter, .textAutoFooter]
}
