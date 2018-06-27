//
//  PixaPageViewController.swift
//  Pixabay
//
//  Created by Nour on 31/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit

class PixaPageViewController: UIPageViewController {
    
    var pageCoordinator: PageCoordinator?
    var pageControl: UIPageControl!
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCoordinator = PageCoordinator()
        self.dataSource = pageCoordinator
        self.delegate = pageCoordinator
        addPageControl()
        // Do any additional setup after loading the view.
    }
    
    func addPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        pageControl.numberOfPages = Pages.all.count
        pageControl.currentPage = currentPage
        pageControl.tintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        view.addSubview(pageControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
