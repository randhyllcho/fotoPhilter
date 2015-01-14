//
//  ThumbNail.swift
//  fotoPhilter
//
//  Created by RYAN CHRISTENSEN on 1/13/15.
//  Copyright (c) 2015 RYAN CHRISTENSEN. All rights reserved.
//

import UIKIT

class ThumbNail {
  
  var originalImage : UIImage?
  var filteredImage : UIImage?
  var filterName : String
  var imageQueue : NSOperationQueue
  var gpuContext : CIContext
  
  
  init(filterName: String, operationQueue: NSOperationQueue, context: CIContext) {
    self.filterName = filterName
    self.imageQueue = operationQueue
    self.gpuContext = context
  }
  func generateFilteredImage() {
    let startImage = CIImage(image: self.originalImage)
    let filter = CIFilter(name: self.filterName)
    filter.setDefaults()
    filter.setValue(startImage, forKey: kCIInputImageKey)
    let result = filter.valueForKey(kCIOutputImageKey) as CIImage
    let extent = result.extent()
    let imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
    self.filteredImage = UIImage(CGImage: imageRef)
  }
}
