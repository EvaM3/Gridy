//
//  UIImage+splitImage.swift
//  Gridy
//
//  Created by Eva Madarasz on 08.10.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit


extension UIImage {
    
    func splitImage(row : Int , column : Int) -> [UIImage] {
        let height =  (self.size.height) /  CGFloat (row)
        let width =  (self.size.width)  / CGFloat (column)
        var imageArr = [UIImage]()                // will contain small pieces of image
        
        for y in 0..<row{
            for x in 0..<column {
                let myRect = CGRect(x: CGFloat(x) * width, y: CGFloat(y) * height, width: width, height: height)
                if let croppedImage = self.cropImage(toRect: myRect) {
                    imageArr.append(croppedImage)
                }
            }
        }
        return imageArr
    }
}


