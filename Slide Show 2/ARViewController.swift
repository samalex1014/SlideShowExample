//
//  ViewController.swift
//  Slide Show 2
//
//  Created by Smith, Sam on 1/15/19.
//  Copyright © 2019 Smith, Sam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var grids = [Grid]()
    var image: UIImage!
    var images = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        let touchPosition = gesture.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
        
        guard let hitTest = hitTestResults.first, let anchor = hitTest.anchor as? ARPlaneAnchor, let gridIndex = grids.index(where: { $0.anchor == anchor }) else {
            return
        }
        
        addPainting(hitTest, grids[gridIndex])
    }
    
    func addPainting(_ hitResult: ARHitTestResult, _ grid: Grid) {
        let planeGeometry = SCNPlane(width: 0.2, height: 0.35)
        let material = SCNMaterial()
        material.diffuse.contents = self.image
        planeGeometry.materials = [material]
        
        let paintingNode = SCNNode(geometry: planeGeometry)
        paintingNode.transform = SCNMatrix4(hitResult.anchor!.transform)
        paintingNode.eulerAngles = SCNVector3(paintingNode.eulerAngles.x + (-Float.pi / 2), paintingNode.eulerAngles.y, paintingNode.eulerAngles.z)
        paintingNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(paintingNode)
        images.append(paintingNode)
        grid.removeFromParentNode()
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        for image in images {
            guard let picMaterial = image.geometry?.materials.first else { break }
            
            let currImage = picMaterial.diffuse.contents as! UIImage
            var nextImage: UIImage
            
            if currImage == UIImage(named: "image1") {
                nextImage = UIImage(named: "image2")!
            } else if currImage == UIImage(named: "image2") {
                nextImage = UIImage(named: "image3")!
            } else {
                nextImage = UIImage(named: "image1")!
            }
            
            picMaterial.diffuse.contents = nextImage
            
            image.geometry?.materials[0] = picMaterial
        }
    }
    @IBAction func previousButtonPressed(_ sender: Any) {
        for image in images {
            guard let picMaterial = image.geometry?.materials.first else { break }
            
            let currImage = picMaterial.diffuse.contents as! UIImage
            var nextImage: UIImage
            
            if currImage == UIImage(named: "image1") {
                nextImage = UIImage(named: "image3")!
            } else if currImage == UIImage(named: "image2") {
                nextImage = UIImage(named: "image1")!
            } else {
                nextImage = UIImage(named: "image2")!
            }
            
            picMaterial.diffuse.contents = nextImage
            
            image.geometry?.materials[0] = picMaterial
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = Grid(anchor: planeAnchor)
        self.grids.append(grid)
        node.addChildNode(grid)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == planeAnchor.identifier
            }.first
        
        guard let foundGrid = grid else {
            return
        }
        
        foundGrid.update(anchor: planeAnchor)
    }
}
