//
//  PixalCategoryPhotosViewController.swift
//  Pixabay
//
//  Created by Nour on 23/06/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit
import RxSwift


class PixalCategoryPhotosViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
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
         navigationController?.setNavigationBarHidden(false, animated: false)
        loadPhotosAsync()
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
    
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
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
