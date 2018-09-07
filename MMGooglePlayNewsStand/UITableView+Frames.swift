//
//  UITableView+Frames.swift
//  MMGooglePlayNewsStand
//
//  Created by mukesh mandora on 27/08/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

import UIKit

extension UITableView{
    
    @objc func framesForRowAtIndexPath(indexpath : NSIndexPath) -> CGRect{
        
        let cell = self.cellForRow(at: indexpath as IndexPath) as! NewsCellTableViewCell
        
        return self.convert(cell.frame, to: UIApplication.shared.keyWindow)
    }
}
