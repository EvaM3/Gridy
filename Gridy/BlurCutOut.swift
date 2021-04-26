//
//  BlurCutOut.swift
//  Gridy
//
//  Created by Eva Madarasz on 19.08.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit


class BlurCutOut: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        let sliceCount = 4
        
        for i in 0...sliceCount {
            path.move(to: CGPoint(x: Int(self.bounds.width) * i / sliceCount , y: 0))
            path.addLine(to: CGPoint(x: self.bounds.width  * CGFloat(i) / CGFloat(sliceCount), y: self.bounds.height))
            path.move(to: CGPoint(x: 0, y: Int(self.bounds.height) * i / sliceCount))
            path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height  * CGFloat(i) / CGFloat(sliceCount)))
        }
        path.stroke()
    }
}
