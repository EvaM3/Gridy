//
//  Roundedbuttons.swift
//  Gridy
//
//  Created by Eva Madarasz on 04.07.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//



import UIKit


class RoundedButton : UIButton {
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    layer.cornerRadius = 20.0
    clipsToBounds = true
  }
}
