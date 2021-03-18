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
     //   self.blurCutOut.draw(blurCutOut.bounds)
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



//0x6000035817a0> - changing property contentsGravity in transform-only layer, will have no effect
//2021-03-18 17:31:03.155990+0100 Gridy[1316:71680] <CATransformLayer: 0x600003596a60> - changing property contentsGravity in transform-only layer, will have no effect
//2021-03-18 17:31:03.156411+0100 Gridy[1316:71680] <CATransformLayer: 0x600003594e80> - changing property contentsGravity in transform-only layer, will have no effect
//2021-03-18 17:31:06.877728+0100 Gridy[1316:71680] [plugin] AddInstanceForFactory: No factory registered for id <CFUUID 0x600003582ca0> F8BB1C28-BAE8-11D6-9C31-00039315CD46
//2021-03-18 17:31:08.028082+0100 Gridy[1316:71680] [LayoutConstraints] Unable to simultaneously satisfy constraints.
//    Probably at least one of the constraints in the following list is one you don't want.
//    Try this:
//        (1) look at each constraint and try to figure out which you don't expect;
//        (2) find the code that added the unwanted constraint or constraints and fix it.
//(
//    "<NSLayoutConstraint:0x6000016e8870 Gridy.RoundedButton:0x7fc00a432290'Restart'.height == 30   (active)>",
//    "<NSLayoutConstraint:0x6000016e8eb0 UILabel:0x7fc00a436840'Drag pieces to the grid s...'.height == 30   (active)>",
//    "<NSLayoutConstraint:0x6000016e9040 UILayoutGuide:0x600000ca40e0'UIViewSafeAreaLayoutGuide'.bottom == UIStackView:0x7fc00a435ad0.bottom + 8   (active)>",
//    "<NSLayoutConstraint:0x6000016e9220 UIStackView:0x7fc00a435ad0.top == UILayoutGuide:0x600000ca40e0'UIViewSafeAreaLayoutGuide'.top + 8   (active)>",
//    "<NSLayoutConstraint:0x6000016f3a20 'UISV-canvas-connection' UIStackView:0x7fc00a435df0.top == Gridy.RoundedButton:0x7fc00a432290'Restart'.top   (active)>",
//    "<NSLayoutConstraint:0x6000016f3a70 'UISV-canvas-connection' V:[Gridy.RoundedButton:0x7fc00a432290'Restart']-(0)-|   (active, names: '|':UIStackView:0x7fc00a435df0 )>",
//    "<NSLayoutConstraint:0x6000016f5310 'UISV-canvas-connection' UIStackView:0x7fc00a435c60.top == UIStackView:0x7fc00a435df0.top   (active)>",
//    "<NSLayoutConstraint:0x6000016f5360 'UISV-canvas-connection' V:[UILabel:0x7fc00a436840'Drag pieces to the grid s...']-(0)-|   (active, names: '|':UIStackView:0x7fc00a435c60 )>",
//    "<NSLayoutConstraint:0x6000016f3d90 'UISV-canvas-connection' UIStackView:0x7fc00a435ad0.top == UIStackView:0x7fc00a435c60.top   (active)>",
//    "<NSLayoutConstraint:0x6000016f3c50 'UISV-canvas-connection' V:[UIStackView:0x7fc00a435c60]-(0)-|   (active, names: '|':UIStackView:0x7fc00a435ad0 )>",
//    "<NSLayoutConstraint:0x6000016f53b0 'UISV-spacing' V:[UIStackView:0x7fc00a435df0]-(14)-[UILabel:0x7fc00a436840'Drag pieces to the grid s...']   (active)>",
//    "<NSLayoutConstraint:0x6000016e99a0 'UIView-Encapsulated-Layout-Height' UIView:0x7fc00a435960.height == 667   (active)>",
//    "<NSLayoutConstraint:0x6000016e9130 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600000ca40e0'UIViewSafeAreaLayoutGuide']-(0)-|   (active, names: '|':UIView:0x7fc00a435960 )>",
//    "<NSLayoutConstraint:0x6000016e9090 'UIViewSafeAreaLayoutGuide-top' V:|-(20)-[UILayoutGuide:0x600000ca40e0'UIViewSafeAreaLayoutGuide']   (active, names: '|':UIView:0x7fc00a435960 )>"
//)
//
//Will attempt to recover by breaking constraint
//<NSLayoutConstraint:0x6000016e8870 Gridy.RoundedButton:0x7fc00a432290'Restart'.height == 30   (active)>
//
//Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
//The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
