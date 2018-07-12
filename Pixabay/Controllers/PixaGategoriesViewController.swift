//
//  GategoryCollectionViewController.swift
//  Pixabay
//
//  Created by Nour on 31/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit


class PixaGategoriesViewController: UICollectionViewController {

    var viewModel = CategoryViewModel()
    var delegate: CategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
        
       //viewModel.collectionSize = collectionView?.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.size
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.Cell.rawValue, for: indexPath) as! CategoryViewCell
    
        cell.imageView.image = UIImage(named: viewModel.images[indexPath.item])
        cell.label.text = viewModel.labels[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReuseIdentifiers.Header.rawValue, for: indexPath)
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedCategory = viewModel.selectedCategory(for: indexPath) {
            delegate?.didSelect(selectedCategory)
        }
    }

    

}

extension PixaGategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1.0
    }
    
    
}
