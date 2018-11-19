//
//  ServiceTableViewCell.swift
//  airquotes
//
//  Created by Jun Tan on 11/18/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ShippingCompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var ServiceName: UILabel!
    @IBOutlet weak var ServicePrice: UILabel!
    @IBOutlet weak var ServiceDueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
