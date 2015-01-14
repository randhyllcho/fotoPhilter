//
//  ViewController.swift
//  fotoPhilter
//
//  Created by RYAN CHRISTENSEN on 1/12/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ImageSelectedProtocol, UICollectionViewDataSource, UICollectionViewDelegate{
  
  let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let mainImageView = UIImageView()
  var collectionView : UICollectionView!
  var collectionViewYConstraint : NSLayoutConstraint!
  var originalThumbNail : UIImage!
  var filterNames = [String]()
  var imageQueue = NSOperationQueue()
  var gpuContext : CIContext!
  var thumbNails = [ThumbNail]()
  
  override func loadView() {
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    
    self.mainImageView.image = UIImage(named: "Image1.jpg")
    mainImageView.layer.masksToBounds = true
    mainImageView.contentMode = UIViewContentMode.ScaleAspectFill
    self.mainImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.mainImageView.backgroundColor = UIColor.blueColor()
    rootView.addSubview(self.mainImageView)
    rootView.backgroundColor = UIColor.lightGrayColor()
    let photoButton = UIButton()
    photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(photoButton)
    photoButton.setTitle("Photos", forState: .Normal)
    photoButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
    collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    collectionViewFlowLayout.scrollDirection = .Horizontal
    rootView.addSubview(collectionView)
    //collectionView.backgroundColor = UIColor.blueColor()
    collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "FILTER_CELL")
    
    let views = ["photoButton" : photoButton, "mainImageView" : self.mainImageView, "collectionView" : collectionView]
    
    self.setRootViewContraints(rootView, forViews: views)
    
    self.view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let galleryOption = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      let galleryVC = GalleryViewController()
      galleryVC.delegate = self
      self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      
    }
    self.alert.addAction(galleryOption)
    self.alert.addAction(cancelOption)
    
    let filterOption = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
      self.collectionViewYConstraint.constant = 20
      UIView.animateWithDuration(0.4, animations: { () -> Void in
        self.view.layoutIfNeeded()
        self.controllerDidSelectImage(self.mainImageView.image!)
      })
    }
    self.alert.addAction(filterOption)
    
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    self.setUpThumbNails()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  func setUpThumbNails() {
    self.filterNames = ["CISepiaTone","CIPhotoEffectChrome", "CIPhotoEffectNoir","CIVignette","CIColorMonochrome","CIFalseColor","CIColorMonochrome","CIColorPosterize","CIMaskToAlpha"]
    for name in self.filterNames {
      let thumbNail = ThumbNail(filterName: name, operationQueue: self.imageQueue, context: self.gpuContext)
      self.thumbNails.append(thumbNail)
    }
  }
  
//MARK: ImageSelectedDelegate
  
  func controllerDidSelectImage(image: UIImage) {
    self.mainImageView.image = image
    self.generateThumbNail(image)
    
    for thumbNail in self.thumbNails {
      thumbNail.originalImage = self.originalThumbNail
    }
    self.collectionView.reloadData()
  }
  
//MARK: Button Selectors
  func photoButtonPressed(sender: UIButton) {
    self.presentViewController(self.alert, animated: true, completion: nil)
  }
  
  func generateThumbNail(originalImage: UIImage) {
    let size = CGSize(width: 100, height: 100)
    UIGraphicsBeginImageContext(size)
    originalImage.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
    self.originalThumbNail = UIGraphicsGetImageFromCurrentImageContext()
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.thumbNails.count
  }
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as GalleryCell
    let thumbNail = self.thumbNails[indexPath.row]
    if thumbNail.originalImage != nil {
      if thumbNail.filteredImage == nil {
        thumbNail.generateFilteredImage()
        cell.imageView.image = thumbNail.filteredImage!
      }
    }
    return cell
  }
//MARK: AutoLayout constraints
  
  func setRootViewContraints(rootView : UIView, forViews views : [String : AnyObject]) {
    
    let mainImageViewConstraintsHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainImageView]|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(mainImageViewConstraintsHorizontal)
    let mainImageViewConatraintsVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-72-[mainImageView]-30-[photoButton]", options: nil, metrics: nil, views: views)
    rootView.addConstraints(mainImageViewConatraintsVertical)
    
    let photoButtonConstraintsVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[photoButton]-20-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(photoButtonConstraintsVertical)
    
    let collectionViewConstraintsHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintsHorizontal)
    let collectionViewConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView(100)]", options: nil, metrics: nil, views: views)
    self.collectionView.addConstraints(collectionViewConstraintHeight)
    let collectionViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView]-(-120)-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintVertical)
    
    //let imageView = views["imageView"] as UIImageView!
    let photoButton = views["photoButton"] as UIView!
    let photoButtonConstraintsHorizontal = NSLayoutConstraint(item: photoButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rootView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
    rootView.addConstraint(photoButtonConstraintsHorizontal)
    self.collectionViewYConstraint = collectionViewConstraintVertical.first as NSLayoutConstraint
  }

}

