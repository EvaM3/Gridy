//
//  EditorViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 16.05.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit



class EditorViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage : UIImage?
    @IBOutlet var backButton: UIButton!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var blurCutOut: UIView!
    @IBOutlet var blurEffectView: UIVisualEffectView!
    @IBOutlet var adjustLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustLabel.numberOfLines = 0
        
        self.navigationController?.isNavigationBarHidden = true
        imageView.image = selectedImage
        
        mask(blurEffectView, maskRect: blurCutOut.frame)
//        draw(blurCutOut, _, rect: blurCutOut.frame)
        
        blurCutOut.isUserInteractionEnabled = true
        blurCutOut.isMultipleTouchEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)) )
        pinchGesture.delegate = self
        blurCutOut.addGestureRecognizer(pinchGesture)
        
        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
        rotate.delegate = self
        blurCutOut.addGestureRecognizer(rotate)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        blurCutOut.addGestureRecognizer(gestureRecognizer)
    }
    
  
    
    
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        
        self.imageView.transform = self.imageView.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
        
    }
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        self.imageView.transform = self.imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    @ objc  func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: imageView.superview)
            imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
    }
    class CanvasView: UIViewController {


      func draw(_ rect: CGRect) {
      let path = UIBezierPath()
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: 200, y: 100))
      path.stroke()
              }
          }

    func mask(_ viewToMask: UIView, maskRect: CGRect) {
        let maskLayer = CAShapeLayer()
        let mutablePath = CGMutablePath()
        mutablePath.addRect(viewToMask.bounds)
        mutablePath.addRect(maskRect)
        maskLayer.path = mutablePath
        maskLayer.fillRule = .evenOdd
        viewToMask.layer.mask = maskLayer
    }
    
    
}
