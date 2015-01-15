//
//  PhotosViewController.swift
//  fotoPhilter
//
//  Created by RYAN CHRISTENSEN on 1/14/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  var assetsFetch : PHFetchResult!
  var assetCollection : PHAssetCollection!
  var imageCacheManager = PHCachingImageManager()
  
  var collectionView : UICollectionView!
  
  var destinationImageSize : CGSize!
  
  var delegate : ImageSelectedProtocol?
  
  override func loadView() {
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    self.collectionView = UICollectionView(frame: rootView.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    
    let flowlayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
    flowlayout.itemSize = CGSize(width: 100, height: 100)
    
    rootView.addSubview(collectionView)
    collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    var views = ["collectionView" : self.collectionView]
    
    self.setrootViewConstraints(rootView, forViews: views)
    
    self.view = rootView
  }
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.imageCacheManager = PHCachingImageManager()
    self.assetsFetch = PHAsset.fetchAssetsWithOptions(nil)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "PHOTO_CELL")
      // Do any additional setup after loading the view.
    }
  
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.assetsFetch.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTO_CELL", forIndexPath: indexPath) as GalleryCell
    let asset = self.assetsFetch[indexPath.row] as PHAsset
    
    self.imageCacheManager.requestImageForAsset(asset, targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.AspectFill, options: nil) { (requestedImage, info) -> Void in
      cell.imageView.image = requestedImage
    }
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let selectedAset = self.assetsFetch[indexPath.row] as PHAsset
    self.imageCacheManager.requestImageForAsset(selectedAset, targetSize: self.destinationImageSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (requestedImage, info) -> Void in
      println()
      self.delegate?.controllerDidSelectImage(requestedImage)
      self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
  }
  
  func setrootViewConstraints(rootView: UIView, forViews views : [String : AnyObject]) {
    let collectionViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: nil, metrics: nil
      , views: views)
    rootView.addConstraints(collectionViewConstraintVertical)
    
    let collectionViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintHorizontal)
  }

}