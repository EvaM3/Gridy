//
//  EditorViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 16.05.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit



class EditorViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var blurCutOut: UIView!
    @IBOutlet var blurEffectView: UIVisualEffectView!
    @IBOutlet var adjustLabel: UILabel!
    
    var selectedImage : UIImage?
    var originalImage = UIImage()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLabel.numberOfLines = 0
        self.navigationController?.isNavigationBarHidden = true
        imageView.image = selectedImage
   
       
       
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
    override func viewDidLayoutSubviews() {
       mask(self.blurEffectView, maskView: self.blurCutOut)
        self.blurCutOut.draw(blurCutOut.bounds)
        self.blurCutOut.setNeedsDisplay() //should trigger the draw func
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayfieldSegue" {
            if let destinationVC = segue.destination as? PlayfieldViewController {
                destinationVC.originalImage = self.selectedImage ?? UIImage()
            }
        }
    }
    @IBAction func startButtonTapped(_ sender: Any) {
        let screenshot = self.view.takeScreenshot()
        let croppedImage =  screenshot.cropImage(toRect: blurCutOut.frame)
        originalImage = croppedImage ?? UIImage()
        self.performSegue(withIdentifier: "PlayfieldSegue", sender: nil)
        
    }
    
}

func mask(_ viewToMask: UIView, maskView: UIView) {
    let maskLayer = CAShapeLayer()
    let mutablePath = CGMutablePath()
    let maskRect = maskView.convert(maskView.bounds, to: viewToMask)
    mutablePath.addRect(viewToMask.bounds)
    mutablePath.addRect(maskRect)
    maskLayer.path = mutablePath
    maskLayer.fillRule = .evenOdd
    viewToMask.layer.mask = maskLayer
}



