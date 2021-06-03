//
//  UIImage+splitImage.swift
//  Gridy
//
//  Created by Eva Madarasz on 08.10.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Creating an array of UIImages by splitting it to rows and columns.
    /// - Parameters:
    ///   - row: Defining the desired row count
    ///   - column: Defining the column count
    /// - Returns: Returns the array of UIImages - the count will be row by column
    func splitImage(row : Int , column : Int) -> [UIImage] {
        let height =  (self.size.height) /  CGFloat (row)
        let width =  (self.size.width)  / CGFloat (column)
        var imageArr = [UIImage]()
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


