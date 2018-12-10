//
//  Item+CoreDataProperties.swift
//  airquotes
//
//  Created by Jun Tan on 12/9/18.
//  Copyright © 2018 group19. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var destination: String?
    @NSManaged public var from: String?
    @NSManaged public var weight: String?
    @NSManaged public var dimension: Dimension?

}
