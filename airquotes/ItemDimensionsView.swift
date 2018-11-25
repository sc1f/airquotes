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
    lazy var itemDimensionsStackView = ContainerStackView(spacing: 2.5)
    lazy var lengthStackView = RowStackView(spacing: 0.0)
    lazy var widthStackView = RowStackView(spacing: 0.0)
    lazy var heightStackView = RowStackView(spacing: 0.0)
    
    // helper labels
    lazy var lengthLabel = SmallLabel(text: "LENGTH", alignment: .left, font_size: 16.0)
    lazy var widthLabel = SmallLabel(text: "WIDTH", alignment: .left, font_size: 16.0)
    lazy var heightLabel = SmallLabel(text: "HEIGHT", alignment: .left, font_size: 16.0)
    
    // value labels
    lazy var lengthValueLabel = SmallLabel(text: "-", alignment: .right, font_size: 20.0)
    lazy var widthValueLabel = SmallLabel(text: "-", alignment: .right, font_size: 20.0)
    lazy var heightValueLabel = SmallLabel(text: "-", alignment: .right, font_size: 20.0)
    
    // direction label
    lazy var directionLabel = SmallLabel(text: "Tap to start measuring", alignment: .center, font_size: 14.0)
    
    // button
    lazy var getPriceButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = UIColor(hue: 44/360, saturation: 0.93, brightness: 1.0, alpha: 1.0)
        
        button.setTitle("Get Shipping Quote", for: .normal)
        button.titleLabel!.textColor = UIColor.white
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        button.layer.cornerRadius = 5.0
        
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 2.0
        
        lengthLabel.textColor = UIColor.gray
        widthLabel.textColor = UIColor.gray
        heightLabel.textColor = UIColor.gray
        
        directionLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        lengthStackView.addArrangedSubview(lengthLabel)
        lengthStackView.addArrangedSubview(lengthValueLabel)
        
        widthStackView.addArrangedSubview(widthLabel)
        widthStackView.addArrangedSubview(widthValueLabel)
        
        heightStackView.addArrangedSubview(heightLabel)
        heightStackView.addArrangedSubview(heightValueLabel)
        
        itemDimensionsStackView.addArrangedSubview(directionLabel)
        itemDimensionsStackView.addArrangedSubview(lengthStackView)
        itemDimensionsStackView.addArrangedSubview(widthStackView)
        itemDimensionsStackView.addArrangedSubview(heightStackView)
        itemDimensionsStackView.addArrangedSubview(getPriceButton)
        
        itemDimensionsStackView.setCustomSpacing(5.0, after: directionLabel)
        itemDimensionsStackView.setCustomSpacing(20.0, after: heightStackView)
        
        self.addSubview(itemDimensionsStackView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            itemDimensionsStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0))
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
