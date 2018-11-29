//
//  NodeSet.swift
//  airquotes
//
//  Created by Jun Tan on 11/28/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit
import SceneKit

class NodeSet {
    public var first: SphereNode?
    public var last: SphereNode?
    public var line: SCNNode?
    
    public func clear() {
        self.first = nil
        self.last = nil
        self.line = nil
    }
}
