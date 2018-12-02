//
//  PriceViewController.swift
//  airquotes
//
//  Created by Jun Tan on 11/18/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit
import Firebase

class PriceViewController: UIViewController {
    
    lazy var functions = Functions.functions()
    
    var currentItem: Item?
    var UPSData: [UPSService] = []
    
    var loadingIndicator = UIActivityIndicatorView(frame: CGRect.zero)
    
    lazy var dimensionSummaryView: DefaultStackView = {
        let view = DefaultStackView(spacing: 0.0, axis: .horizontal)
        
        let lengthStackView = DefaultStackView(spacing: 5.0, axis: .vertical)
        let widthStackView = DefaultStackView(spacing: 5.0, axis: .vertical)
        let heightStackView = DefaultStackView(spacing: 5.0, axis: .vertical)
        
        let lengthLabel = SmallLabel(text: "LENGTH", alignment: .center, font_size: 12.0)
        let widthLabel = SmallLabel(text: "WIDTH", alignment: .center, font_size: 12.0)
        let heightLabel = SmallLabel(text: "HEIGHT", alignment: .center, font_size: 12.0)
        
        lengthLabel.textColor = UIColor.gray
        widthLabel.textColor = UIColor.gray
        heightLabel.textColor = UIColor.gray
        
        let lengthValueLabel = SmallLabel(text: String(format: "%.2f\"", currentItem!.dimensions.length), alignment: .center, font_size: 14.0)
        let widthValueLabel = SmallLabel(text: String(format: "%.2f\"", currentItem!.dimensions.width), alignment: .center, font_size: 14.0)
        let heightValueLabel = SmallLabel(text: String(format: "%.2f\"", currentItem!.dimensions.height), alignment: .center, font_size: 14.0)
        
        lengthStackView.addArrangedSubview(lengthLabel)
        lengthStackView.addArrangedSubview(lengthValueLabel)
        
        widthStackView.addArrangedSubview(widthLabel)
        widthStackView.addArrangedSubview(widthValueLabel)
        
        heightStackView.addArrangedSubview(heightLabel)
        heightStackView.addArrangedSubview(heightValueLabel)
        
        view.addArrangedSubview(lengthStackView)
        view.addArrangedSubview(widthStackView)
        view.addArrangedSubview(heightStackView)
        
        return view
    }()
    
    lazy var metadataSummaryView: ItemMetadataSummaryView = {
        let view = ItemMetadataSummaryView(currentItem: self.currentItem!)
        view.addBottomBorder()
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        
        button.setTitle("Back", for: .normal)
        
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 5.0
        
        button.addTarget(self, action: #selector(handleBackButtonPress), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleBackButtonPress(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRootSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.metadataSummaryView.metadataSummaryStackView.addArrangedSubview(self.dimensionSummaryView)
        self.view.addSubview(self.metadataSummaryView)
        self.metadataSummaryView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), excludingEdge: .bottom)
        
        self.view.addSubview(loadingIndicator)
        loadingIndicator.autoCenterInSuperview()
        loadingIndicator.startAnimating()
        
        let encoder = JSONEncoder()
        let json_item = try! encoder.encode(currentItem)
        let json_string = String(data: json_item, encoding: .utf8)
        
        functions.httpsCallable("getPrice")
            .call(["company": "UPS", "item": json_string]) { (result, error) in
                if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                        
                        print(code!)
                        print(details!)
                        print(message)
                    }
                }
                
                let price_data = (result?.data as! [NSDictionary])
                
                for service in price_data {
                    let due = service["due"] as! NSDictionary
                    
                    guard
                        let name = service["name"] as? String,
                        let charge = service["charge"] as? String,
                        let due_date = due["date"] as? String,
                        let due_time = due["time"] as? String,
                        let transit_time = service["transit_time"] as? String
                        else {
                            print(service)
                            continue
                        }
                    let new_due = UPSDue.init(date: due_date, time: due_time)
                    let new_service = UPSService.init(name: name, charge: charge, due: new_due, transit_time: transit_time)
                    self.UPSData.append(new_service)
                }
                
                print(self.UPSData)
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.removeFromSuperview()
                
                let companyPageController = ShippingCompanyPageViewController()
                companyPageController.UPSData = self.UPSData
                self.addChild(companyPageController)
                
                self.view.addSubview(companyPageController.view)
                companyPageController.view.autoPinEdge(.top, to: .bottom, of: self.metadataSummaryView, withOffset: 10.0)
                companyPageController.view.autoPinEdge(toSuperviewEdge: .leading, withInset: 10.0)
                companyPageController.view.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10.0)
                companyPageController.view.autoPinEdge(toSuperviewEdge: .bottom, withInset: 30.0)
                
                self.view.addSubview(self.backButton)
                self.backButton.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0), excludingEdge: .top)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
