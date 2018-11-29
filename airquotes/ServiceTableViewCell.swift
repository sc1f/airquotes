//
//  ServiceTableViewCell.swift
//  airquotes
//
//  Created by Jun Tan on 11/28/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    let serviceStack = DefaultStackView(spacing: 0.0, axis: .vertical)
    let metaStack = DefaultStackView(spacing: 0.0, axis: .horizontal)
    
    let nameLabel: SmallLabel = {
        let label = SmallLabel(text: "", alignment: .left, font_size: 16.0)
        return label
    }()
    
    let priceLabel: SmallLabel = {
        let label = SmallLabel(text: "", alignment: .right, font_size: 20.0)
        return label
    }()
    
    let dueLabel: SmallLabel = {
        let label = SmallLabel(text: "", alignment: .left, font_size: 12.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        metaStack.addArrangedSubview(nameLabel)
        metaStack.addArrangedSubview(priceLabel)
        serviceStack.addArrangedSubview(metaStack)
        serviceStack.addArrangedSubview(dueLabel)
        
        contentView.addSubview(serviceStack)
        serviceStack.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
