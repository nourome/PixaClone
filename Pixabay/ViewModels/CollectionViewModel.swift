//
//  PixaCollectionViewModel.swift
//  Pixabay
//
//  Created by Nour on 28/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import AVFoundation
import Kingfisher


class CollectionViewModel:ViewModel {
    var collectionView: UICollectionView?
    var model: PixaCollectionModelProtocol!
    var collectionViewWidth: CGFloat = 375.0
    var photos:[PixaPhotoModel] = []
    let disposeBag = DisposeBag()
    private var _pageNumber = 0
    var collectionCellDelegate: CollectionCellDelegate?
    
    var loadedItems:[IndexPath] {
        get {
            if photos.count > 0 {
                let min = photos.count - PixaBayAPI.MaxFetchPerPage
                let max =  photos.count
                let range = Array(min..<max)
                return range.map { element in
                    return IndexPath(item: element, section: 0)
                }
            } else {
                return []
            }
        }
    }
    
    var loadedItemsUrl:[URL] {
        get {
            if photos.count > 0 {
                let min = photos.count - PixaBayAPI.MaxFetchPerPage
                let max =  photos.count
                let range = Array(min..<max)
                let dummyUrl = Bundle.main.url(forResource: "transparent", withExtension: "png")!
                return range.map { element in
                    return photos[element].previewURL ?? dummyUrl
                    }.filter{ $0.absoluteString != dummyUrl.absoluteString}
                
            } else {
                return []
            }
        }
    }
    
    var pageNumber: Int {
        get {
            return _pageNumber
        }
        set(page) {
            _pageNumber = page
            model.parameters[.page] = String(page)
        }
    }
    
    func presentImage(at indexIndex: IndexPath) {
        collectionCellDelegate?.didSelect(photo: photos[indexIndex.item])
    }
    
    func loadPhotos(latest: Bool = false)-> Observable<ResponseStatus> {
        return Observable<ResponseStatus>.create { observer  in
            self.pageNumber += 1
            print(self.model.parameters)
            do {
                let url =  try PixaBayAPI.buildRequestURL(with: self.model.parameters, latest: latest)
                print("url ===> \(url.absoluteString)")
                if let cached = RealmService.cache(for: url) {
                    let hits =  try PixaBayAPI.decode(response: cached)
                    self.photos.append(contentsOf: hits)
                    if self.photos.count <= PixaBayAPI.MaxFetchPerPage {
                        observer.onNext(.Start)
                        observer.onCompleted()
                    }else {
                        observer.onNext(.Cached)
                        observer.onCompleted()
                        ImagePrefetcher.init(urls: self.loadedItemsUrl).start()
                    }
                } else {
                    self.requestPhotos(url: url, latest: latest).subscribe(onSuccess: { status in
                        observer.onNext(status)
                        observer.onCompleted()
                    }, onError: { err in
                        observer.onNext(ResponseStatus.Failed(err))
                    }).disposed(by: self.disposeBag)
                }
            } catch {
                observer.onNext(.Failed(error))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    
    private func requestPhotos(url: URL, latest: Bool) -> Single<ResponseStatus> {
        return Single<ResponseStatus>.create{ single in
            
            let req =  URLRequest(url: url)
            URLSession.shared.rx.response(request: req).subscribe(onNext: { res in
                do {
                    try PixaBayAPI.isValid(response: res)
                    let hits =  try PixaBayAPI.decode(response: res.data)
                    RealmService.save(for: url, with: res.data)
                    self.photos.append(contentsOf: hits)
                    if self.photos.count <= PixaBayAPI.MaxFetchPerPage {
                        single(.success(.Start))
                    }else {
                        single(.success(.Success))
                        ImagePrefetcher.init(urls: self.loadedItemsUrl).start()
                    }
                }catch {
                    single(.error(error))
                }
                
            }, onError: { err in
                single(.error(err))
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
}

extension CollectionViewModel: CellSizerDelegate {
    
    func sizeForCell(with indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 1500, height: 150)
        if photos.count > indexPath.item {
            let photoItem = photos[indexPath.item]
            
            size = CGSize(width: photoItem.previewWidth, height: photoItem.previewHeight)
            let difference = photoItem.previewWidth - photoItem.previewHeight
            
            if difference > maxWidthDifference {
                size = fullSize(for: collectionView!, width: photoItem.previewWidth, height: photoItem.previewHeight)
                
            } else if difference > 0 && difference < minWidthDifference {
                size = halfSize(for: collectionView!, width: photoItem.previewWidth, height: photoItem.previewHeight)
            } else {
                size = stretchSize(for: collectionView!, width: photoItem.previewWidth, height: photoItem.previewHeight)
            }
        }
        return size
    }
}
