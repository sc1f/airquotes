//
//  Item.swift
//  airquotes
//
//  Created by Jun Tan on 11/15/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

struct Dimensions: Codable {
    var length: CGFloat
    var width: CGFloat
    var height: CGFloat
}

class Item: Codable {
    // TODO: store weight as float and compute string property from it
    var from: String
    var weight: String
    var destination: String
    var dimensions: Dimensions
    
    init(from: String, destination: String, weight: String) {
        self.from = from
        self.destination = destination
        self.weight = weight
        self.dimensions = Dimensions(length: 0, width: 0, height: 0)
    }
    
}
