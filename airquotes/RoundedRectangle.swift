//
//  RoundedRectangle.swift
//  airquotes
//
//  Created by Jun Tan on 11/19/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedRectangle: UIView {
    @IBInspectable var fillColor: UIColor = UIColor.lightGray
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0).cgPath
        
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.addPath(clipPath)
        ctx.setFillColor(fillColor.cgColor)
        
        ctx.closePath()
        ctx.fillPath()
    }
}
