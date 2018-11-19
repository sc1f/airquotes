//
//  ShippingCompanyTableViewCell.swift
//  airquotes
//
//  Created by Jun Tan on 11/18/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ShippingCompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var ShippingCompanyNameUILabel: UILabel!
    @IBOutlet weak var ServiceCollectionView: ServiceCollectionView!
    
    // TODO: configure name for company
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
