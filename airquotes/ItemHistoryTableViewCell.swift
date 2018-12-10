//
//  ItemHistoryTableViewCell.swift
//  airquotes
//
//  Created by Jun Tan on 12/9/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ItemHistoryTableViewCell: UITableViewCell {
    var currentItem: Item?
    
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
        
        let lengthValueLabel = SmallLabel(text: String(format: "%.2f\"", currentItem!.dimension!.length), alignment: .center, font_size: 14.0)
        let widthValueLabel = SmallLabel(text: String(format: "%.2f\"", currentItem!.dimension!.width), alignment: .center, font_size: 14.0)
        let heightValueLabel = SmallLabel(text: String(format: "%.2f\"", currentItem!.dimension!.height), alignment: .center, font_size: 14.0)
        
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        let metadataSummaryView = ItemMetadataSummaryView(currentItem: self.currentItem!)
        
        metadataSummaryView.metadataSummaryStackView.addArrangedSubview(self.dimensionSummaryView)
        
        contentView.addSubview(metadataSummaryView)
        metadataSummaryView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), excludingEdge: .bottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
