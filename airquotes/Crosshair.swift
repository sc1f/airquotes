//
//  Crosshair.swift
//  airquotes
//
//  Created by Jun Tan on 11/24/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class Crosshair: UIView {
    let fillColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        //let centerX: CGFloat = bounds.width / 2
        //let centerY: CGFloat = bounds.height / 2
        
        let dot = UIBezierPath.init(ovalIn: rect)
        fillColor.setFill()
        dot.fill()
    }

}
