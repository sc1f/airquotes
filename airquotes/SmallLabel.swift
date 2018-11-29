//
//  SmallLabel.swift
//  airquotes
//
//  Created by Jun Tan on 11/24/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class SmallLabel: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    required init(text: String, alignment: NSTextAlignment, font_size: CGFloat, insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)) {
        super.init(frame: CGRect.zero)
        self.text = text
        self.textAlignment = alignment
        self.textColor = UIColor.black
        self.font = UIFont.systemFont(ofSize: font_size, weight: .bold)
        textInsets = insets
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
