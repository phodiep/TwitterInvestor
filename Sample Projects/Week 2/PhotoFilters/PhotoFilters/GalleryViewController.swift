//
//  GalleryViewController.swift
//  PhotoFilters
//
//  Created by Bradley Johnson on 1/12/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

protocol ImageSelectedProtocol {
  func controllerDidSelectImage(selectedImage: UIImage) -> Void
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var collectionView : UICollectionView!
  var images = [UIImage]()
  var delegate : ImageSelectedProtocol?
  var collectionViewFlowLayout : UICollectionViewFlowLayout!
  //var delegate : AnyObject <ImageSelectedProtocol>
  
  override func loadView() {
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    self.collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: rootView.frame, collectionViewLayout: collectionViewFlowLayout)
    rootView.addSubview(self.collectionView)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    collectionViewFlowLayout.itemSize = CGSize(width: 200, height: 200)
    
    self.view = rootView
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.whiteColor()
      self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "GALLERY_CELL")
      let image1 = UIImage(named: "image1.jpg")
      let image2 = UIImage(named: "image2.jpg")
      self.images.append(image1!)
      self.images.append(image2!)
      
      let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "collectionViewPinched:")
      self.collectionView.addGestureRecognizer(pinchRecognizer)
      
      // Do any additional setup after loading the view.
    }
  
  //MARK: Gesture Recognizer Actions
  
  func collectionViewPinched(sender : UIPinchGestureRecognizer) {
    
    switch sender.state {
    case .Began:
      println("began")
    case .Changed:
      println("changed with velocity \(sender.velocity)")
    case .Ended:
      println("ended")
      self.collectionView.performBatchUpdates({ () -> Void in
        if sender.velocity > 0 {
          //increase item size
          let newSize = CGSize(width: self.collectionViewFlowLayout.itemSize.width * 2, height: self.collectionViewFlowLayout.itemSize.height * 2)
          self.collectionViewFlowLayout.itemSize = newSize
        } else if sender.velocity < 0 {
          let newSize = CGSize(width: self.collectionViewFlowLayout.itemSize.width / 2, height: self.collectionViewFlowLayout.itemSize.height / 2)
          self.collectionViewFlowLayout.itemSize = newSize
          //decrease item size
        }
        
        
      }, completion: {(finished) -> Void in
        
      })
      
    default:
      println("default")
    }
    println("collection view pinched")
    
  }
  
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10000
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
//    let image = self.images[indexPath.row]
//    cell.imageView.image = image
    cell.backgroundColor = UIColor.redColor() 
    return cell
  }

  //MARK: UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.controllerDidSelectImage(self.images[indexPath.row])
    
    self.navigationController?.popViewControllerAnimated(true)
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
