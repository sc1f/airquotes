//
//  SmallLabel.swift
//  airquotes
//
//  Created by Jun Tan on 11/24/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class SmallLabel: UILabel {

    required init(text: String, alignment: NSTextAlignment, font_size: CGFloat) {
        super.init(frame: CGRect.zero)
        self.text = text
        self.textAlignment = alignment
        self.textColor = UIColor.black
        self.font = UIFont.systemFont(ofSize: font_size, weight: .bold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
