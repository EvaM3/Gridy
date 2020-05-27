//
//  EditorViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 16.05.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit



class EditorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        
  
    }
    

}
