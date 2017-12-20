//
//  JeepSelectorViewController.swift
//  ThePost
//
//  Created by Andrew Robinson on 12/26/16.
//  Copyright © 2016 XYello, Inc. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import SwiftKeychainWrapper

class JeepSelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var jeeps: [Jeep] = []
    
    private var selectedJeepModel: Jeep!
    
    private var pageSize: CGSize {
        let layout = collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UPCarouselFlowLayout()

        jeeps.append(Jeep(withType: JeepModel.cherokeeCJ))
        jeeps.append(Jeep(withType: JeepModel.wranglerYJ))
        jeeps.append(Jeep(withType: JeepModel.wranglerTJ))
        jeeps.append(Jeep(withType: JeepModel.wranglerJK))
        jeeps.append(Jeep(withType: JeepModel.cherokeeXJ))
        jeeps.append(Jeep(withType: JeepModel.all))
        
        // These ratios that are defined here are values defined in the Sketch file. Cell size / screen size
        layout.itemSize = CGSize(width: floor(view.frame.width * (350/414)), height: floor(view.frame.height * (326/736)))
        
        layout.spacingMode = .overlap(visibleOffset: 120)
        layout.scrollDirection = .horizontal
        layout.sideItemScale = 1.0
        layout.sideItemAlpha = 0.3
        layout.sideItemShift = 25.0
        collectionView.collectionViewLayout = layout

        collectionView.isPrefetchingEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentlySelected = KeychainWrapper.standard.string(forKey: UserInfoKeys.UserSelectedJeep) {
            let jeepType = JeepModel.enumFromString(string: currentlySelected)
            view.layoutIfNeeded()
            collectionView.scrollToItem(at: findEnum(forType: jeepType), at: .centeredHorizontally, animated: false)
        }
    }
    
    // MARK: - CollectionView datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jeeps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jeepSelectorCell", for: indexPath) as! JeepSelectorCollectionViewCell
        
        if cell.selectButton.allTargets.count < 1 {
            cell.selectButton.addTarget(self, action: #selector(selectedJeepCategory), for: .touchUpInside)
        }
        
        if let image = jeeps[indexPath.row].image {
            cell.modelImage.image = image
        }
        
        if let name = jeeps[indexPath.row].name {
            cell.modelLabel.text = name
        }
        
        if let start = jeeps[indexPath.row].startYear, let end = jeeps[indexPath.row].endYear {
            cell.modelYearLabel.text = "\(start)-\(end)"
        } else if jeeps[indexPath.row].type == .all {
            cell.modelYearLabel.text = "Any year"
        }
        
        cell.selectButton.jeepModel = jeeps[indexPath.row]
        
        return cell
    }
    
    // MARK: - CollectionView delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let layout = collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? pageSize.width : pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        
        pageControl.currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    // MARK: - Actions
    
    @objc private func selectedJeepCategory(sender: JeepModelButton) {
        selectedJeepModel = sender.jeepModel
        KeychainWrapper.standard.set(selectedJeepModel.type.name, forKey: UserInfoKeys.UserSelectedJeep)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func findEnum(forType type: JeepModel) -> IndexPath {
        var index = 0
        
        var indexPath = IndexPath(row: 0, section: 0)
        for jeep in jeeps {
            if type.name == jeep.type.name {
                indexPath = IndexPath(row: index, section: 0)
            }
            index += 1
        }
        
        return indexPath
    }

}