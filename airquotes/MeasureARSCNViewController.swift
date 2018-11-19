//
//  MeasureARSCNViewController.swift
//  airquotes
//
//  Created by Jun Tan on 11/7/18.
//  Copyright © 2018 group19. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MeasureARSCNViewController: UIViewController, UITextFieldDelegate, ARSCNViewDelegate {
    
    var lengthNodes: [SphereNode] = []
    var widthNodes: [SphereNode] = []
    var heightNodes: [SphereNode] = []
    var selectedNodes: [SphereNode]?
    
    enum measurementValues {
        case length(CGFloat)
        case width(CGFloat)
        case height(CGFloat)
    }
    
    var selectedMeasuremement: UILabel?
    var selectedMeasurementValue: String?
    
    @IBOutlet weak var MeasureSceneView: ARSCNView!
    @IBOutlet weak var MeasureUILabel: UILabel!
    
    // Metadata View
    @IBOutlet weak var MetadataView: UIView!
    
    // Information View
    @IBOutlet weak var InformationView: UIView!
    
    // Item Dimensions
    @IBOutlet weak var ItemLengthUILabel: UILabel!
    @IBOutlet weak var ItemWidthUILabel: UILabel!
    @IBOutlet weak var ItemHeightUILabel: UILabel!
    
    // MARK: UI actions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setLabelWeight() {
        selectedMeasuremement!.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
    }
    
    func setUpTapRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSceneViewTap))
        tapRecognizer.numberOfTapsRequired = 1
        MeasureSceneView.addGestureRecognizer(tapRecognizer)
        
        let lengthTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLengthUILabelTap))
        lengthTapRecognizer.numberOfTapsRequired = 1
        ItemLengthUILabel.addGestureRecognizer(lengthTapRecognizer)
        
        let widthTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleWidthUILabelTap))
        widthTapRecognizer.numberOfTapsRequired = 1
        ItemWidthUILabel.addGestureRecognizer(widthTapRecognizer)
        
        let heightTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleHeightUILabelTap))
        heightTapRecognizer.numberOfTapsRequired = 1
        ItemHeightUILabel.addGestureRecognizer(heightTapRecognizer)
    }

    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // labels
        ItemLengthUILabel.isUserInteractionEnabled = true
        ItemWidthUILabel.isUserInteractionEnabled = true
        ItemHeightUILabel.isUserInteractionEnabled = true
    
        // tap setup
        setUpTapRecognizers()
        
        // scene view settings
        MeasureSceneView.autoenablesDefaultLighting = true
        MeasureSceneView.antialiasingMode = SCNAntialiasingMode.multisampling4X
        
        // set defaults
        selectedMeasuremement = ItemLengthUILabel
        selectedNodes = lengthNodes
        determineSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        config.isLightEstimationEnabled = true
        MeasureSceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: ARSCNViewDelegate
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        var status = "Loading measurements"
        switch camera.trackingState {
        case ARCamera.TrackingState.notAvailable:
            status = "Measurements not available"
        case ARCamera.TrackingState.limited(_):
            status = "Analyzing scene"
        case ARCamera.TrackingState.normal:
            status = "Tap to measure \(selectedMeasurementValue!)"
        }
        MeasureUILabel.text = status
    }
    
    // UI actions
    func setLabelText() {
        MeasureUILabel.text = "Measuring \(selectedMeasurementValue!)"
    }
    
    // MARK: tap handlers
    func determineSelected() {
        if selectedMeasuremement == ItemLengthUILabel {
            selectedMeasurementValue = "Length"
        } else if selectedMeasuremement == ItemWidthUILabel {
            selectedMeasurementValue = "Width"
        } else if selectedMeasuremement == ItemHeightUILabel {
            selectedMeasurementValue = "Height"
        } else {
            return
        }
    }
    
    
    @objc func handleSceneViewTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: MeasureSceneView)
        let hitTest = MeasureSceneView.hitTest(location, types: [ARHitTestResult.ResultType.featurePoint])
        guard let result = hitTest.last else { return }
        
        let transform = SCNMatrix4.init(result.worldTransform)
        let vector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        let sphere = SphereNode(position: vector)
        
        if let first = selectedNodes!.first {
            selectedNodes!.append(sphere)
            let distance = sphere.distance(to: first.position)
            print(String(format: "distance: %.2f\"", distance))
            MeasureUILabel.text = String(format: "\(selectedMeasurementValue!): %.2f\"", distance)
            selectedMeasuremement!.text = String(format: "%.2f\"", distance)
            if selectedNodes!.count > 2 {
                for sphere in selectedNodes! {
                    sphere.removeFromParentNode()
                }
                selectedMeasuremement!.text = "-"
                selectedNodes! = [selectedNodes![2]]
                setLabelText()
            }
        } else {
            selectedNodes!.append(sphere)
        }
        
        for sphere in selectedNodes! {
            self.MeasureSceneView.scene.rootNode.addChildNode(sphere)
        }
    
    }
    
    // TODO: seriously refactor these handlers
    @objc func handleLengthUILabelTap(sender: UITapGestureRecognizer) {
        selectedMeasuremement = ItemLengthUILabel
        selectedNodes = lengthNodes
        determineSelected()
        setLabelText()
    }
    
    @objc func handleWidthUILabelTap(sender: UITapGestureRecognizer) {
        selectedMeasuremement = ItemWidthUILabel
        selectedNodes = widthNodes
        determineSelected()
        setLabelText()
    }
    @objc func handleHeightUILabelTap(sender: UITapGestureRecognizer) {
        selectedMeasuremement = ItemHeightUILabel
        selectedNodes = heightNodes
        determineSelected()
        setLabelText()
    }
    
    // MARK: GetShippingPriceButton
    @IBAction func GetShippingPriceButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "ShowPriceViewSegue", sender: self)
    }
    
    @IBAction func unwindToMeasureARSCNView(segue:UIStoryboardSegue) { }
}
