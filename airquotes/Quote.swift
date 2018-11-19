//
//  Quote.swift
//  airquotes
//
//  Created by Jun Tan on 11/15/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

class Quote {
    var item: Item
    var location: Location
    var company: String
    var service: String
    var due_date: String
    var price: Float
    
    init(item: Item, location: Location, company: String, service: String, due_date: String, price: Float) {
        self.item = item
        self.location = location
        self.company = company
        self.service = service
        self.due_date = due_date
        self.price = price
    }
}
