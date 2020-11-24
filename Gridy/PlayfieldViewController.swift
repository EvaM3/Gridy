//
//  PlayfieldViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 16.05.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit


class PlayfieldViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var shuffledCollectionView: UICollectionView!
    @IBOutlet var gameCollectionView: UICollectionView!
    
    var imageArray : [UIImage] = []
    var gameArray : [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shuffledCollectionView.delegate = self
        gameCollectionView.delegate = self
        
        shuffledCollectionView.dataSource = self
        gameCollectionView.dataSource = self
        
        self.view.addSubview(shuffledCollectionView)
        self.view.addSubview(gameCollectionView)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        let imageView = UIImageView(frame: cell.contentView.frame)
        if collectionView == shuffledCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayfieldCell", for: indexPath)
            imageView.image = imageArray[indexPath.row]
        }
        if collectionView == gameCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
            imageView.image = UIImage()
            cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green:255.0/255.0, blue:CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
        }
        cell.addSubview(imageView)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width:80 , height:80)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)

        return cellSize
    }
}


