//
//  PixaCollectionViewController.swift
//  Pixabay
//
//  Created by Nour on 28/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class PixaCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    var viewModel: CollectionViewModel!
    var collectionViewDelegate: PixaCollectionViewDelegate!
    let disposeBag = DisposeBag()
    var stopPrefetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.collectionViewLayout = UICollectionViewEdgeLayout()
        viewModel = CollectionViewModel(collectionView: collectionView, type: .Editor, data: nil)
        collectionViewDelegate = PixaCollectionViewDelegate(viewModel: viewModel)
        collectionView?.delegate = collectionViewDelegate
        collectionView?.dataSource = collectionViewDelegate
        collectionView?.prefetchDataSource = self
        (collectionView?.collectionViewLayout as? UICollectionViewEdgeLayout)?.cellSizerDelegate = viewModel
        loadPhotosAsync()
 
    }
    
    func loadPhotosAsync() {
        viewModel.loadPhotos().observeOn(MainScheduler.instance).subscribe(onNext: { status in
            switch status {
            case .Dummy:
                 self.collectionView?.reloadData()
             break
            case .Success:
                 self.collectionView?.insertItems(at: self.viewModel.loadedItems)
                break
                //self.collectionView?.collectionViewLayout.invalidateLayout()
            case .Failed(let errorMsg):
                print(errorMsg)
                self.stopPrefetching = true
                self.viewModel.cleanUpOnError()
            }
        }, onError: { err in
            print(err)
            self.viewModel.clearDummyPhotos()
            self.collectionView?.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if !stopPrefetching {
        if indexPaths.last!.item > (viewModel.photos.count / 2) {
            loadPhotosAsync()
        }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionViewLayout.invalidateLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}



    
   


