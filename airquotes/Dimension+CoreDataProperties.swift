//
//  Dimension+CoreDataProperties.swift
//  airquotes
//
//  Created by Jun Tan on 12/9/18.
//  Copyright © 2018 group19. All rights reserved.
//
//

import Foundation
import CoreData


extension Dimension {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dimension> {
        return NSFetchRequest<Dimension>(entityName: "Dimension")
    }

    @NSManaged public var height: Float
    @NSManaged public var length: Float
    @NSManaged public var width: Float
    @NSManaged public var item: Item?

}
