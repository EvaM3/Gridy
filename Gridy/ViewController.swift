//
//  ViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 29.04.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage = UIImage()
    var pickerController = UIImagePickerController()

    let pickedImages: [UIImage] = [UIImage(named: "tiger")!,UIImage(named: "stonehenge")!,UIImage(named: "books")!,UIImage(named: "church")!,UIImage(named: "machu-picchu")!]
    
    @IBAction func pickButton(_ sender: Any) {
        
        if let selectedImage = pickedImages.randomElement() {
            self.selectedImage = UIImage(named: "stonehenge")!
        }
        

      
        
        
    }
   
    
    @IBAction func cameraButton(_ sender: Any) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
      
    }
    
    
    @IBAction func libraryButton(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
       present(pickerController, animated: true, completion: nil)
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            pickerController.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "showEditorView", sender: nil)
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditorView" {
            if let destinationVC = segue.destination as? EditorViewController {
                destinationVC.selectedImage = self.selectedImage
                
            }
            
        }
  
    }
    
}


