//
//  ItemMetadataView.swift
//  airquotes
//
//  Created by Jun Tan on 11/23/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit
import PureLayout

class ItemMetadataView: UIView {
    
    var defaultInstructionText = "Enter your item details to begin"
    var shouldSetupConstraints = true
    var currentItem: Item?
    
    var logoImage: UIImageView = {
        let image = UIImageView(frame: CGRect.zero)
        image.image = UIImage.init(named: "Boxwhite50")
        return image
    }()
    
    var metadataStackView = DefaultStackView(spacing: 5.0, axis: .vertical)
    
    var destinationTextField: UITextFieldPadded = {
        let textField = UITextFieldPadded(frame: CGRect.zero)
        
        textField.attributedPlaceholder = NSAttributedString(string: "Enter a ZIP code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        textField.keyboardType = UIKeyboardType.numberPad
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always
        
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 20.0)
        
        textField.clearsOnBeginEditing = true
        textField.setBottomBorder()
        
        return textField
    }()
    
    var weightTextField: UITextFieldPadded = {
        let textField = UITextFieldPadded(frame: CGRect.zero)
        
        textField.attributedPlaceholder = NSAttributedString(string: "Estimated Weight (lbs)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always
        
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 20.0)
        
        textField.clearsOnBeginEditing = true
        textField.setBottomBorder()
        
        textField.addTarget(self, action: #selector(weightTextFieldAddIndicator(_:)), for: UIControl.Event.editingDidEnd)
        
        return textField
    }()
    
    @objc func weightTextFieldAddIndicator(_ textField: UITextField) {
        let text = textField.text!
        if (text.count > 0 && text.range(of: "lb") == nil) {
            textField.text = textField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces) + " lb"
        }
    }
    
    func processErrors(_ message: String) {
        errorLabel.text = message
        metadataStackView.addArrangedSubview(errorLabel)
        metadataStackView.setCustomSpacing(10.0, after: weightTextField)
    }
    
    func clearErrors() {
        errorLabel.text = ""
        errorLabel.removeFromSuperview()
    }
    
    var destinationLabel = SmallLabel(text: "DESTINATION", alignment: .left, font_size: 12.0)
    var weightLabel = SmallLabel(text: "WEIGHT", alignment: .left, font_size: 12.0)
    var helpLabel = SmallLabel(text: "", alignment: .center, font_size: 14.0)
    var errorLabel = SmallLabel(text: "", alignment: .center, font_size: 14.0)
    
    let screenSize = UIScreen.main.bounds
    
    required init(currentItem: Item) {
        super.init(frame: CGRect.zero)
        
        self.currentItem = currentItem
        helpLabel.text = defaultInstructionText
        
        if currentItem.destination != "" && currentItem.weight != "" {
            destinationTextField.text = currentItem.destination
            weightTextField.text = currentItem.weight
        }
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 2.0
        
        self.addSubview(logoImage)
        
        destinationLabel.textColor = UIColor.gray
        weightLabel.textColor = UIColor.gray
        errorLabel.textColor = UIColor.red
        
        metadataStackView.addArrangedSubview(helpLabel)
        metadataStackView.addArrangedSubview(destinationLabel)
        metadataStackView.addArrangedSubview(destinationTextField)
        metadataStackView.addArrangedSubview(weightLabel)
        metadataStackView.addArrangedSubview(weightTextField)
        
        metadataStackView.setCustomSpacing(0.0, after: destinationLabel)
        metadataStackView.setCustomSpacing(0.0, after: weightLabel)
        
        self.addSubview(metadataStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            logoImage.autoAlignAxis(toSuperviewAxis: .vertical)
            logoImage.autoPinEdge(toSuperviewEdge: .top, withInset: 20.0)
            metadataStackView.autoPinEdge(.top, to: .bottom, of: logoImage, withOffset: 10.0)
            metadataStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0), excludingEdge: .top)
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
