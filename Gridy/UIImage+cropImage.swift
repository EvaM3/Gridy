//
//  UIImage+cropImage.swift
//  Gridy
//
//  Created by Eva Madarasz on 08.10.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit

extension UIImage{
    func cropImage(toRect cropRect: CGRect) -> UIImage? {
        let imageScale = self.scale
        let cropZone = CGRect(x:cropRect.origin.x * imageScale,        // scaling cropRect to handle images larger than shown-on-screen size
            
            y:cropRect.origin.y * imageScale,
            width:cropRect.size.width * imageScale,
            height:cropRect.size.height * imageScale)
        guard let cutImageRef: CGImage = self.cgImage?.cropping(to:cropZone)            // cropping in Core Graphics to cropZone
         else {
                return nil
        }               // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}

