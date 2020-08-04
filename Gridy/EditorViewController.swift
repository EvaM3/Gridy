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
    
    var blurEffectView = UIVisualEffectView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    mask(blurEffectView, maskRect: blurCutOut.frame)
        
        //   let blurFrame = mask(blurEffectView, maskRect: CGRect(x: 100, y: 100, width: 150, height: 150))
        
        //        blurEffectView.frame(forAlignmentRect: CGRect(x: 100, y: 100, width: 150, height: 150))
        
        
        //        let backButton = UIButton(frame: CGRect(x: 330, y: 50, width: 30, height: 30))
        //        backButton.backgroundColor = .white
        //        backButton.setTitle("✖️", for: .normal)
        // startButton.frame(forAlignmentRect: CGRect(x: 5, y: 10, width: 80, height: 30))
        
        
        //  let startButton = UIButton(frame: CGRect(x: 100, y: 50, width: 80, height: 30))
        
        self.navigationController?.isNavigationBarHidden = true
        imageView.image = selectedImage
        
        //         let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        //         blurEffectView = UIVisualEffectView(effect: blurEffect)
        //         blurEffectView.frame = view.bounds
        //         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        mask(blurEffectView, maskRect: CGRect(x: 50, y: 50, width: 200, height: 200))
        //         view.addSubview(blurEffectView)
        //         backButton.removeFromSuperview()
        //        view.addSubview(backButton)
        //        backButton.bringSubviewToFront(backButton)
        //        startButton.removeFromSuperview()
        //        view.addSubview(startButton)
        //        startButton.bringSubviewToFront(startButton)
        //        self.view.addSubview(startButton)
        // let maskView = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        //maskView.backgroundColor = .red
        //blurEffectView.mask = maskView
        // maskView.bringSubviewToFront(maskView)
        /*  let maskView = UIView(frame: view.bounds)
         view.addSubview(maskView)
         func mask(_ viewToMask: UIView, maskRect: CGRect) {
         let maskLayer = CAShapeLayer()
         let path = CGPath(rect: maskRect, transform: nil)
         maskLayer.path = path
         viewToMask.layer.mask = maskLayer
         }
         mask(maskView, maskRect: CGRect(x: 150, y: 150, width: 100, height: 100)
         let pictureView = UIView(frame: CGRect(x: 150, y: 150, width: 100, height: 100))
         pictureView.bringSubviewToFront(imageView)
         view.addSubview(pictureView)
         let maskView = UIView(frame: CGRect(x: 150, y: 150, width: 100, height: 100))
         maskView.bringSubviewToFront(imageView)
         pictureView.mask = maskView */
        
        
        
        
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)) )
        pinchGesture.delegate = self
        imageView.addGestureRecognizer(pinchGesture)
        
        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
        rotate.delegate = self
        imageView.addGestureRecognizer(rotate)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        if let view = pinch.view {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
    }
    @ objc  func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
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
