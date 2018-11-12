//
//  ViewController.swift
//  airquotes
//
//  Created by Jun Tan on 11/7/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var MeasureStatusTextView: UITextView!
    @IBOutlet weak var MeasureSceneView: ARSCNView!
    
    var box: Box!
    
    var status: String!
    
    var startPosition: SCNVector3!
    
    var distance: Float!
    
    var trackingState: ARCamera.TrackingState!
    
    enum Mode {
        
        case waitingForMeasuring
        
        case measuring
        
    }
    
    var mode: Mode = .waitingForMeasuring {
        didSet {
            switch mode {
            case .waitingForMeasuring:
                status = "NOT READY"
            case .measuring:
                box.update(
                    minExtents: SCNVector3Zero, maxExtents: SCNVector3Zero)
                box.isHidden = false
                startPosition = nil
                distance = 0.0
                setStatusText()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MeasureSceneView.delegate = self
        MeasureStatusTextView.textContainerInset = UIEdgeInsetsMake(20.0, 10.0, 10.0, 0.0)
        
        box = Box()
        box.isHidden = true
        MeasureSceneView.scene.rootNode.addChildNode(box)
        
        mode = .waitingForMeasuring
        distance = 0.0
        setStatusText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        MeasureSceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MeasureSceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func MeasureSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            mode = .measuring
        } else {
            mode = .waitingForMeasuring
        }
    }
    
    // Mark: SceneKit
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        trackingState = camera.trackingState
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.measureBox()
        }
    }
    
    // Mark: Measurement Logic
    func measureBox() {
        let screenCenter: CGPoint = CGPoint(x: self.MeasureSceneView.bounds.midX, y: self.MeasureStatusTextView.bounds.midY)
        let planeTestResults = MeasureSceneView.hitTest(screenCenter, types: [.existingPlaneUsingExtent])
        
        if let result = planeTestResults.first {
            status = "ready"
            
            if mode == .measuring {
                status = "measuring"
                let worldPosition = SCNVector3Make(
                    result.worldTransform.columns.3.x,
                    result.worldTransform.columns.3.y,
                    result.worldTransform.columns.3.z
                )
                
                if startPosition == nil {
                    startPosition = worldPosition
                    box.position = worldPosition
                }
                
                distance = calculateDistance(
                    from: startPosition!, to: worldPosition
                )
                
                box.resizeTo(extent: distance)
                
                let angleInRadians = calculateAngleInRadians(
                    from: startPosition!, to: worldPosition
                )
                
                box.rotation = SCNVector4(x: 0, y: 1, z: 0,
                                          w: -(angleInRadians + Float.pi)
                )
                
            }
        } else {
            status = "not ready"
        }
    }
    
    func calculateDistance(from: SCNVector3, to: SCNVector3) -> Float {
        let x = from.x - to.x
        let y = from.y - to.y
        let z = from.z - to.z
        
        return sqrtf((x*x) + (y*y) + (z*z))
    }
    
    func calculateAngleInRadians(from: SCNVector3, to: SCNVector3) -> Float {
        let x = from.x - to.x
        let z = from.z - to.z
        return atan2(z, x)
    }
    
    // MARK: measurement UI
    func setStatusText() {
        var text = "Status: \(status!)\n"
        text += "Tracking: \(getTrackingDescription())\n"
        text += "Distance: \(String(format:"%.2f cm", distance! * 100.0))"
        MeasureStatusTextView.text = text
    }
    
    func getTrackingDescription() -> String {
        var description = ""
        if let t = trackingState {
            switch(t) {
            case .notAvailable:
                description = "TRACKING UNAVAILABLE"
            case .normal:
                description = "TRACKING NORMAL"
            case .limited(let reason):
                switch reason {
                    case .excessiveMotion:
                        description = "TRACKING LIMITED - Too much camera movement"
                    case .insufficientFeatures:
                        description = "TRACKING LIMITED - Not enough surface detail"
                    case .initializing:
                        description = "INITIALIZING"
                    case .relocalizing:
                        description = "RELOCALIZING"
                }
            }
        }
        return description
        
    }
}
