//
//  GalleryCell.swift
//  fotoPhilter
//
//  Created by RYAN CHRISTENSEN on 1/12/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
  let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.imageView)
    self.backgroundColor = UIColor.blackColor()
    imageView.frame = self.bounds
    self.imageView.layer.masksToBounds = true
    self.imageView.layer.cornerRadius = 16
    self.imageView.layer.borderWidth = 3
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}
