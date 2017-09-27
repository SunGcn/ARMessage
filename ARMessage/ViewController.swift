//
//  ViewController.swift
//  ARMessage
//
//  Created by 孙港 on 2017/9/15.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension UIImage {
    func drawTextInImage(text:String)->UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        //图形重绘
        self.draw(in: CGRect(x:0,y:0,width:self.size.width,height:self.size.height))
        //水印文字属性
        let att = [NSAttributedStringKey.foregroundColor:UIColor.blue,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 50),NSAttributedStringKey.backgroundColor:UIColor.white]
        //水印文字大小
        let text = NSString(string: text)
        let size =  text.size(withAttributes: att)
        //绘制文字
        text.draw(in: CGRect(x:40,y:60, width:size.width, height:size.height), withAttributes: att)
        //从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
        
    }
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*// Set the view's delegate
        sceneView.delegate = self
        
        //Don't show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene*/
        
        
        //生成带文字图片
        let letter:String = "第一条消息 来自 孙港"
        // 取第一个字符(测试了,太长了的话,效果并不好)
        //let letter = (text as NSString).substring(to: 1)
        let sise = CGSize(width: 400, height: 50)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        // 拿到上下文
        let ctx = UIGraphicsGetCurrentContext()
       
        // 取较小的边
        //let minSide = min(400.0, 50.0)
        // 设置填充颜色
        ctx?.setFillColor(UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.75).cgColor)
        // 填充绘制
        ctx?.fill(rect)
        let attr = [ NSAttributedStringKey.foregroundColor : UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1), NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]
        // 写入文字
        (letter as NSString).draw(at: CGPoint(x: 50, y: 10), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        
        
        // 存放所有 3D 几何体的容器
        let scene = SCNScene()
        // 想要绘制的 3D 立方体
        let boxGeometry = SCNBox(width: 16, height: 2, length: 0, chamferRadius: 0)
        // 将几何体包装为 node 以便添加到 scene
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = SCNVector3Make(0, 0, -30)
        //boxNode.rotation = SCNVector4Make(0.1,0.1,0.1,.pi)
        let material = SCNMaterial()
        material.diffuse.contents = image//UIImage(named: "text1")
        let white = SCNMaterial()
        white.diffuse.contents = UIImage(named: "white")
        //let white = UIImage(named: "white")
        boxNode.geometry?.materials  = [material, white, white, white, white, white]
        boxNode.opacity = 1
        //boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        let planeGeometry = SCNPlane(width: 16,height: 2)
        planeGeometry.cornerRadius = 0.2
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(0, 0, -40)
        
        
        
        
        
        /*let boxGeometry1 = SCNBox(width: 0.5, height: 0.05, length: 0.005, chamferRadius: 0.005)
        let boxNode1 = SCNNode(geometry: boxGeometry1)
        boxNode1.position = SCNVector3Make(0.1, 0.1, -1)
        boxNode1.rotation = SCNVector4Make(0,0,0,0)
        boxNode1.opacity = 1
        boxNode1.geometry?.firstMaterial?.diffuse.contents = UIColor.white//UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1)
        
        let boxNode2 = SCNNode(geometry: boxGeometry)
        boxNode2.position = SCNVector3Make(-0.1, -0.1, -1)
        boxNode2.rotation = SCNVector4Make(0.5,0.1,0.1,.pi)
        boxNode2.opacity = 0.2
        boxNode2.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        let boxNode3 = SCNNode(geometry: boxGeometry)
        boxNode3.position = SCNVector3Make(0.1, -0.1, -1)
        boxNode3.rotation = SCNVector4Make(0.5,0.1,0.1,.pi)
        boxNode3.opacity = 0.75
        boxNode3.geometry?.firstMaterial?.diffuse.contents = UIColor.blue*/
        
        // rootNode 是一个特殊的 node，它是所有 node 的起始点
        scene.rootNode.addChildNode(boxNode)
        //scene.rootNode.addChildNode(boxNode1)
        //scene.rootNode.addChildNode(boxNode2)
        //scene.rootNode.addChildNode(boxNode3)
        
        // 将 scene 赋给 view
        sceneView.autoenablesDefaultLighting = true
        
        //let cylinder = SCNCylinder(radius:1,height:3)
        //let tree = SCNNode(geometry: cylinder)
        //scene.rootNode.addChildNode(tree)
        //cylinder.firstMaterial?.diffuse.contents = UIColor.brownColor
        
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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
}
