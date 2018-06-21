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



class CollectionViewModel {
    
    var model: PixaCollectionModelProtocol!
    var requestParameters:[PixaBayAPI.Keys: String] = [:]
    var collectionView: UICollectionView?
    var collectionViewWidth: CGFloat = 375.0
    var previewWidth: CGFloat = 150.0
    var previewHeight: CGFloat = 84.0
    var imageSize = CGSize(width: 150.0, height: 84.0)
    var photos:[PixaPhotoModel] = []
    let disposeBag = DisposeBag()
    let dummyId = 0
    private var _pageNumber = 0
    
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
    var pageNumber: Int {
        get {
            return _pageNumber
        }
        set(page) {
            _pageNumber = page
            requestParameters[.page] = String(page)
        }
    }
    
    init(collectionView: UICollectionView?, type: CollectionType, data: Any?) {
        self.collectionView = collectionView
        self.collectionViewWidth = collectionView?.bounds.width ?? UIScreen.main.bounds.width
        print(self.collectionViewWidth)
        switch type {
        case .Editor:
            model = EditorCollectionModel()
        default:
            break
        }
        
        model.data = data
        requestParameters = model.parameters
        
    }
    
    func insertDummyPhotos() -> [PixaPhotoModel] {
        
        let dummySizes:[(Int,Int)] = [(150,94),(150,95), (150,84), (150,99), (142,150), (150,108), (150,89), (150,100), (150,150), (99,150)]
        
        
        //let dummyUrl = Bundle.main.url(forResource: "transparent", withExtension: "png")!
        
        var dummyPhotos:[PixaPhotoModel] = []
        
        for _ in 0..<PixaBayAPI.MaxFetchPerPage {
            let random = Int(arc4random_uniform(UInt32(dummySizes.count)))
            let dummyPhoto = PixaPhotoModel(id: dummyId, tags: nil, previewURL: nil, previewWidth: dummySizes[random].0, previewHeight: dummySizes[random].1, webformatURL: nil, webformatWidth: 0, webformatHeight: 0)
            
            dummyPhotos.append(dummyPhoto)
        }
        return dummyPhotos
    }
    
    func cleanUpOnError() {
        clearDummyPhotos()
        if let collectionLayout = collectionView?.collectionViewLayout as? UICollectionViewEdgeLayout {
            collectionLayout.clearCache(upTo: photos.count)
            collectionLayout.invalidateLayout()
            collectionView?.reloadData()
        }
    }
    
    func clearDummyPhotos() {
        photos = photos.filter{ $0.id != dummyId }
        print("photos.count \(photos.count)")
    }
    
    func loadPhotos(latest: Bool = false)-> Observable<ResponseStatus> {
        return Observable<ResponseStatus>.create { observer  in
            self.pageNumber += 1
            self.photos.append(contentsOf: self.insertDummyPhotos())
            print("counter \(self.photos.count)")
            observer.onNext(ResponseStatus.Dummy)
            self.requestPhotos(latest: latest).subscribe(onSuccess: { _ in
                observer.onNext(ResponseStatus.Success)
                observer.onCompleted()
            }, onError: { err in
                observer.onNext(ResponseStatus.Failed(err))
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func requestPhotos(latest: Bool) -> Single<Bool> {
        return Single<Bool>.create{ single in
            
            do {
                let url =  try PixaBayAPI.buildRequestURL(with: self.requestParameters, latest: latest)
                if let cached = RealmService.cache(for: url) {
                    let hits =  try PixaBayAPI.decode(response: cached)
                    self.clearDummyPhotos()
                    self.photos.append(contentsOf: hits)
                    single(.success(true))
                } else {
                    let req =  URLRequest(url: url)
                    URLSession.shared.rx.response(request: req).subscribe(onNext: { res in
                        do {
                            try PixaBayAPI.isValid(response: res)
                            let hits =  try PixaBayAPI.decode(response: res.data)
                            RealmService.save(for: url, with: res.data)
                            self.clearDummyPhotos()
                            self.photos.append(contentsOf: hits)
                            single(.success(true))
                        }catch {
                            single(.error(error))
                        }
                        
                    }, onError: { err in
                        single(.error(err))
                    }).disposed(by: self.disposeBag)
                }
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
    /*
     private func requestPhotosss(latest: Bool) -> Single<Bool> {
     
     return Single<Bool>.create { single in
     if let url = PixaBayAPI.buildRequestURL(with: self.requestParameters, latest: latest) {
     self.clearDummyPhotos()
     if let response  = RealmService.cache(for: url ) {
     guard let hits = try response.map(PixaBayAPI.decode) else {
     single(.error(PixaApiError.CachedResultsFailed("Failed to load cache")))
     }
     self.photos.append(contentsOf: hits.first!)
     }
     else {
     let req =  URLRequest(url: url)
     URLSession.shared.rx.response(request: req).subscribe(onNext: { res in
     let (httpResponse, json) = res
     if res.data.count == 0 {
     single(.error(PixaApiError.NilResults("No Results from server")))
     }
     if 200..<300 ~= httpResponse.statusCode   {
     
     guard let hits = try? JSONDecoder().decode(PixaResponse.self, from: json).hits else {
     single(.error(PixaApiError.FailedToDecodePhoto("Decoding Process Failed")))
     return
     }
     self.photos.append(contentsOf: hits!)
     single(.success(true))
     } else {
     single(.error(PixaApiError.HttpResponseError("Response Failed at \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")))
     }
     
     }, onError: { err in
     single(.error(err))
     }).disposed(by: self.disposeBag)
     }
     
     return Disposables.create()
     }
     }
     }
     */
}

extension CollectionViewModel: CellSizerDelegate {
    var maxWidthDifference: Int {
        get {
            return 60
        }
    }
    var minWidthDifference: Int {
        get {
            return 30
        }
    }
    
    func sizeForCell(with indexPath: IndexPath) -> CGSize {
        
        var size = CGSize(width: 0, height: 0)
        if photos.count > indexPath.item {
            let photoItem = photos[indexPath.item]
            size = CGSize(width: photoItem.previewWidth, height: photoItem.previewHeight)
            let difference = photoItem.previewWidth - photoItem.previewHeight
            
            if difference > maxWidthDifference {
                size = fullSize(for: collectionView!, width: photoItem.previewWidth, height: photoItem.previewHeight)
                
            } else if difference > 0 && difference < minWidthDifference {
                size = halfSize(for: collectionView!, width: photoItem.previewWidth, height: photoItem.previewHeight)
            }
        }
        return size
    }
}
