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
//
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//               if segue.identifier == "showPlayfieldView" {
//                   if let destinationVC = segue.destination as? PlayfieldViewController {
//                       destinationVC.crop = self.selectedImage
//                   }
//               }
//           }
           
        
        mask(blurEffectView, maskRect: blurCutOut.frame)
        //        blurCutOut.frame = BlurCutOut.self
        
        
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
    override func viewDidAppear(_ animated: Bool) {
        
        //        let concurrentQueue = DispatchQueue(label: "blurCutOut")
        //        concurrentQueue.async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.blurCutOut.setNeedsDisplay()
        }
        
        
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
        let screenshot = self.view.takeScreenshot()
        let croppedImage =  screenshot.cropImage(toRect: blurCutOut.frame)
        originalImage = croppedImage ?? UIImage()
        self.performSegue(withIdentifier: "showPlayfieldView", sender: nil)
               }
        
        
       // blurCutOut.setNeedsDisplay()
        
        
        
        
        
            //    "showPlayfieldView"
        
        
        
        
        
        
        
        
//        func cropMyImage(image: UIImage, toRect cropRect: CGRect, viewSize: CGSize? = nil ) -> UIImage? {
//            let imageScale: CGFloat
//            if let viewSize = viewSize {
//                imageScale = max(image.size.width / viewSize.width,
//                                 image.size.height / viewSize.height)
//            } else {
//                imageScale = 1
//            }
//            
//            
//            
//            let cropZone = CGRect(x:cropRect.origin.x * imageScale,        // scaling cropRect to handle images larger than shown-on-screen size
//                y:cropRect.origin.y * imageScale,
//                width:cropRect.size.width * imageScale,
//                height:cropRect.size.height * imageScale)
//            
//            
//            guard let cutImageRef: CGImage = image.cgImage?.cropping(to:cropZone)            // cropping in Core Graphics to cropZone
//                else {
//                    return nil
//            }
//            
//            
//            // Return image to UIImage
//            let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
//            return croppedImage
//        }
//        
    }
    
    
    //    func splitImage(image blurCutOut: UIImage) {
    //
    //           let row = 4
    //           let column = 4
    //           var myImage = blurCutOut.self
    //
    //           let height =  (myImage.size.height) /  CGFloat (row)
    //           let width =  (myImage.size.width)  / CGFloat (column)
    //
    //        let scale = (myImage.scale)          // remove scale
    //
    //           var imageArr = [UIImage]()                                 // will contain small pieces of image
    //           for y in 0..<row{
    //               var yArr = [UIImage]()
    //               for x in 0..<column {
    //
    //                   UIGraphicsBeginImageContextWithOptions(
    //                       CGSize(width:width, height:height),
    //                       false, 0)
    //                   let i =   (myImage.cgImage?.cropping(to:  CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale  , width: width * scale  , height: height * scale) ))   // remove scale , width, height enough
    //
    //                   let newImg = UIImage.init(cgImage: i!)
    //
    //
    //           UIGraphicsEndImageContext();
    //           yArr.append(newImg)
    //               }
    //
    //               imageArr.append(contentsOf: yArr)
    //
    //           }
    //    func takeScreenshot() -> UIImage {
    //        let rectangle = CGRect(x: -blurCutOut.frame.origin.x, y: -blurCutOut.frame.origin.y, width: self.view.bounds.width, height: self.view.bounds.height)
    //        UIGraphicsBeginImageContextWithOptions(blurCutOut.frame.size, false, 0.0)
    //
    //        self.view.drawHierarchy(in: rectangle, afterScreenUpdates: true)
    //
    //        let image = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        if image != nil {
    //            return image!
    //
    //        }
    //        return UIImage()
    //    }




func mask(_ viewToMask: UIView, maskRect: CGRect) {
    let maskLayer = CAShapeLayer()
    let mutablePath = CGMutablePath()
    mutablePath.addRect(viewToMask.bounds)
    mutablePath.addRect(maskRect)
    maskLayer.path = mutablePath
    maskLayer.fillRule = .evenOdd
    viewToMask.layer.mask = maskLayer
}



