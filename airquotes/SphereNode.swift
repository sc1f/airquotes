//
//  SphereNode.swift
//  airquotes
//
//  Created by Jun Tan on 11/14/18.
//  Copyright © 2018 group19. All rights reserved.
//

import SceneKit

class SphereNode: SCNNode {
    init(position: SCNVector3) {
        super.init()
        let sphereGeometry = SCNSphere(radius: 0.075)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.lightingModel = .constant
        sphereGeometry.materials = [material]
        
        self.geometry = sphereGeometry
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func distance(to destination: SCNVector3) -> CGFloat {
        let dx = destination.x - self.position.x
        let dy = destination.y - self.position.y
        let dz = destination.z - self.position.z
        let meters = sqrt(dx*dx + dy*dy + dz*dz)
        let inches: Float = 39.3701
        return CGFloat(meters * inches)
    }
    
    static func positionFrom(matrix: matrix_float4x4) -> SCNVector3 {
        let column = matrix.columns.3
        return SCNVector3(column.x, column.y, column.z)
    }
    
    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    func drawLine(to toNode: SCNNode) -> SCNNode {
        let line = lineFrom(vector: self.position, toVector: toNode.position)
        let lineNode = SCNNode(geometry: line)
        
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.white
        line.materials = [planeMaterial]
        
        return lineNode
    }
    
    
}
