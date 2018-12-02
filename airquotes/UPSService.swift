//
//  UPSService.swift
//  airquotes
//
//  Created by Jun Tan on 11/30/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit

struct UPSDue: Codable {
    let date: String
    let time: String
}

struct UPSService: Codable {
    let name: String
    let charge: String
    let due: UPSDue
    let transit_time: String
}
