//
//  PriceViewController.swift
//  airquotes
//
//  Created by Jun Tan on 11/18/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var BackRectangle: RoundedRectangle!
    @IBOutlet weak var ShippingCompanyTableView: ShippingCompanyTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ShippingCompanyTableView.delegate = self
        ShippingCompanyTableView.dataSource = self
        
        // round top corners
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 10
        self.view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleBackPanGesture)))
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: set up API gateways
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingCompanyTableViewCell") as! ShippingCompanyTableViewCell
        cell.ShippingCompanyNameUILabel.text = "USPS"
        cell.ServiceCollectionView.delegate = self
        cell.ServiceCollectionView.dataSource = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // TODO: dynamic row height
        return 150.0;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        cell.ServiceNameUILabel.text = "Priority Mail"
        cell.ServicePriceUILabel.text = "$13.95"
        cell.ServiceDueDateUILabel.text = "Monday, November 19"
        return cell
    }
    
    @objc func handleBackPanGesture(sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        let translation = sender.translation(in: view)
        
        let newY = ensureRange(value: view.frame.minY + translation.y, minimum: 0, maximum: view.frame.maxY)
        let progress = progressAlongAxis(newY, view.bounds.height)
        
        view.frame.origin.y = newY //Move view to new position
        
        if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            if velocity.y >= 300 || progress > percentThreshold {
                self.dismiss(animated: true) //Perform dismiss
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame.origin.y = 0 // Revert animation
                })
            }
        }
        
        sender.setTranslation(.zero, in: view)
    }
    
    func progressAlongAxis(_ pointOnAxis: CGFloat, _ axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
    
    func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
        return min(max(value, minimum), maximum)
    }
}
