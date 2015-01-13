//
//  ViewController.swift
//  fotoPhilter
//
//  Created by RYAN CHRISTENSEN on 1/12/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: UIAlertControllerStyle.ActionSheet)

  override func loadView() {
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    rootView.backgroundColor = UIColor.lightGrayColor()
    let photoButton = UIButton()
    photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(photoButton)
    photoButton.setTitle("Photos", forState: .Normal)
    photoButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    
    let mainPic = UIImage(named: "image1.jpg")
    let imageView = UIImageView(image: mainPic)
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(imageView)
    
    let views = ["photoButton" : photoButton, "imageView" : imageView]
    self.setRootViewContraints(rootView, forViews: views)
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 3.5
    
    self.view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let galleryOption = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      let galleryVC = GalleryViewController()
      self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    let cancelOption = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      
    }
    self.alert.addAction(galleryOption)
    self.alert.addAction(cancelOption)
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }
//MARK: Button Selectors
  
  func photoButtonPressed(sender: UIButton) {
    self.presentViewController(self.alert, animated: true, completion: nil)
  }

//MARK: AutoLayout constraints
  
  func setRootViewContraints(rootView : UIView, forViews views : [String : AnyObject]) {
    
    let imageViewConstraintVert = NSLayoutConstraint.constraintsWithVisualFormat("V:|-73-[imageView]-53-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(imageViewConstraintVert)
    
    let imageViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(imageViewConstraintHorizontal)
    
    let photoButtonConstraintsVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[photoButton]-20-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(photoButtonConstraintsVertical)
    
    let imageView = views["imageView"] as UIImageView!
    let photoButton = views["photoButton"] as UIView!
    let photoButtonConstraintsHorizontal = NSLayoutConstraint(item: photoButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rootView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
    rootView.addConstraint(photoButtonConstraintsHorizontal)
  }

}

