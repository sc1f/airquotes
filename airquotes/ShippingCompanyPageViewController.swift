//
//  ShippingCompanyPageViewController.swift
//  airquotes
//
//  Created by Jun Tan on 11/28/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ShippingCompanyPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var companies = [UIViewController]()
    let pageControl = UIPageControl(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let initial = 0
        
        let UPS = CompanyViewController()
        UPS.name = "UPS"
        
        let FedEx = CompanyViewController()
        FedEx.name = "FedEx"
        
        let USPS = CompanyViewController()
        USPS.name = "USPS"
        
        self.companies.append(UPS)
        self.companies.append(FedEx)
        self.companies.append(USPS)
        
        setViewControllers([companies[initial]], direction: .forward, animated: true, completion: nil)
        
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.companies.count
        self.pageControl.currentPage = initial
        
        self.view.addSubview(self.pageControl)
        pageControl.autoAlignAxis(toSuperviewAxis: .vertical)
        pageControl.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10.0)
    }
    

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let idx = self.companies.index(of: viewController) {
            if idx == 0 {
                return self.companies.last
            } else {
                return self.companies[idx - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let idx = self.companies.index(of: viewController) {
            if idx < self.companies.count - 1 {
                return self.companies[idx + 1]
            } else {
                return self.companies.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let controllers = pageViewController.viewControllers {
            if let idx = self.companies.index(of: controllers[0]) {
                self.pageControl.currentPage = idx
            }
        }
    }

}
