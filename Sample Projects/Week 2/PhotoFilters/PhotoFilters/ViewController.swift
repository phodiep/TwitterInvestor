//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Bradley Johnson on 1/12/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, ImageSelectedProtocol, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
   let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let mainImageView = UIImageView()
  var collectionView : UICollectionView!
  var collectionViewYConstraint : NSLayoutConstraint!
  var originalThumbnail : UIImage!
  var filterNames = [String]()
  let imageQueue = NSOperationQueue()
  var gpuContext : CIContext!
  var thumbnails = [Thumbnail]()
  
  var doneButton : UIBarButtonItem!
  var shareButton : UIBarButtonItem!

  override func loadView() {
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    rootView.addSubview(self.mainImageView)
    self.mainImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.mainImageView.backgroundColor = UIColor.blueColor()
    rootView.backgroundColor = UIColor.whiteColor()
    let photoButton = UIButton()
    photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(photoButton)
    photoButton.setTitle("Photos", forState: .Normal)
    photoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    let collectionviewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionviewFlowLayout)
    collectionviewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    collectionviewFlowLayout.scrollDirection = .Horizontal
    rootView.addSubview(collectionView)
    collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    collectionView.dataSource = self
    collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "FILTER_CELL")
    
    let views = ["photoButton" : photoButton, "mainImageView" : self.mainImageView, "collectionView" : collectionView]
    
    self.setupConstraintsOnRootView(rootView, forViews: views)
    
    self.view = rootView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
   self.doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
    self.shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "sharePressed")
    self.navigationItem.rightBarButtonItem = self.shareButton
    
    let galleryOption = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      println("gallery pressed")
      let galleryVC = GalleryViewController()
      galleryVC.delegate = self
      self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    self.alertController.addAction(galleryOption)
    
    let filterOption = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
      self.collectionViewYConstraint.constant = 20
      UIView.animateWithDuration(0.4, animations: { () -> Void in
        self.view.layoutIfNeeded()
        
      })
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
      self.navigationItem.rightBarButtonItem = doneButton
    }
    self.alertController.addAction(filterOption)
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      let cameraOption = UIAlertAction(title: "Camera", style: .Default, handler: { (action) -> Void in
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      })
      self.alertController.addAction(cameraOption)
    }
    
    let photoOption = UIAlertAction(title: "Photos", style: .Default) { (action) -> Void in
      let photosVC = PhotosViewController()
      photosVC.destinationImageSize = self.mainImageView.frame.size
      photosVC.delegate = self
      self.navigationController?.pushViewController(photosVC, animated: true)
    }
    
    self.alertController.addAction(photoOption)




    
    
    let options = [kCIContextWorkingColorSpace : NSNull()] // helps keep things fast
//    let EAGLContext = EAGLContext( EAGLRenderingAPI.OpenGLES2)
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    
    self.setupThumbnails()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  func setupThumbnails() {
    self.filterNames = ["CISepiaTone","CIPhotoEffectChrome", "CIPhotoEffectNoir"]
    for name in self.filterNames {
      let thumbnail = Thumbnail(filterName: name, operationQueue: self.imageQueue, context: self.gpuContext)
      self.thumbnails.append(thumbnail)
    }
  }
 

  //MARK: ImageSelectedDelegate
  func controllerDidSelectImage(image: UIImage) {
    println("image selected")
    self.mainImageView.image = image
    self.generateThumbnail(image)
    
    for thumbnail in self.thumbnails {
      thumbnail.originalImage = self.originalThumbnail
      thumbnail.filteredImage = nil
    }
    self.collectionView.reloadData()
  }
  
  //MARK: UIImagePickerController
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image = info[UIImagePickerControllerEditedImage] as? UIImage
    self.controllerDidSelectImage(image!)
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: Button Selectors
  
  func photoButtonPressed(sender : UIButton) {
    self.presentViewController(self.alertController, animated: true, completion: nil)
  }
  
  func generateThumbnail(originalImage: UIImage) {
    let size = CGSize(width: 100, height: 100)
    UIGraphicsBeginImageContext(size)
    originalImage.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
    self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  func donePressed() {
    self.collectionViewYConstraint.constant = -120
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.view.layoutIfNeeded()
      
    })
    self.navigationItem.rightBarButtonItem = self.shareButton
  }
  
  func sharePressed() {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
      let compViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      compViewController.addImage(self.mainImageView.image)
      self.presentViewController(compViewController, animated: true, completion: nil)
    } else {
      //tell user to sign into to twitter to use this feature
    }
    
  }
  
//MARK: UICollectionViewDataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.thumbnails.count
    
  }
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as GalleryCell
    let thumbnail = self.thumbnails[indexPath.row]
    if thumbnail.originalImage != nil {
    if thumbnail.filteredImage == nil {
      thumbnail.generateFilteredImage()
      cell.imageView.image = thumbnail.filteredImage!
      } }
    //cell.imageView.image = self.originalThumbnail
    return cell
  }
  
//MARK: Autolayout Constraints
  func setupConstraintsOnRootView(rootView : UIView, forViews views : [String : AnyObject]) {
    let photoButtonConstraintVertial = NSLayoutConstraint.constraintsWithVisualFormat("V:[photoButton]-20-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(photoButtonConstraintVertial)
    let photoButton = views["photoButton"] as UIView!
    let photoButtonConstraintHorizontal = NSLayoutConstraint(item: photoButton, attribute: .CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rootView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
    rootView.addConstraint(photoButtonConstraintHorizontal)
    photoButton.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Vertical)
    
    let mainImageViewConstraintsHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[mainImageView]-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(mainImageViewConstraintsHorizontal)
    let mainImageViewConstraintsVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-72-[mainImageView]-30-[photoButton]", options: nil, metrics: nil, views: views)
    rootView.addConstraints(mainImageViewConstraintsVertical)
    
    let collectionViewConstraintsHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintsHorizontal)
    let collectionViewConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView(100)]", options: nil, metrics: nil, views: views)
    self.collectionView.addConstraints(collectionViewConstraintHeight)
    let collectionViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView]-(-120)-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintVertical)
    self.collectionViewYConstraint = collectionViewConstraintVertical.first as NSLayoutConstraint
  
  }
  
  


}

