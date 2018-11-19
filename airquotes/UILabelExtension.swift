//
//  UILabelExtension.swift
//  airquotes
//
//  Created by Jun Tan on 11/15/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

extension UILabel {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textColor = UIColor.gray
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        textColor = UIColor.white
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        textColor = UIColor.white
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textColor = UIColor.white
    }
}
