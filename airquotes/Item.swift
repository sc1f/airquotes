//
//  Item.swift
//  airquotes
//
//  Created by Jun Tan on 11/15/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class Item {
    var weight: Float
    var location: Location?
    var quote: Quote?
    
    init(weight: Float) {
        self.weight = weight
    }
}
