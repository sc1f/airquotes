//
//  ItemHistoryTableViewController.swift
//  airquotes
//
//  Created by Jun Tan on 12/9/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit
import CoreData

class ItemHistoryTableViewController: UITableViewController {
    
    var successFeedbackGenerator = UINotificationFeedbackGenerator()
    var historyItems: [NSManagedObject] = []
    var currentItem: Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Item History"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(ItemHistoryTableViewCell.self, forCellReuseIdentifier: "ItemHistoryTableViewCell")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        do {
            historyItems = try managedContext.fetch(fetchRequest)
            print(historyItems)
        } catch let error as NSError {
            print("Could not fetch items: \(error)")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHistoryTableViewCell", for: indexPath) as! ItemHistoryTableViewCell
        cell.currentItem = historyItems[indexPath.row] as? Item
        
        let dimensionSummaryView: DefaultStackView = {
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
            
            let lengthValueLabel = SmallLabel(text: String(format: "%.2f\"", cell.currentItem!.dimension!.length), alignment: .center, font_size: 14.0)
            let widthValueLabel = SmallLabel(text: String(format: "%.2f\"", cell.currentItem!.dimension!.width), alignment: .center, font_size: 14.0)
            let heightValueLabel = SmallLabel(text: String(format: "%.2f\"", cell.currentItem!.dimension!.height), alignment: .center, font_size: 14.0)
            
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
        
        let metadataSummaryView = ItemMetadataSummaryView(currentItem: cell.currentItem!)
        
        metadataSummaryView.metadataSummaryStackView.addArrangedSubview(dimensionSummaryView)
        
        cell.contentView.addSubview(metadataSummaryView)
        metadataSummaryView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let item = self.historyItems[indexPath.row]
            managedContext.delete(item)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not delete item: \(error)")
                return
            }
            
            self.historyItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        successFeedbackGenerator.prepare()
        currentItem = historyItems[indexPath.row] as? Item
        performSegue(withIdentifier: "showPriceView", sender: self)
        successFeedbackGenerator.notificationOccurred(.success)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPriceView" {
            let vc = segue.destination as! PriceViewController
            vc.currentItem = self.currentItem
        }
    }
}
