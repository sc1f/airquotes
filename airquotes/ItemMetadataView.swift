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
    // TODO: NSManagedObject
    var currentItem: Item?
    
    var historyButton = History(color: UIColor.black)
    
    var logoImage: UIImageView = {
        let image = UIImageView(frame: CGRect.zero)
        image.image = UIImage.init(named: "Boxwhite25")
        return image
    }()
    
    var metadataStackView = DefaultStackView(spacing: 5.0, axis: .vertical)
    var locationStackView = DefaultStackView(spacing: 20.0, axis: .horizontal)
    var fromStackView = DefaultStackView(spacing: 0.0, axis: .vertical)
    var destinationStackView = DefaultStackView(spacing: 0.0, axis: .vertical)
    
    var fromTextField: UITextFieldPadded = {
        let textField = UITextFieldPadded(frame: CGRect.zero)
        
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        textField.keyboardType = UIKeyboardType.numberPad
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always
        
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 16.0)
        
        textField.clearsOnBeginEditing = true
        textField.setBottomBorder()
        
        return textField
    }()
    
    var destinationTextField: UITextFieldPadded = {
        let textField = UITextFieldPadded(frame: CGRect.zero)
        
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        textField.keyboardType = UIKeyboardType.numberPad
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always
        
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 16.0)
        
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
        textField.font = UIFont.systemFont(ofSize: 16.0)
        
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
    
    var fromLabel = SmallLabel(text: "FROM ZIP", alignment: .left, font_size: 12.0)
    var destinationLabel = SmallLabel(text: "DESTINATION ZIP", alignment: .left, font_size: 12.0)
    var weightLabel = SmallLabel(text: "WEIGHT", alignment: .left, font_size: 12.0)
    
    var helpLabel = SmallLabel(text: "", alignment: .center, font_size: 12.0)
    var errorLabel = SmallLabel(text: "", alignment: .center, font_size: 14.0)
    
    let screenSize = UIScreen.main.bounds
    
    required init(currentItem: Item) {
        super.init(frame: CGRect.zero)
        
        self.currentItem = currentItem
        helpLabel.text = defaultInstructionText
        
        if currentItem.destination != "" {
            destinationTextField.text = currentItem.destination
        }
        
        if currentItem.weight != "" {
            weightTextField.text = currentItem.weight
        }
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(historyButton)
        
        self.addSubview(logoImage)
        
        fromLabel.textColor = UIColor.gray
        destinationLabel.textColor = UIColor.gray
        weightLabel.textColor = UIColor.gray
        errorLabel.textColor = UIColor.red
        
        fromStackView.distribution = .fill
        destinationStackView.distribution = .fill
        
        fromStackView.addArrangedSubview(fromLabel)
        fromStackView.addArrangedSubview(fromTextField)
        
        fromStackView.setCustomSpacing(10.0, after: fromLabel)
        
        destinationStackView.addArrangedSubview(destinationLabel)
        destinationStackView.addArrangedSubview(destinationTextField)
        
        destinationStackView.setCustomSpacing(10.0, after: destinationLabel)
        
        locationStackView.addArrangedSubview(fromStackView)
        locationStackView.addArrangedSubview(destinationStackView)
        
        metadataStackView.distribution = .fill
        metadataStackView.addArrangedSubview(helpLabel)
        metadataStackView.addArrangedSubview(locationStackView)
        metadataStackView.addArrangedSubview(weightLabel)
        metadataStackView.addArrangedSubview(weightTextField)
        
        metadataStackView.setCustomSpacing(20.0, after: helpLabel)
        metadataStackView.setCustomSpacing(10.0, after: weightLabel)
        metadataStackView.setCustomSpacing(20.0, after: locationStackView)
        
        self.addSubview(metadataStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            historyButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 20.0)
            historyButton.autoPinEdge(toSuperviewEdge: .top, withInset: 50.0)
            historyButton.autoSetDimensions(to: CGSize.init(width: 20.0, height: 18.0))
            
            logoImage.autoAlignAxis(toSuperviewAxis: .vertical)
            logoImage.autoPinEdge(toSuperviewEdge: .top, withInset: 40.0)
            
            metadataStackView.autoPinEdge(.top, to: .bottom, of: logoImage, withOffset: 10.0)
            metadataStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0), excludingEdge: .top)
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
