//
//  ShippingCompanyPageViewController.swift
//  airquotes
//
//  Created by Jun Tan on 11/28/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ShippingCompanyPageViewController: UIViewController {
    
    public var UPSData: [UPSService] = []
    
    var currentCompany = "UPS"
    var companies = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let UPS = CompanyViewController()
        UPS.name = "UPS"
        UPS.data = UPSData
        
        self.addChild(UPS)
        self.view.addSubview(UPS.view)
    }
}
