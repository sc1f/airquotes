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
    
    // lol refactor
    var lengthNodes: [SphereNode] = []
    var widthNodes: [SphereNode] = []
    var heightNodes: [SphereNode] = []
    var selectedNodes: [SphereNode]?
    
    var selectedMeasuremement: UILabel?
    var selectedMeasurementValue: String?

    // scene setup
    var currentItem = Item(destination: "", weight: "")
    var measureStatus = "Loading measurements"
    
    // subviews
    lazy var metadataView: ItemMetadataView = {
        let view = ItemMetadataView(currentItem: currentItem)
        view.destinationTextField.delegate = self
        view.weightTextField.delegate = self
        return view
    }()
    
    var metadataSummaryView: ItemMetadataSummaryView?
    
    lazy var sceneView: ARSCNView = {
        let scene = ARSCNView(frame: CGRect.zero)
        scene.delegate = self
        scene.autoenablesDefaultLighting = true
        scene.antialiasingMode = SCNAntialiasingMode.multisampling4X
        return scene
    }()

    lazy var scrimView: UIVisualEffectView = {
        let scrim = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .dark))
        return scrim
    }()
    
    lazy var dimensionView: ItemDimensionsView = {
        return ItemDimensionsView(frame: CGRect.zero)
    }()
    
    // UI methods
    func addScrim() {
        self.view.addSubview(scrimView)
        scrimView.frame = view.frame
    }
    
    func removeScrim() {
        for view in view.subviews {
            if view.isKind(of: UIVisualEffectView.self) {
                UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    view.removeFromSuperview()
                }, completion: nil)
            }
        }
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneView)
        sceneView.autoPinEdgesToSuperviewEdges()
        
        addScrim()
        
        view.insertSubview(metadataView, aboveSubview: scrimView)
        metadataView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.init(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0), excludingEdge: .bottom)
        
        view.insertSubview(dimensionView, belowSubview: scrimView)
        dimensionView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.init(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0), excludingEdge: .top)
        
        selectedNodes = lengthNodes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        config.isLightEstimationEnabled = true
        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func metadataFilled() -> Bool {
        return metadataView.destinationTextField.text != "" && metadataView.weightTextField.text != ""
    }
    
    func showMetaDataView() {
        addScrim()
        
        UIView.transition(with: self.view, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.metadataSummaryView!.removeFromSuperview()
        }, completion: nil)
        
        metadataView.currentItem = currentItem
        metadataView.helpLabel.text = "Edit Item Details"
        view.addSubview(metadataView)
        
        metadataView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.init(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0), excludingEdge: .bottom)
    }
    
    func hideMetadataView() {
        UIView.transition(with: self.view, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.metadataView.removeFromSuperview()
        }, completion: nil)
        
        removeScrim()
        
        let destination = metadataView.destinationTextField.text!
        let weight = metadataView.weightTextField.text!
        
        currentItem.destination = destination
        currentItem.weight = weight
        
        metadataSummaryView = ItemMetadataSummaryView.init(currentItem: currentItem)
        metadataSummaryView?.currentItem = currentItem
        
        view.addSubview(metadataSummaryView!)
        metadataSummaryView?.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), excludingEdge: .bottom)
        
        let tapToEditRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleEditTap))
        metadataSummaryView!.addGestureRecognizer(tapToEditRecognizer)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            let filled = metadataFilled()
            if filled {
                hideMetadataView()
            } else {
                metadataView.helpLabel.text = "Enter Item Details"
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        let filled = metadataFilled()
        if filled {
            hideMetadataView()
        }
    }
    
    
    // Gesture Recognizers
    @objc func handleEditTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            showMetaDataView()
        }
    }
    
    // more bad code to refactor
    
    // MARK: ARSCNViewDelegate
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case ARCamera.TrackingState.notAvailable:
            measureStatus = "Measurements not available"
            dimensionView.directionLabel.text = measureStatus
        case ARCamera.TrackingState.limited(_):
            measureStatus = "Analyzing scene"
            dimensionView.directionLabel.text = measureStatus
        case ARCamera.TrackingState.normal:
            measureStatus = "Tap to measure"
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        let alertController = UIAlertController.init(title: "Measurements Not Available", message: "Check your camera permissions in Settings > Privacy to allow AirQuotes access.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (_) -> Void in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func processMeasurement(value: CGFloat, target: String) {
        var current_dimensions = currentItem.dimensions
        
        if target == "length" {
            current_dimensions.length = value
            dimensionView.lengthValueLabel.text = String(format: "%.2f\"", value)
        } else if target == "width" {
            current_dimensions.width = value
            dimensionView.widthValueLabel.text = String(format: "%.2f\"", value)
        } else if target == "height" {
            current_dimensions.height = value
            dimensionView.heightValueLabel.text = String(format: "%.2f\"", value)
        } else {
            return
        }
    }
    
    func selectedDimension() -> String {
        let selected = selectedNodes!
        if selected == lengthNodes {
            return "length"
        } else if selected == widthNodes {
            return "width"
        } else if selected == heightNodes {
            return "height"
        } else {
            return ""
        }
    }
    
    func selectNextDimensionForMeasure() {
        let current = selectedDimension()
        
        if current == "length" {
            selectedNodes = widthNodes
        } else if current == "width" {
            selectedNodes = heightNodes
        } else if current == "height" {
            selectedNodes = lengthNodes
        }
    }
    
    @objc func handleSceneViewTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(location, types: [ARHitTestResult.ResultType.featurePoint])
        guard let result = hitTest.last else { return }
        
        let transform = SCNMatrix4.init(result.worldTransform)
        let vector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        let sphere = SphereNode(position: vector)
        
        if let first = selectedNodes!.first {
            // calculate distance
            selectedNodes!.append(sphere)
            let distance = sphere.distance(to: first.position)
            print(String(format: "distance: %.2f\"", distance))
            
            processMeasurement(value: distance, target: selectedDimension())
            
            if selectedNodes!.count > 2 {
                for sphere in selectedNodes! {
                    sphere.removeFromParentNode()
                }
                processMeasurement(value: 0.0, target: selectedDimension())
                selectedNodes! = [selectedNodes![2]]
            }
            
            selectNextDimensionForMeasure()
        } else {
            // add the first node
            dimensionView.directionLabel.text = "Measuring \(selectedDimension())"
            selectedNodes!.append(sphere)
        }
        
        for sphere in selectedNodes! {
            self.sceneView.scene.rootNode.addChildNode(sphere)
        }
    
    }
}
