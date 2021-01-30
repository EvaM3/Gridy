//
//  puzzleFinished.swift
//  Gridy
//
//  Created by Eva Madarasz on 29.01.21.
//  Copyright © 2021 Eva Madarasz. All rights reserved.
//

import UIKit


struct Alert {
    private static func showAlert(on vc:PlayfieldViewController,with title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {vc.present(alert, animated: true, completion: nil)}                                                             }
    static func showSolvedPuzzleAlert(on vc:PlayfieldViewController) {
        showAlert(on: vc, with: "", message: "Great!!\n You did it!!!")
        
    }
}
