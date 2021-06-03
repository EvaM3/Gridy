//
//  UIImage+cropImage.swift
//  Gridy
//
//  Created by Eva Madarasz on 08.10.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Extension for UIImage, which is cropping from an image - a CGRect
    /// - Parameter cropRect: This is the rectangle, which will be cropped out from the image.
    /// - Returns: A UIImage , if the rectangle cropped out is valid or nil.
    func cropImage(toRect cropRect: CGRect) -> UIImage? {
        let imageScale = self.scale
        let cropZone = CGRect(x: cropRect.origin.x * imageScale,
                              y: cropRect.origin.y * imageScale,
                              width: cropRect.size.width * imageScale,
                              height: cropRect.size.height * imageScale)
        guard let cutImageRef: CGImage = self.cgImage?.cropping(to: cropZone) else {
            return nil
        }
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}

