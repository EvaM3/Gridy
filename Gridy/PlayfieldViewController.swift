//
//  PlayfieldViewController.swift
//  Gridy
//
//  Created by Eva Madarasz on 16.05.20.
//  Copyright © 2020 Eva Madarasz. All rights reserved.
//

import UIKit
import AVFoundation
import Social


/// This View Controller has the collection view functions for sizing,for the indexpath for the visible cells, and spacing.It has the function for the drag session and an extension for the CollectionViewDropDelegate.Contains the variables for the arrays of images,  the sound for the audio player. Has the tapGesture Recognizer, the function for the solved puzzle with the alert controller. Moreover contains the functions for restarting, increasing the score, showing the original image for a couple of seconds in the (hint) eye button. And an extra function for starting the game over as well.
class PlayfieldViewController: UIViewController {
    
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
    
    // MARK: -Lifecycle functions
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
        shuffledCollectionView.layer.borderWidth = 0.3
        shuffledCollectionView.layer.borderColor = UIColor.black.cgColor
        gameCollectionView.layer.borderWidth = 0.3
        gameCollectionView.layer.borderColor = UIColor.black.cgColor
        
        self.navigationController?.isNavigationBarHidden = true
        shuffledCollectionView.isScrollEnabled = false
        shuffledCollectionView.isUserInteractionEnabled = true
        shuffledCollectionView.dragInteractionEnabled = true
        gameCollectionView.dragInteractionEnabled = true
        gameCollectionView.isUserInteractionEnabled = true
        shuffledCollectionView.dragDelegate = self
        gameCollectionView.dragDelegate = self
        shuffledCollectionView.dropDelegate = self
        gameCollectionView.dropDelegate = self
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        
        
