//
//  PixaImageViewController.swift
//  Pixabay
//
//  Created by Nour on 03/07/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PixaImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
   // var imageView: UIImageView!

   
    var disposeBag = DisposeBag()
    var viewModel = ImageViewerModel()
    
@IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        viewModel.contentRect = view.bounds
        viewModel.photoLoaded.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { status in
            if status {
              
                let imageRect =  self.viewModel.imagViewRect
                self.imageView.heightAnchor.constraint(equalToConstant: imageRect.height).isActive = true
                 self.imageView.widthAnchor.constraint(equalToConstant: imageRect.width).isActive = true
                //self.imageWidthConstraint.constant = imageRect.width
                //self.imageHeightConstraint.constant = imageRect.height
                self.imageView.kf.setImage(with: self.viewModel.photo!.webformatURL)
                print(self.imageView.frame)
            }
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor)
        imageView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor)
        view.layoutIfNeeded()
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
