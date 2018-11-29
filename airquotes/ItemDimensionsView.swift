//
//  ItemDimensionsView.swift
//  airquotes
//
//  Created by Jun Tan on 11/24/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class ItemDimensionsView: UIView {
    var shouldSetupConstraints = true
    
    // stack views
    lazy var itemDimensionsStackView = DefaultStackView(spacing: 2.5, axis: .vertical)
    lazy var dimensionStackView = DefaultStackView(spacing: 5.0, axis: .horizontal)
    lazy var dimensionLabelStackView = DefaultStackView(spacing: 0.0, axis: .vertical)
    
    // labels
    lazy var dimensionLabel = SmallLabel(text: "", alignment: .left, font_size: 16.0)
    lazy var dimensionValueLabel = SmallLabel(text: "-", alignment: .left, font_size: 20.0)
    
    func setLabel(dimension: String, value: String) {
        dimensionLabel.text = dimension
        dimensionValueLabel.text = value
    }
    
    // direction label
    lazy var directionLabel: SmallLabel = {
        let label = SmallLabel(text: "Tap to start measuring", alignment: .center, font_size: 14.0)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()
    
    // button
    lazy var nextMeasurementButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        
        button.backgroundColor = UIColor.clear
        
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 15.0
        
        return button
    }()
    
    lazy var prevMeasurementButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        
        button.backgroundColor = UIColor.clear
        
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 15.0
        
        return button
    }()
    
    lazy var getPriceButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        
        button.backgroundColor = UIColor(hue: 44/360, saturation: 0.93, brightness: 1.0, alpha: 1.0)
        
        button.setTitle("Get Shipping Quote", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        button.layer.cornerRadius = 15.0
        
        return button
    }()
    
    func setupStackView() {
        dimensionLabelStackView.addArrangedSubview(dimensionLabel)
        dimensionLabelStackView.addArrangedSubview(dimensionValueLabel)
        
        dimensionStackView.addArrangedSubview(dimensionLabelStackView)
        
        itemDimensionsStackView.addArrangedSubview(dimensionStackView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        
        setupStackView()
        setLabel(dimension: "LENGTH", value: "-")
        
        self.addSubview(itemDimensionsStackView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            itemDimensionsStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0))
            dimensionStackView.setCustomSpacing(20.0, after: dimensionLabelStackView)
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
