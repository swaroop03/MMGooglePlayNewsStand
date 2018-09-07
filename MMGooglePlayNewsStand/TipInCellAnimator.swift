//
//  TipInCellAnimator.swift
//  CardTilt
//
//  Created by Eric Cerney on 7/10/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

let TipInCellAnimatorStartTransform:CATransform3D = {
  let rotationDegrees: CGFloat = 20.0
  let rotationRadians: CGFloat = rotationDegrees * CGFloat(Double.pi/180.0)
    let offset = CGPoint(x:-20, y:400)
  var startTransform = CATransform3DIdentity
  startTransform = CATransform3DRotate(CATransform3DIdentity,
    rotationRadians, 0.0, 0.0, 1.0)
  startTransform = CATransform3DTranslate(startTransform, 0, 480, 0.0)

  return startTransform
    
  }()


let TipInCellAnimatorTransform:CATransform3D = {
    
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DMakeTranslation(0, 480, 0);
    
    return startTransform
    
    }()





class TipInCellAnimator {
  class func animate(cell:UITableViewCell) {
    let view = cell.contentView

    view.layer.transform = TipInCellAnimatorStartTransform
//    view.layer.transform=TipInCellAnimatorTransform
//    view.layer.opacity = 0.8
    
    
    UIView.animate(withDuration: 0.8) {
      view.layer.transform = CATransform3DIdentity
      view.layer.opacity = 1
    }
  }
}
