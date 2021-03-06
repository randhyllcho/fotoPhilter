//
//  GalleryViewController.swift
//  fotoPhilter
//
//  Created by RYAN CHRISTENSEN on 1/12/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

protocol  ImageSelectedProtocol {
  func controllerDidSelectImage(UIImage) -> Void
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
  
  var collectionView : UICollectionView!
  var images = [UIImage]()
  var delegate : ImageSelectedProtocol?
  var collectionViewFlowLayout : UICollectionViewFlowLayout!

  
  override func loadView() {
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    self.collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: rootView.frame, collectionViewLayout: collectionViewFlowLayout)
    rootView.addSubview(self.collectionView)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    collectionViewFlowLayout.itemSize = CGSize(width: 200, height: 200)
    
    collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    let views = ["collectionView" : self.collectionView]
    self.setRootViewContraints(rootView, forViews: views)
    self.view = rootView
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.whiteColor()
      self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "GALLERY_CELL")
      let image1 = UIImage(named: "image1.jpg")
      let image2 = UIImage(named: "image2.jpg")
      let image3 = UIImage(named: "image3.jpg")
      let image4 = UIImage(named: "image4.jpg")
      let image5 = UIImage(named: "image5.jpg")
      let image6 = UIImage(named: "image6.jpg")
      
      self.images.append(image1!)
      self.images.append(image2!)
      self.images.append(image3!)
      self.images.append(image4!)
      self.images.append(image5!)
      self.images.append(image6!)
      
      let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "collectionViewPinched:")
      self.collectionView.addGestureRecognizer(pinchRecognizer)
      
        // Do any additional setup after loading the view.
    }
  
  //MARK: Gesture Recognizer Action
  
  func collectionViewPinched(sender: UIPinchGestureRecognizer) {
    
    switch sender.state {
    case .Began:
      println("Began")
    case .Changed:
      println("Changed")
      self.collectionView.performBatchUpdates({ () -> Void in
        if sender.velocity > 0 {
          let newSize = CGSize(width: self.collectionViewFlowLayout.itemSize.width * 1.05, height: self.collectionViewFlowLayout.itemSize.height * 1.05)
          self.collectionViewFlowLayout.itemSize = newSize
        } else if sender.velocity < 0 {
          let newSize = CGSize(width: self.collectionViewFlowLayout.itemSize.width / 1.05, height: self.collectionViewFlowLayout.itemSize.height / 1.05)
          self.collectionViewFlowLayout.itemSize = newSize
        }
      }, completion: { (finished) -> Void in
        
      })
    case .Ended:
      println("Ended")
    default:
      println("Default")
    }
    
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.images.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
    let image = self.images[indexPath.row]
    cell.imageView.image = image
    return cell
  }

  
  func setRootViewContraints(rootView : UIView, forViews views : [String : AnyObject]) {
    
  let collectionViewVert = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: nil, metrics: nil, views: views)
  rootView.addConstraints(collectionViewVert)
  
  let collectionViewHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: nil, metrics: nil, views: views)
  rootView.addConstraints(collectionViewHorizontal)
  }
  
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
