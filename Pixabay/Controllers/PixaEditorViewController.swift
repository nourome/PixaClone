//
//  PixaEditorViewController.swift
//  Pixabay
//
//  Created by Nour on 28/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher


class PixaEditorViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    var viewModel = CollectionViewModel()
    var collectionViewDelegate: PixaCollectionViewDelegate!
    let disposeBag = DisposeBag()
    var stopPrefetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDelegate = PixaCollectionViewDelegate(viewModel: viewModel)
        collectionView?.delegate = collectionViewDelegate
        collectionView?.dataSource = collectionViewDelegate
        collectionView?.prefetchDataSource = self
        collectionView?.collectionViewLayout = UICollectionViewEdgeLayout()
        (collectionView?.collectionViewLayout as? UICollectionViewEdgeLayout)?.cellSizerDelegate = viewModel
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         loadPhotosAsync()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func loadPhotosAsync() {
        viewModel.loadPhotos().observeOn(MainScheduler.instance).subscribe(onNext: { status in
            switch status {
            case .Start:
                self.collectionView?.reloadData()
                break
            case .Cached:
                self.collectionView?.insertItems(at: self.viewModel.loadedItems)
                  self.stopPrefetching = false
            case .Success:
                self.collectionView?.insertItems(at: self.viewModel.loadedItems)
                self.stopPrefetching = false
            case .Failed(let errorMsg):
                print(errorMsg)
                self.stopPrefetching = true
                self.collectionView?.reloadData()
            }
        }, onError: { err in
            print(err)
            self.collectionView?.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if !stopPrefetching {
            if indexPaths.last!.item >= (viewModel.photos.count - 10) {
                stopPrefetching = true
                loadPhotosAsync()
            }
        }
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}







