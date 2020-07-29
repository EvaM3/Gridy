//
//  EditorViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 16.05.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit
import PhotosUI



class EditorViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage : UIImage?
    @IBOutlet var backButton: UIButton!
    @IBOutlet var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIButton(frame: CGRect(x: 330, y: 50, width: 30, height: 30))
        backButton.backgroundColor = .white
        backButton.setTitle("✖️", for: .normal)

        
        self.navigationController?.isNavigationBarHidden = true
        imageView.image = selectedImage
        
         let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
         let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = view.bounds
         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         view.addSubview(blurEffectView)
         backButton.removeFromSuperview()
        view.addSubview(backButton)
        backButton.bringSubviewToFront(backButton)
        
        startButton.removeFromSuperview()
        view.addSubview(startButton)
        startButton.bringSubviewToFront(startButton)
        
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
    
}