        do {
            let tunePath = Bundle.main.path(forResource: "glitter", ofType: "wav")!                                          // Adding the sound to the game
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
    
    
    func solvedPuzzle() {                                      // Checking the state of the puzzle, when it's solved, through an alert makes it possible to share on social media
        if self.gameArray == self.imageArray {
            let shareMyImage = self.imageArray
            let shareMyText = "My score on Gridy is \(score)"
            let alert = UIAlertController(title: "You Won! Congratulations✌️", message: "Do you want to share your score? \(shareMyText)", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            let actionOne = UIAlertAction(title: "Share on your social sites!", style: .default) { (action) in
                let activityVc = UIActivityViewController(activityItems: [shareMyText, shareMyImage] , applicationActivities: nil)
                if let popOver = activityVc.popoverPresentationController {
                    popOver.sourceView = self.view
                    popOver.sourceView?.center = self.view.center
                }
                self.present(alert,animated: true, completion: nil)
                self.present(activityVc, animated: true, completion: nil)
            }
            alert.addAction(actionOne)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            self.shuffledCollectionView.collectionViewLayout.invalidateLayout()
            self.shuffledCollectionView.setNeedsDisplay()
            self.gameCollectionView.collectionViewLayout.invalidateLayout()
            self.gameCollectionView.setNeedsDisplay()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.shuffledCollectionView.reloadData()
            self.gameCollectionView.reloadData()
        }
    }
    
    func restartGame() {               // Completely restarting the game
        self.gameArray.removeAll()
        self.score = 0
        self.scoreLabel.text = "Score \(score)"
        self.shuffledCollectionView.reloadData()
    }
    
    func increaseScore(n: Int = 1) {
        score += n
        scoreLabel.text = "Score: \(score)"
    }
    func sendingImages(receiver: UICollectionView, senderIndexPath: IndexPath, receiverIndexPath: IndexPath) {   // Enables to swap images from both collectionviews.
  if receiver == shuffledCollectionView {
      shuffledArray[receiverIndexPath.row] =  gameArray[senderIndexPath.row]
      gameArray[senderIndexPath.row] = defaultImage
  } else {
      gameArray[receiverIndexPath.row] = shuffledArray[senderIndexPath.row]
      shuffledArray[senderIndexPath.row] = defaultImage
  }
  self.shuffledCollectionView.reloadData()
  self.gameCollectionView.reloadData()
}
    
    @objc private func didDoubleTap(_gesture: UITapGestureRecognizer) {       // By double tapping starts the game over, with extra 5 points to the score as punishment
        gameArray = []
        shuffledArray = imageArray.shuffled()
        self.shuffledCollectionView.reloadData()
        self.gameCollectionView.reloadData()
        increaseScore(n: 5)
    }
    
    @objc func showHintImage() {           // Will show hint image for 2 seconds with animation.
        hintImage.image = originalImage
        hintImage.contentMode = .scaleToFill
        hintImage.frame = gameCollectionView.frame
        self.view.addSubview(hintImage)
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
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        restartGame()
    }
    
    @IBAction func lookUpButtonTapped(_ sender: UIButton) {
        audioPlayer.play()
        showHintImage()
        increaseScore(n: 2)
    }
}


// MARK: - Extensions for layout and datasource

extension PlayfieldViewController: UICollectionViewDataSource {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {  // Number of items in both collectionview.
    if collectionView == shuffledCollectionView {
        return shuffledArray.count
    }
    if collectionView == gameCollectionView {
        return gameArray.count
    }
    return 0
}
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // Defines the images for each collectionviews, and their colors.
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
    if collectionView == shuffledCollectionView {
        cell.imageView.image = shuffledArray[indexPath.row]
        cell.layer.borderColor = UIColor.darkGray.cgColor
    }
    if collectionView == gameCollectionView {
        cell.imageView.image = gameArray[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
    }
    cell.layer.borderWidth = 0.2
    return cell
    }
}

extension PlayfieldViewController: UICollectionViewDelegateFlowLayout {     // Contains the cell size for both collectionviews
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == shuffledCollectionView {
        let columnCount:Int = gameArray.count / 3 + Int(3.5)
        let collectionViewWidth : CGFloat = shuffledCollectionView.frame.width - CGFloat((columnCount))
        let widthPerItem : CGFloat = collectionViewWidth / CGFloat(columnCount)
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    } else {
        let collectionViewWidth : CGFloat = collectionView.frame.width - (itemsPerRow)
        let widthPerItem : CGFloat = collectionViewWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView == shuffledCollectionView {
        return UIEdgeInsets(top: 0.4, left: 0.4, bottom: 0.4, right: 0.4)
    } else {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView == shuffledCollectionView {
        return 0.3
    } else {
        return 0
    }
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView == shuffledCollectionView {
        return 1
    } else {
        return 0
    }
}
}
extension PlayfieldViewController: UICollectionViewDragDelegate {   // Defines which collectioncell will be dragged
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item: UIImage
        if collectionView == shuffledCollectionView {
            item = self.shuffledArray[indexPath.row]
        } else {
            item = self.gameArray[indexPath.row]
        }
        if item == defaultImage {
            return [UIDragItem]()
        }
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }
}

extension PlayfieldViewController: UICollectionViewDropDelegate { // Defines which collectioncell will be dropped.
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard let destinationIndexPath = destinationIndexPath else {
            return UICollectionViewDropProposal(operation: .move)
        }
        if collectionView == shuffledCollectionView {
            if shuffledArray[destinationIndexPath.row] != self.defaultImage {
                return UICollectionViewDropProposal(operation: .cancel)
            }
        } else {
            if gameArray[destinationIndexPath.row] != self.defaultImage {
                
                return UICollectionViewDropProposal(operation: .cancel)
            }
        }
        return UICollectionViewDropProposal(operation: .move)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let itemCount = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(row: itemCount, section: 0)
        }
        coordinator.session.loadObjects(ofClass: UIImage.self) { (NSItemProviderReadingItems) in
            if let imagesDropped = NSItemProviderReadingItems as? [UIImage] {
                if imagesDropped.count > 0 {
                    if let removeIndexPath = coordinator.items.first?.dragItem.localObject as? IndexPath  {              // reading  the sticker info
                        self.sendingImages(receiver: collectionView, senderIndexPath: removeIndexPath, receiverIndexPath: destinationIndexPath)
                        self.increaseScore()
                        self.solvedPuzzle()
                        
                    }
                }
            }
        }
    }
}

