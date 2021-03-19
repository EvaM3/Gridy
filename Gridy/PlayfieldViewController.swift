//
//  PlayfieldViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 16.05.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit
import AVFoundation


class PlayfieldViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var shuffledCollectionView: UICollectionView!
    @IBOutlet var gameCollectionView: UICollectionView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var lookUpButton: UIButton!
    @IBOutlet var restartButton: RoundedButton!
    
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
    var audioPlayer: AVAudioPlayer!
    
    @objc func showHintImage() {
        hintImage.image = originalImage
        hintImage.contentMode = .scaleToFill
        hintImage.frame = gameCollectionView.frame
        self.view.addSubview(hintImage)
        self.gameCollectionView.isHidden = true
        self.view.bringSubviewToFront(hintImage)
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(removeHintImage), userInfo: nil, repeats: false)
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 1,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: ({
                        self.hintImage.frame = CGRect(x: 0, y: 0, width: self.hintImage.frame.width, height: self.hintImage.frame.height)
                        self.hintImage.center = self.view.center
                       }), completion: nil)
    }
    
    @objc func removeHintImage() {
        self.view.sendSubviewToBack(hintImage)
        self.hintImage.removeFromSuperview()
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
        
        
        do {
            let tunePath = Bundle.main.path(forResource: "glitter", ofType: "wav")!
            let tuneUrl = URL(fileURLWithPath: tunePath)
            audioPlayer = try AVAudioPlayer(contentsOf: tuneUrl)
            audioPlayer.prepareToPlay()
        } catch {
            print("Something went wrong with audio player \(error.localizedDescription)")
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_gesture:)))
        tapGesture.numberOfTapsRequired = 2
        shuffledCollectionView.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        shuffledCollectionView.reloadData()
        gameCollectionView.reloadData()
    }
    
    func restartGame() {
        self.gameArray.removeAll()
        self.score = 0
        self.scoreLabel.text = "Score \(score)"
        self.shuffledCollectionView.reloadData()
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
    
    func solvedPuzzle() {
        if self.gameArray == self.imageArray {
            let alert = UIAlertController(title: "You Won!", message: "Congratulations✌️", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let shareMyText = "My score on Gridy is \(score)"
            let activityVc = UIActivityViewController(activityItems: [shareMyText], applicationActivities: nil)
            present(activityVc, animated: true, completion: nil)
            if let popOver = activityVc.popoverPresentationController {
                popOver.sourceView = view
                popOver.sourceView?.center = view.center
            }
            alert.addAction(okAction)
            self.present(alert,animated: true, completion: nil)
        }
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
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
        restartGame()
    }
    
    @IBAction func lookUpButtonTapped(_ sender: UIButton) {
        audioPlayer.play()
        showHintImage()
        increaseScore(n: 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        let imageView = UIImageView()
        if collectionView == shuffledCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayfieldCell", for: indexPath)
            imageView.image = shuffledArray[indexPath.row]
            shuffledCollectionView.layer.borderWidth = 0.3
            shuffledCollectionView.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.2
            cell.layer.borderColor = UIColor.darkGray.cgColor
        }
        if collectionView == gameCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
            imageView.image = gameArray[indexPath.row]
            gameCollectionView.layer.borderWidth = 0.3
            gameCollectionView.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.2
            cell.layer.borderColor = UIColor.black.cgColor
        }
        imageView.frame = cell.contentView.frame
        cell.addSubview(imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == shuffledCollectionView {
            return CGSize(width: 60, height: 60)
        } else {
            let collectionViewWidth : CGFloat = collectionView.frame.width
            let widthPerItem : CGFloat = collectionViewWidth / CGFloat(itemsPerRow)
            return CGSize(width: widthPerItem - 1, height: widthPerItem - 1)
        }
    }
    
    func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == shuffledCollectionView {
            return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == shuffledCollectionView {
            return 0.5
        } else {
            return 0
        }
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
                        self.solvedPuzzle()
                    }
                    
                    
                }
            }
            
        }
    }
}








