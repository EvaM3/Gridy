//
//  ViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 29.04.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit


class IntroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc var selectedImage = UIImage()
    var pickerController = UIImagePickerController()
    let pickedImages: [UIImage] = [UIImage(named: "tiger")!,UIImage(named: "stonehenge")!,UIImage(named: "books")!,UIImage(named:"church")!,UIImage(named: "machu-picchu")!]
    
    @IBOutlet var libraryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        pickerController.delegate = self
//       libraryButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        libraryButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    @IBAction func save(_ sender: Any) {
        guard selectedImage.images != nil else { return }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(getter: selectedImage), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer  ) {
        if let error = error {
        let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditorView" {
            if let destinationVC = segue.destination as? EditorViewController {
                destinationVC.selectedImage = self.selectedImage
            }
        }
    }
    
    @IBAction func pickButton(_ sender: Any) {
        if let myPicture = pickedImages.randomElement()  {
            self.selectedImage = myPicture
            performSegue(withIdentifier: "showEditorView", sender: nil)
        }
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        if pickerController.sourceType == .camera  {
            present(pickerController, animated: true, completion: nil)
        } else {
            let actionController: UIAlertController = UIAlertController(title: "Camera is not available",message: "On the simulator the camera is not available.", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void  in
            }
            actionController.addAction(cancelAction)
            self.present(actionController, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryButton(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    // image capturing is done
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            pickerController.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "showEditorView", sender: nil)
        } else {
            pickerController.dismiss(animated: true, completion: nil)
        }
        
        
    }
}

