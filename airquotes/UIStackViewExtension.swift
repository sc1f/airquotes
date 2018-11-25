//
//  UIStackViewExtension.swift
//  airquotes
//
//  Created by Jun Tan on 11/24/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
