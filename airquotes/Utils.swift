//
//  Utils.swift
//  airquotes
//
//  Created by Jun Tan on 11/15/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class Utils {
    public static func setRoundedCorners(_ views: [UIView]) {
        for view in views {
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
        }
    }
}
