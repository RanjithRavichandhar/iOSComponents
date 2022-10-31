//
//  CollectionRefreshViewController.swift
//  iOSComponents_Example
//
//  Created by Balaji  on 19/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import iOSComponents

class CollectionRefreshViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var sampleArr = Array(1...100)
    private var refresh: Refresh = .textHeader
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       
        self.callRefreshView(scrollView: self.scrollView)
        
        //Footer
        self.scrollView.spr_setTextFooter(refreshText: RefreshText.init(loadingText: "Refreshing...", pullingText: "", releaseText: ""), height: 50) { [weak self] in
            self?.action()
        }
    }
    
    func callRefreshView(scrollView:UIScrollView){
      
        switch refresh {
        case .indicatorHeader:
            scrollView.spr_setIndicatorHeader { [weak self] in
                self?.action()
            }
        case .textHeader:
            scrollView.spr_setTextHeader { [weak self] in
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
    
    private func  action() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.scrollView.spr_endRefreshing()
        }
    }
    
    private func  scrollAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.spr_endRefreshing()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            // scrollView.spr_beginRefreshing()
    }
    
}

extension CollectionRefreshViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sampleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SampleCollectionCell", for: indexPath) as! SampleCollectionCell
        let data = sampleArr[indexPath.item]
        cell.lbl.text = "\(data)"
        return cell
    }
}

class SampleCollectionCell: UICollectionViewCell {
    @IBOutlet weak var lbl:UILabel!
}
