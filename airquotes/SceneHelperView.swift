//
//  SceneHelperView.swift
//  airquotes
//
//  Created by Jun Tan on 11/28/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class SceneHelperView: UIView {
    
    required init(text: String, image: String = "") {
        super.init(frame: CGRect.zero)
        var img: UIImageView?
        
        if image != "" {
            img = UIImageView(image: UIImage(named: image))
            self.addSubview(img!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
