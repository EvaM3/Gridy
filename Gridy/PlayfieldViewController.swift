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
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var lookUpButton: UIButton!
    
    
    
    var imageArray : [UIImage] = []
    var gameArray : [UIImage] = []
    var originalImage = UIImage()
    let defaultImage : UIImage = UIImage(named: "placeHolder")!
    var shuffledArray : [UIImage] = []
    let itemsPerRow: CGFloat = 4
    let collectionViewIdentifier = "PlayfieldCell"
    let gameCollectionViewIdentifier = "GameCell"
    var gameTimer: Timer?
    var score = 0
    var hintImage = UIImageView()
    
    
    
              
    @objc func showHintImage() {
        hintImage.image = originalImage
        hintImage.contentMode = .scaleToFill
        hintImage.frame = gameCollectionView.frame
        self.view.addSubview(hintImage)
        self.gameCollectionView.isHidden = true
        self.view.bringSubviewToFront(hintImage)
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(removeHintImage), userInfo: nil, repeats: false)
              }
    @objc func removeHintImage() {
                  self.view.sendSubviewToBack(hintImage)
                  self.gameCollectionView.isHidden = false
                  
              }
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shuffledCollectionView.delegate = self
        gameCollectionView.delegate = self
        shuffledCollectionView.dataSource = self
        gameCollectionView.dataSource = self
        imageArray = originalImage.splitImage(row: Int(itemsPerRow), column: Int(itemsPerRow))
        scoreLabel.text = "Score: \(score)"
        gameArray = Array(repeating: defaultImage, count: 16)
        shuffledArray = imageArray.shuffled()
      

    
    
        self.navigationController?.isNavigationBarHidden = true
        shuffledCollectionView.isScrollEnabled = false
        shuffledCollectionView.isUserInteractionEnabled = true
        shuffledCollectionView.dragInteractionEnabled = true
        gameCollectionView.dragInteractionEnabled = true
//        shuffledCollectionView.dragDelegate = self
//        gameCollectionView.dragDelegate = self
//        shuffledCollectionView.dropDelegate = self
//        gameCollectionView.dropDelegate = self

        
        
        self.view.addSubview(shuffledCollectionView)
        self.view.addSubview(gameCollectionView)
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_gesture:)))
        tapGesture.numberOfTapsRequired = 2
        shuffledCollectionView.addGestureRecognizer(tapGesture)
        
        
        
        }
    override func viewDidAppear(_ animated: Bool) {
        shuffledCollectionView.reloadData()
            }
        
    @objc func increaseScore(n: Int = 1) {
        score += n
        scoreLabel.text = "Score: \(score)"
    }
        
    @objc private func didDoubleTap(_gesture: UITapGestureRecognizer) {
        gameArray = []
        shuffledArray = imageArray.shuffled()
        self.shuffledCollectionView.reloadData()
        self.gameCollectionView.reloadData()
        increaseScore(n: 5)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shuffledCollectionView {
            return shuffledArray.count
        }
        if collectionView == gameCollectionView {
            return gameArray.count
        }
        return 0
    }

    
    @IBAction func lookUpButtonTapped(_ sender: UIButton) {
       showHintImage()
        increaseScore(n: 2)
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        let imageView = UIImageView()
        if collectionView == shuffledCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayfieldCell", for: indexPath)
            imageView.image = shuffledArray[indexPath.row]

        }
        if collectionView == gameCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
            imageView.image = gameArray[indexPath.row]

        }
        imageView.frame = cell.contentView.frame
        cell.addSubview(imageView)
        return cell

    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth : CGFloat = collectionView.frame.width
        let widthPerItem : CGFloat = collectionViewWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    

        func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.zero
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if shuffledArray[indexPath.row] == defaultImage {
            return [UIDragItem]()
        }
        let item = self.shuffledArray[indexPath.row]
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let itemCount = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(row: itemCount, section: 0)
        }


        coordinator.session.loadObjects(ofClass: UIImage.self) { (NSItemProviderReadingItems) in
            if let imagesDropped = NSItemProviderReadingItems as? [UIImage] {
                if imagesDropped.count > 0 {
                    let newImage = imagesDropped[0]
                    self.gameArray.remove(at: destinationIndexPath.row)
                    self.gameArray.insert(newImage, at: destinationIndexPath.row)
                    collectionView.reloadData()
                    if let removeIndexPath = coordinator.items.first?.dragItem.localObject as? IndexPath  {
                        self.shuffledArray.remove(at:removeIndexPath.row)
                        self.shuffledArray.insert(self.defaultImage, at: removeIndexPath.row)
                        self.shuffledCollectionView.reloadData()
                        self.increaseScore()
                    }


                }
            }

//
//
//
//
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageArray.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell = UICollectionViewCell()
//        let imageView = UIImageView(frame: cell.contentView.frame)
//        if collectionView == shuffledCollectionView {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayfieldCell", for: indexPath)
//            imageView.image = imageArray[indexPath.row]
//        }
//        if collectionView == gameCollectionView {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
//            imageView.image = UIImage()
//            cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green:255.0/255.0, blue:CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
//        }
//        cell.addSubview(imageView)
//        return cell
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellSize = CGSize(width:80 , height:80)
//
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = cellSize
//        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//
//    return cellSize
//    }
//}

        }
    }
}


