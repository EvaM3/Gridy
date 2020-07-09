//
//  Roundedbuttons.swift
//  Gridy
//
//  Created by Eva Madarasz on 04.07.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import Foundation

import UIKit




class RoundedButton : UIButton {
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    layer.borderWidth = 1.0
    layer.cornerRadius = 5.0
    clipsToBounds = true
  }
}
