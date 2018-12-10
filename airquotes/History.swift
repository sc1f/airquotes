//
//  Hamburger.swift
//  airquotes
//
//  Created by Jun Tan on 12/8/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class History: UIView {
    var color: UIColor = UIColor.black
    
    required init(color: UIColor) {
        super.init(frame: CGRect.zero)
        self.color = color
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ring = UIBezierPath()
        ring.move(to: CGPoint(x: 10.88, y: 18))
        ring.addCurve(to: CGPoint(x: 9.57, y: 17.76), controlPoint1: CGPoint(x: 10.44, y: 17.92), controlPoint2: CGPoint(x: 10, y: 17.86))
        ring.addCurve(to: CGPoint(x: 5.54, y: 15.47), controlPoint1: CGPoint(x: 8.02, y: 17.38), controlPoint2: CGPoint(x: 6.68, y: 16.61))
        ring.addCurve(to: CGPoint(x: 5.46, y: 15.39), controlPoint1: CGPoint(x: 5.5, y: 15.44), controlPoint2: CGPoint(x: 5.48, y: 15.41))
        ring.addCurve(to: CGPoint(x: 6.82, y: 13.98), controlPoint1: CGPoint(x: 5.91, y: 14.92), controlPoint2: CGPoint(x: 6.36, y: 14.46))
        ring.addCurve(to: CGPoint(x: 12.12, y: 15.97), controlPoint1: CGPoint(x: 8.29, y: 15.43), controlPoint2: CGPoint(x: 10.06, y: 16.13))
        ring.addCurve(to: CGPoint(x: 16.31, y: 13.99), controlPoint1: CGPoint(x: 13.74, y: 15.84), controlPoint2: CGPoint(x: 15.14, y: 15.16))
        ring.addCurve(to: CGPoint(x: 17.32, y: 5.32), controlPoint1: CGPoint(x: 18.55, y: 11.72), controlPoint2: CGPoint(x: 18.98, y: 8.07))
        ring.addCurve(to: CGPoint(x: 9.29, y: 2.41), controlPoint1: CGPoint(x: 15.61, y: 2.5), controlPoint2: CGPoint(x: 12.3, y: 1.29))
        ring.addCurve(to: CGPoint(x: 4.83, y: 9), controlPoint1: CGPoint(x: 6.21, y: 3.56), controlPoint2: CGPoint(x: 4.76, y: 6.57))
        ring.addLine(to: CGPoint(x: 7.65, y: 9))
        ring.addCurve(to: CGPoint(x: 7.7, y: 9.07), controlPoint1: CGPoint(x: 7.67, y: 9.02), controlPoint2: CGPoint(x: 7.68, y: 9.05))
        ring.addCurve(to: CGPoint(x: 3.81, y: 13.02), controlPoint1: CGPoint(x: 6.41, y: 10.38), controlPoint2: CGPoint(x: 5.12, y: 11.7))
        ring.addCurve(to: CGPoint(x: 0, y: 9.08), controlPoint1: CGPoint(x: 2.54, y: 11.71), controlPoint2: CGPoint(x: 1.27, y: 10.4))
        ring.addCurve(to: CGPoint(x: 0.04, y: 9.02), controlPoint1: CGPoint(x: 0.01, y: 9.06), controlPoint2: CGPoint(x: 0.02, y: 9.04))
        ring.addLine(to: CGPoint(x: 2.85, y: 9.02))
        ring.addCurve(to: CGPoint(x: 2.96, y: 7.83), controlPoint1: CGPoint(x: 2.89, y: 8.6), controlPoint2: CGPoint(x: 2.91, y: 8.22))
        ring.addCurve(to: CGPoint(x: 5.78, y: 2.29), controlPoint1: CGPoint(x: 3.24, y: 5.63), controlPoint2: CGPoint(x: 4.18, y: 3.77))
        ring.addCurve(to: CGPoint(x: 10.77, y: 0.04), controlPoint1: CGPoint(x: 7.2, y: 0.97), controlPoint2: CGPoint(x: 8.87, y: 0.22))
        ring.addCurve(to: CGPoint(x: 10.92, y: 0), controlPoint1: CGPoint(x: 10.82, y: 0.04), controlPoint2: CGPoint(x: 10.87, y: 0.01))
        ring.addLine(to: CGPoint(x: 12.23, y: 0))
        ring.addCurve(to: CGPoint(x: 13.1, y: 0.14), controlPoint1: CGPoint(x: 12.52, y: 0.05), controlPoint2: CGPoint(x: 12.81, y: 0.09))
        ring.addCurve(to: CGPoint(x: 20.02, y: 6.88), controlPoint1: CGPoint(x: 16.4, y: 0.69), controlPoint2: CGPoint(x: 19.29, y: 3.5))
        ring.addCurve(to: CGPoint(x: 20.25, y: 8.11), controlPoint1: CGPoint(x: 20.1, y: 7.29), controlPoint2: CGPoint(x: 20.17, y: 7.7))
        ring.addLine(to: CGPoint(x: 20.25, y: 9.89))
        ring.addCurve(to: CGPoint(x: 20.12, y: 10.62), controlPoint1: CGPoint(x: 20.2, y: 10.13), controlPoint2: CGPoint(x: 20.16, y: 10.38))
        ring.addCurve(to: CGPoint(x: 13.3, y: 17.82), controlPoint1: CGPoint(x: 19.47, y: 14.24), controlPoint2: CGPoint(x: 16.79, y: 17.08))
        ring.addCurve(to: CGPoint(x: 12.23, y: 18), controlPoint1: CGPoint(x: 12.95, y: 17.89), controlPoint2: CGPoint(x: 12.59, y: 17.94))
        ring.addLine(to: CGPoint(x: 10.88, y: 18))
        ring.close()
        self.color.setFill()
        ring.fill()
        
        let hands = UIBezierPath()
        hands.move(to: CGPoint(x: 15.43, y: 11.33))
        hands.addCurve(to: CGPoint(x: 14.74, y: 12.53), controlPoint1: CGPoint(x: 15.2, y: 11.74), controlPoint2: CGPoint(x: 14.97, y: 12.13))
        hands.addCurve(to: CGPoint(x: 14.58, y: 12.44), controlPoint1: CGPoint(x: 14.68, y: 12.5), controlPoint2: CGPoint(x: 14.63, y: 12.47))
        hands.addCurve(to: CGPoint(x: 10.77, y: 10.1), controlPoint1: CGPoint(x: 13.31, y: 11.66), controlPoint2: CGPoint(x: 12.04, y: 10.88))
        hands.addCurve(to: CGPoint(x: 10.61, y: 9.86), controlPoint1: CGPoint(x: 10.7, y: 10.05), controlPoint2: CGPoint(x: 10.61, y: 9.94))
        hands.addCurve(to: CGPoint(x: 10.61, y: 5.11), controlPoint1: CGPoint(x: 10.6, y: 8.28), controlPoint2: CGPoint(x: 10.61, y: 6.69))
        hands.addCurve(to: CGPoint(x: 10.62, y: 5.02), controlPoint1: CGPoint(x: 10.61, y: 5.08), controlPoint2: CGPoint(x: 10.61, y: 5.06))
        hands.addLine(to: CGPoint(x: 12.05, y: 5.02))
        hands.addLine(to: CGPoint(x: 12.05, y: 5.28))
        hands.addCurve(to: CGPoint(x: 12.05, y: 9), controlPoint1: CGPoint(x: 12.05, y: 6.52), controlPoint2: CGPoint(x: 12.06, y: 7.76))
        hands.addCurve(to: CGPoint(x: 12.26, y: 9.38), controlPoint1: CGPoint(x: 12.04, y: 9.19), controlPoint2: CGPoint(x: 12.11, y: 9.29))
        hands.addCurve(to: CGPoint(x: 15.18, y: 11.17), controlPoint1: CGPoint(x: 13.24, y: 9.97), controlPoint2: CGPoint(x: 14.21, y: 10.57))
        hands.addCurve(to: CGPoint(x: 15.43, y: 11.33), controlPoint1: CGPoint(x: 15.26, y: 11.21), controlPoint2: CGPoint(x: 15.33, y: 11.26))
        hands.close()
        self.color.setFill()
        hands.fill()
    }
}
