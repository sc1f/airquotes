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
    
    var logoImage: UIImageView = {
        let image = UIImageView(frame: CGRect.zero)
        image.image = UIImage.init(named: "Boxwhite25")
        return image
    }()
    
    // Stack Views
    lazy var metadataSummaryStackView = ContainerStackView(spacing: 5.0)
    lazy var destinationStackView = RowStackView(spacing: 0.0)
    lazy var weightStackView = RowStackView(spacing: 0.0)
    
    // Value Labels
    lazy var destinationValueLabel = SmallLabel(text: currentItem!.destination, alignment: .right, font_size: 14.0)
    lazy var weightValueLabel = SmallLabel(text: currentItem!.weight, alignment: .right, font_size: 14.0)
    
    // Helper Labels
    lazy var destinationLabel = SmallLabel(text: "DESTINATION", alignment: .left, font_size: 14.0)
    lazy var weightLabel = SmallLabel(text: "WEIGHT", alignment: .left, font_size: 14.0)

    required init(currentItem: Item) {
        super.init(frame: CGRect.zero)
        
        self.currentItem = currentItem
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 2.0
        
        self.destinationLabel.textColor = UIColor.gray
        self.weightLabel.textColor = UIColor.gray
        
        self.addSubview(logoImage)
        
        self.addSubview(metadataSummaryStackView)
        
        destinationStackView.addArrangedSubview(destinationLabel)
        destinationStackView.addArrangedSubview(destinationValueLabel)
        
        weightStackView.addArrangedSubview(weightLabel)
        weightStackView.addArrangedSubview(weightValueLabel)
        
        metadataSummaryStackView.addArrangedSubview(destinationStackView)
        metadataSummaryStackView.addArrangedSubview(weightStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            logoImage.autoAlignAxis(toSuperviewAxis: .vertical)
            logoImage.autoPinEdge(toSuperviewEdge: .top, withInset: 20.0)
            metadataSummaryStackView.autoPinEdge(.top, to: .bottom, of: logoImage, withOffset: 10.0)
            metadataSummaryStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), excludingEdge: .top)
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
