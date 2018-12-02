//
//  CompanyViewController.swift
//  airquotes
//
//  Created by Jun Tan on 11/28/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var successFeedbackGenerator = UINotificationFeedbackGenerator()
    
    private struct service {
        var name: String
        var price: Float
        var due: String
    }
    
    private let services: [service] = [
        service(name: "Fast Shipping", price: 25.00, due: "Monday"),
        service(name: "Medium Speed Shipping", price: 15, due: "Wednesday"),
        service(name: "Super Value Saver", price: 5.00, due: "Friday")
    ]
    
    public var data: [Any]?

    private var _name: String?
    
    public var name: String {
        get { return _name! }
        set(val) {
            _name = val
            companyView.name = val
        }
    }
    
    let companyView = ShippingCompanyView(name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyView.table.delegate = self
        companyView.table.dataSource = self
        
        self.view.addSubview(companyView)
        companyView.autoPinEdgesToSuperviewEdges()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO implement API and cleanup
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell", for: indexPath) as! ServiceTableViewCell
    
        if data!.count > 0 {
            let service = data![indexPath.row] as! UPSService
            let due = service.due as UPSDue

            cell.nameLabel.text = service.name
            cell.priceLabel.text = "$\(service.charge)"
            cell.dueLabel.text = "\(due.time), \(due.date)"
        } else {
            let service = services[indexPath.row]
            cell.nameLabel.text = service.name
            cell.priceLabel.text = String(format: "%.2f", service.price)
            cell.dueLabel.text = service.due
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        successFeedbackGenerator.prepare()
        successFeedbackGenerator.notificationOccurred(.success)
    }
}
