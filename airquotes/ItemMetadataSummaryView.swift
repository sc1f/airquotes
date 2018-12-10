//
//  ItemMetadataSummaryView.swift
//  airquotes
//
//  Created by Jun Tan on 11/24/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ItemMetadataSummaryView: UIView {
    var shouldSetupConstraints = true
    
    var currentItem: Item?
    
    // Stack Views
    lazy var metadataSummaryStackView = DefaultStackView(spacing: 10.0, axis: .vertical)
    lazy var fromStackView = DefaultStackView(spacing: 0.0, axis: .horizontal)
    lazy var destinationStackView = DefaultStackView(spacing: 0.0, axis: .horizontal)
    lazy var weightStackView = DefaultStackView(spacing: 0.0, axis: .horizontal)
    
    // Value Labels
    // TODO: NSManagedObject
    lazy var fromValueLabel = SmallLabel(text: currentItem!.from ?? "", alignment: .right, font_size: 14.0)
    lazy var destinationValueLabel = SmallLabel(text: currentItem!.destination ?? "", alignment: .right, font_size: 14.0)
    lazy var weightValueLabel = SmallLabel(text: currentItem!.weight ?? "", alignment: .right, font_size: 14.0)
    
    // Helper Labels
    lazy var fromLabel = SmallLabel(text: "FROM", alignment: .left, font_size: 14.0)
    lazy var destinationLabel = SmallLabel(text: "DESTINATION", alignment: .left, font_size: 14.0)
    lazy var weightLabel = SmallLabel(text: "WEIGHT", alignment: .left, font_size: 14.0)

    required init(currentItem: Item) {
        super.init(frame: CGRect.zero)
        
        self.currentItem = currentItem
    
        self.backgroundColor = UIColor.white
        
        self.fromLabel.textColor = UIColor.gray
        self.destinationLabel.textColor = UIColor.gray
        self.weightLabel.textColor = UIColor.gray
        
        self.addSubview(metadataSummaryStackView)
        
        metadataSummaryStackView.distribution = .fill
        
        fromStackView.addArrangedSubview(fromLabel)
        fromStackView.addArrangedSubview(fromValueLabel)
        
        destinationStackView.addArrangedSubview(destinationLabel)
        destinationStackView.addArrangedSubview(destinationValueLabel)
        
        weightStackView.addArrangedSubview(weightLabel)
        weightStackView.addArrangedSubview(weightValueLabel)
        
        metadataSummaryStackView.addArrangedSubview(fromStackView)
        metadataSummaryStackView.addArrangedSubview(destinationStackView)
        metadataSummaryStackView.addArrangedSubview(weightStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addBottomBorder() {
        let border = CALayer()
        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: 1.0)
        self.layer.addSublayer(border)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            metadataSummaryStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0))
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
