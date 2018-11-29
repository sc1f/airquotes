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
    
    struct measurementNodes {
        var length = NodeSet()
        var width = NodeSet()
        var height = NodeSet()
    }
    
    var nodes = measurementNodes()
    var currentNodes = NodeSet()
    var currentMeasurement = dimensions.length
    
    enum dimensions {
        case length
        case width
        case height
    }

    // scene setup
    var currentItem = Item(destination: "", weight: "")
    var measureStatus = "Loading measurements"
    var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var successFeedbackGenerator = UINotificationFeedbackGenerator()
    
    
    // subviews
    lazy var metadataView: ItemMetadataView = {
        let view = ItemMetadataView(currentItem: currentItem)
        view.destinationTextField.delegate = self
        view.weightTextField.delegate = self
        return view
    }()
    
    lazy var metadataSummaryView = ItemMetadataSummaryView(currentItem: currentItem)
    
    lazy var sceneView: ARSCNView = {
        let scene = ARSCNView(frame: CGRect.zero)
        scene.delegate = self
        scene.autoenablesDefaultLighting = true
        scene.antialiasingMode = SCNAntialiasingMode.multisampling4X
        let tap_recognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleSceneViewTap))
        scene.addGestureRecognizer(tap_recognizer)
        return scene
    }()
    
    var actionView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.isUserInteractionEnabled = true
        view.autoSetDimension(.height, toSize: 50.0)
        return view
    }()
    
    lazy var statusLabel: SmallLabel = {
        let label = SmallLabel(text: "", alignment: .left, font_size: 14.0, insets: UIEdgeInsets.init(top: 5.0, left: 7.5, bottom: 5.0, right: 7.5))
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.textColor = UIColor.black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6.0
        return label
    }()
    
    lazy var toggleLightButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 12.5
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.clear
        
        button.setBackgroundImage(UIImage(named: "flashoff25"), for: .normal)
        button.setBackgroundImage(UIImage(named: "flashon25"), for: .selected)
        
        button.addTarget(self, action: #selector(toggleLight), for: .touchUpInside)
        
        button.autoSetDimensions(to: CGSize.init(width: 25.0, height: 25.0))
        button.autoMatch(.width, to: .height, of: button)
        
        return button
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setBackgroundImage(UIImage(named: "clear25"), for: .normal)
        
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 12.5
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.clear
        
        button.addTarget(self, action: #selector(clearScene), for: .touchUpInside)
        
        button.autoSetDimensions(to: CGSize(width: 25.0, height: 25.0))
        button.autoMatch(.width, to: .height, of: button)
        
        return button
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
        UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.scrimView)
        }){ (_) -> Void in
            self.scrimView.frame = self.view.frame
        }
        let tap_recognizer = UITapGestureRecognizer(target: self, action: #selector(handleScrimTap))
        scrimView.addGestureRecognizer(tap_recognizer)
    }
    
    func removeScrim() {
        for view in view.subviews {
            if view.isKind(of: UIVisualEffectView.self) {
                UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                    view.removeFromSuperview()
                }, completion: nil)
            }
        }
    }
    
    @objc func handleScrimTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let filled = metadataFilled()
            let valid = !metadataDestinationTextFieldHasErrors()
            if filled && valid {
                hideMetadataView()
            }
        }
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(sceneView)
        sceneView.autoPinEdgesToSuperviewSafeArea()
        
        addScrim()
        
        view.insertSubview(metadataView, aboveSubview: scrimView)
        metadataView.autoCenterInSuperview()
        
        view.insertSubview(dimensionView, belowSubview: scrimView)
        dimensionView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), excludingEdge: .top)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        config.isLightEstimationEnabled = true
        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 50
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height - 50
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        let hasErrors = metadataDestinationTextFieldHasErrors()
        
        if hasErrors {
            return
        } else {
            metadataView.clearErrors()
        }
    }
    
    // show & clear views
    func metadataFilled() -> Bool {
        return metadataView.destinationTextField.text != "" && metadataView.weightTextField.text != ""
    }
    
    func showMetadataView() {
        addScrim()
        
        actionView.removeFromSuperview()
        
        for subview in self.view.subviews {
            if subview.isMember(of: ItemMetadataSummaryView.self){
               subview.removeFromSuperview()
            }
        }
        
        metadataView.currentItem = currentItem
        metadataView.helpLabel.text = "Edit item details"
        
        UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.metadataView)
        }, completion: nil)
        
        metadataView.autoCenterInSuperview()
    }
    
    func hideMetadataView() {
        UIView.transition(with: self.metadataView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.metadataView.removeFromSuperview()
        }, completion: nil)
        
        removeScrim()
        
        let destination = metadataView.destinationTextField.text!
        let weight = metadataView.weightTextField.text!
        
        currentItem.destination = destination
        currentItem.weight = weight
        
        metadataSummaryView = ItemMetadataSummaryView(currentItem: currentItem)
        
        let tapToEditRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleEditTap))
        metadataSummaryView.addGestureRecognizer(tapToEditRecognizer)
        
        UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.metadataSummaryView)
        }, completion: nil)
        
        metadataSummaryView.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), excludingEdge: .bottom)
        
        actionView.addSubview(statusLabel)
        statusLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
        statusLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        // add actions + status text
        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
            if device.hasTorch {
                actionView.addSubview(toggleLightButton)
                toggleLightButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 0.0)
                toggleLightButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
            }
        }
        
        actionView.addSubview(clearButton)
        clearButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0.0)
        clearButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
        
        self.view.insertSubview(actionView, aboveSubview: sceneView)
        
        actionView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10.0)
        actionView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10.0)
        actionView.autoPinEdge(.top, to: .bottom, of: metadataSummaryView, withOffset: 10.0)
    }
    
    func showNextButton() {
        dimensionView.dimensionStackView.addArrangedSubview(dimensionView.nextMeasurementButton)
        dimensionView.nextMeasurementButton.addTarget(self, action: #selector(handleNextButtonTap), for: .touchUpInside)
    }
    
    func showGetPriceButton() {
        dimensionView.dimensionStackView.addArrangedSubview(dimensionView.getPriceButton)
        dimensionView.getPriceButton.addTarget(self, action: #selector(segueToPrices), for: .touchUpInside)
    }
    
    func removeNextButton() {
        dimensionView.nextMeasurementButton.removeFromSuperview()
    }
    
    func resetButtons() {
        dimensionView.getPriceButton.removeFromSuperview()
        dimensionView.nextMeasurementButton.removeFromSuperview()
    }
    
    // MARK: UITextFieldDelegate

    func metadataDestinationTextFieldHasErrors() -> Bool {
        let length = metadataView.destinationTextField.text!.count
        return length != 0 && length < 5
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let hasErrors = metadataDestinationTextFieldHasErrors()
        if hasErrors {
            metadataView.clearErrors()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            let destinationHasErrors = metadataDestinationTextFieldHasErrors()
            if destinationHasErrors {
                metadataView.processErrors("Please enter a valid ZIP code.")
                return
            }
            
            let filled = metadataFilled()
            if filled {
                hideMetadataView()
            } else {
                metadataView.helpLabel.text = metadataView.defaultInstructionText
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 5
    }

    // Actions
    @objc func handleEditTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            showMetadataView()
        }
    }
    
    @objc func toggleLight(_ sender: UIButton!) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                var selected = false
                try device.lockForConfiguration()
                
                switch device.torchMode {
                case .on:
                    device.torchMode = .off
                    selected = false
                case .off:
                    device.torchMode = .on
                    selected = true
                case .auto:
                    device.torchMode = .off
                }
                
                sender.isSelected = selected
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    // SceneView
    @objc func handleNextButtonTap(_ sender: UIButton) {
        if currentNodes.first != nil && currentNodes.last != nil {
            nextMeasurement()
            
            switch currentMeasurement {
            case .length:
                dimensionView.dimensionLabel.text = "LENGTH"
            case .width:
                dimensionView.dimensionLabel.text = "WIDTH"
            case .height:
                dimensionView.dimensionLabel.text = "HEIGHT"
            }
            
            dimensionView.dimensionValueLabel.text = "-"
            successFeedbackGenerator.notificationOccurred(.success)
        }
    }
    
    @objc func clearScene(_ sender: UIButton!) {
        impactFeedbackGenerator.prepare()
        currentNodes.clear()
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        nodes.length.clear()
        nodes.width.clear()
        nodes.height.clear()
        
        dimensionView.dimensionLabel.text = "LENGTH"
        dimensionView.dimensionValueLabel.text = "-"
        impactFeedbackGenerator.impactOccurred()
        
        currentMeasurement = .length
        resetButtons()
    }
    
    // TODO: eventually refactor this entire block
    func processMeasurement(_ value: CGFloat) {
        
        switch currentMeasurement {
        case .length:
            currentItem.dimensions.length = value
        case .width:
            currentItem.dimensions.width = value
        case .height:
            currentItem.dimensions.height = value
        }
        dimensionView.dimensionValueLabel.text = String(format: "%.2f\"", value)
        print(currentItem.dimensions)
    }
    
    func nextMeasurement() {
        var new_measurement: dimensions
        
        switch currentMeasurement {
        case .length:
            currentNodes = nodes.length
            new_measurement = .width
        case .width:
            currentNodes = nodes.width
            new_measurement = .height
        case .height:
            return
        }
        
        removeNextButton()
        currentMeasurement = new_measurement
    }
    
    func prevMeasurement() {
        var new_measurement: dimensions
        var new_current_node: NodeSet
        
        switch currentMeasurement {
        case .length:
            new_current_node = nodes.height
            new_measurement = .height
        case .width:
            new_current_node = nodes.length
            new_measurement = .length
        case .height:
            new_current_node = nodes.width
            new_measurement = .width
        }
        
        currentNodes = new_current_node
        currentMeasurement = new_measurement
    }
    
    func removeLines() {
        currentNodes.line?.removeFromParentNode()
        currentNodes.line = nil
    }
    
    func removeSpheres() {
        currentNodes.first?.removeFromParentNode()
        currentNodes.last?.removeFromParentNode()
        currentNodes.clear()
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case ARCamera.TrackingState.notAvailable:
            measureStatus = "MEASUREMENTS UNAVAILABLE"
        case ARCamera.TrackingState.limited(_):
            measureStatus = "ANALYZING SURFACE"
        case ARCamera.TrackingState.normal:
            measureStatus = "READY TO MEASURE"
        }
        
        statusLabel.text = measureStatus
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        let alertController = UIAlertController.init(title: "Measurements not available", message: "Check your camera permissions in Settings > Privacy to allow AirQuotes access.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (_) -> Void in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleSceneViewTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(location, types: [ARHitTestResult.ResultType.featurePoint])
        guard let result = hitTest.last else { return }
        
        let transform = SCNMatrix4.init(result.worldTransform)
        let vector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        let sphere = SphereNode(position: vector)
        
        if let first = currentNodes.first {
            // calculate distance
            let distance = sphere.distance(to: first.position)
            
            processMeasurement(distance)
            
            if currentNodes.first != nil && currentNodes.last != nil {
                dimensionView.dimensionValueLabel.text = "-"
                removeLines()
                removeSpheres()
            } else {
                currentNodes.last = sphere
                self.sceneView.scene.rootNode.addChildNode(sphere)
                
                let line = first.drawLine(to: sphere)
                currentNodes.line = line
                self.sceneView.scene.rootNode.addChildNode(line)
                
                impactFeedbackGenerator.impactOccurred()
                
                if currentMeasurement == .height {
                    showGetPriceButton()
                } else {
                    showNextButton()
                }
            }
            
        } else {
            // add the first node, prepare for haptic
            removeLines()
            currentNodes.first = sphere
            self.sceneView.scene.rootNode.addChildNode(sphere)
            impactFeedbackGenerator.prepare()
            dimensionView.dimensionValueLabel.text = "measuring..."
        }
    }
    
    // MARK: Segues
    @objc func segueToPrices(_ sender: UIButton) {
        performSegue(withIdentifier: "showPriceView", sender: self)
        clearScene(sender)
    }
    
    @IBAction func unwindToRoot(segue:UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPriceView" {
            let vc = segue.destination as! PriceViewController
            vc.currentItem = self.currentItem
        }
    }
}
