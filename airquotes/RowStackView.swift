//
//  RowStackView.swift
//  airquotes
//
//  Created by Jun Tan on 11/24/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class RowStackView: UIStackView {

    required init(spacing: CGFloat) {
        super.init(frame: CGRect.zero)
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

}
