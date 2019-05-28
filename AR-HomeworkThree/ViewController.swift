//
//  ViewController.swift
//  AR-HomeworkThree
//
//  Created by Ruslan Safin on 28/05/2019.
//  Copyright © 2019 Ruslan Safin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        var anchors = [ARImageAnchor]()
        
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        anchors.append(currentImageAnchor)
        
        let name = currentImageAnchor.referenceImage.name!
        switch name {
        case "100RUBTop":
            nodeAdded(node, for: currentImageAnchor, pasteImage: "20USDTop")
            
            DispatchQueue.main.async {
                self.sceneView.session.remove(anchor: anchor)
            }
        case "100RUBBot":
            nodeAdded(node, for: currentImageAnchor, pasteImage: "20USDBot")
            
            DispatchQueue.main.async {
                self.sceneView.session.remove(anchor: anchor)
            }
        default:
            print("ERROR Switch in line", #line)
        }
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARImageAnchor, pasteImage name: String) {
        
        let referenceImage = anchor.referenceImage
        let size = referenceImage.physicalSize
        let plane = SCNPlane(width: 1.0 * size.width, height: 1.0 * size.height)
        
        plane.firstMaterial?.diffuse.contents = UIImage(named: name)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        node.addChildNode(planeNode)
    }
}
