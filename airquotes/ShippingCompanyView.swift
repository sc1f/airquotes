//
//  ShippingCompanyView.swift
//  airquotes
//
//  Created by Jun Tan on 11/28/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ShippingCompanyView: UIView {
    
    private var _name: String?
    
    var name: String {
        get { return _name! }
        set(val) {
            _name = val
            nameLabel.text = val
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 30.0, weight: .black)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var table: UITableView = {
        let view = UITableView(frame: CGRect.zero)
        view.register(ServiceTableViewCell.self, forCellReuseIdentifier: "ServiceTableViewCell")
        return view
    }()

    required init(name: String) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.white
        
        nameLabel.text = name
        self.addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10.0)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
        
        self.addSubview(table)
        table.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 5.0)
        table.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0), excludingEdge: .top)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
