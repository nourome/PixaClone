//
//  PixaPageViewController.swift
//  Pixabay
//
//  Created by Nour on 31/05/2018.
//  Copyright © 2018 Nour Saffaf. All rights reserved.
//

import UIKit

class PixaPageViewController: UIPageViewController, UIPageViewControllerDelegate,  UIPageViewControllerDataSource {
    
    var viewModel: PageViewModel!
    var pageControl: UIPageControl!
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        viewModel = PageViewModel()
        addPageControl()
        
        let firstPage = storyboard?.instantiateViewController(withIdentifier: Pages.Search.rawValue)
        setViewControllers([firstPage!], direction: .forward, animated: false, completion: nil)
        
       
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
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("before called)")
        
        if let nextIdentifier = viewModel.viewControllerNextTo(identifier: viewController.restorationIdentifier, nextId: -) {
            return storyboard?.instantiateViewController(withIdentifier: nextIdentifier)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("after called \(viewController)")
        if let nextIdentifier = viewModel.viewControllerNextTo(identifier: viewController.restorationIdentifier, nextId: +) {
            return storyboard?.instantiateViewController(withIdentifier: nextIdentifier)
        }
        
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let nextViewController = pendingViewControllers.first {
            currentPage = viewModel.indexOfViewControllerWith(nextViewController.restorationIdentifier)
        }
       
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        pageControl.currentPage = currentPage
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
